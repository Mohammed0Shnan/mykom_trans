
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/repository/auth_repository.dart';
import 'package:my_kom/module_authorization/requests/login_request.dart';
import 'package:my_kom/module_authorization/requests/profile_request.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_authorization/response/register_response.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final AuthRepository _repository = new AuthRepository();
  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;
   String _verificationCode ='';
  // Delegates
  Future<bool> get isLoggedIn => _prefsHelper.isSignedIn();

  Future<String?> get userID => _prefsHelper.getUserId();

  Future<UserRole?> get userRole => _prefsHelper.getRole();

  final PublishSubject<AuthResponse> phoneVerifyPublishSubject =
  new PublishSubject();

Future<AppUser>  getCurrentUser()async{
    String? id = await _prefsHelper.getUserId();
    String? email = await _prefsHelper.getEmail();
    String? phone_number = await _prefsHelper.getPhone();
    UserRole? userRole = await _prefsHelper.getRole();
    AuthSource? authSource = await _prefsHelper.getAuthSource();
    String? user_name = await _prefsHelper.getUsername();
    AddressModel? address = await _prefsHelper.getAddress();
    String? strip_id = await _prefsHelper.getStripId();
    return AppUser(id: id!, email: email!, authSource: authSource, userRole: userRole!, address: address!, phone_number: phone_number!, user_name: user_name!,stripeId: strip_id,activeCard: null);

}
  Future<RegisterResponse> registerWithEmailAndPassword(RegisterRequest request) async {

    final bool currentLangIsArabic = UtilsConst.lang == 'ar'?true:false;

    try {
      String? token = await _repository.register(request.email , request.password);
      /// The result may be an error if a private server is connected
      print('=========== token after register =============');
      print(token);
      if(token == null)
        return RegisterResponse(data:currentLangIsArabic?'حدث خطأ في عملية التسجيل':'Error in Register', state: false);

      /// after verification email
      /// DTO
      ProfileRequest profileRequest = ProfileRequest();
      profileRequest.email = request.email;

      profileRequest.userRole = request.userRole;
      profileRequest.address = request.address;
      profileRequest.userName = request.userName;
      profileRequest.phone = request.phone;

      await _repository.createProfile(profileRequest);
      print('************************************sssss');
      return RegisterResponse(data: 'Success !', state: true);

    } catch (e) {
      String message ='';
      if (e is FirebaseAuthException) {
        {

          switch (e.code) {
            case 'email-already-in-use':
              {
                message =currentLangIsArabic?'البريد الاليكتروني قيد الاستخدام': 'Email Already In Use';
                Logger()
                    .info('AuthService', 'Email address ${request.email} already in use.');
                break;
              }

            case 'invalid-email':
              {
                message = currentLangIsArabic?'الايميل غير صحيح':'Invalid Email';

                Logger().info('AuthService', 'Email address ${request.email} is invalid.');
                break;
              }

            case 'operation-not-allowed':
              {
                message = currentLangIsArabic?'العملية غير مسموح بها':'Operation Not Allowed';
                Logger().info('AuthService', 'Error during sign up.');
                break;
              }

            case 'weak-password':{
              message = currentLangIsArabic?'كلمة السر ضعيفة':'Weak Password';
              Logger().info('AuthService',
                  'Password is not strong enough. Add additional characters including special characters and numbers.');
              break;
            }

            default:
              Logger().info('AuthService', '${e.message}');
              break;
          }
        }
        Logger().info('AuthService', 'Got Authorization Error: ${e.message}');
        return RegisterResponse(data:message, state: false);

      } else {
        return RegisterResponse(data:  currentLangIsArabic?'خطأ في عملية التسجيل':'Error in Register', state: false);
      }
    }
  }

  // Future<RegisterResponse> createProfile(ProfileRequest profileRequest) async {
  //   final bool currentLangIsArabic = UtilsConst.lang == 'ar'?true:false;
  //   try {
  //     bool result = await _repository.createProfile(profileRequest);
  //     return RegisterResponse(data: currentLangIsArabic?'تم التسجيل بنجاح': 'Success Register !', state: true);
  //   } catch (e) {
  //     return RegisterResponse(data: e.toString(), state: false);
  //   }
  // }

  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final bool currentLangIsArabic = UtilsConst.lang == 'ar'?true:false;

    try {
      LoginRequest request = LoginRequest(email, password);
      LoginResponse response = await _repository.signIn(request);

      await _loginApiUser(AuthSource.EMAIL);

      await Future.wait([
        _prefsHelper.setToken(response.token),
      ]);

      return AuthResponse(
          message:  currentLangIsArabic?'تم تسجيل الدخول بنجاح':'Login Success', status: AuthStatus.AUTHORIZED);
    } catch (e) {
      if (e is FirebaseAuthException) {
        Logger().info('AuthService', e.code.toString());
        String message ='';
        switch (e.code) {
          case 'user-not-found':
            {
              message =  currentLangIsArabic?'الحساب غير موجود':'User not found !';
              Logger()
                  .info('AuthService', 'User Not Found');
              break;
            }

          case 'wrong-password':
            {
              message = currentLangIsArabic?'كلمة السر غير صحيحة':'The password is incorrect';

              Logger().info('AuthService', 'The password is incorrect');
              break;
            }


          default:{
            message = 'Error in Login!';
            Logger().info('AuthService', '${e.message}');
            break;
          }

        }
        return AuthResponse(
            message:message , status: AuthStatus.UNAUTHORIZED);
      }
      else if(e is GetProfileException)
        {
          Logger().info('AuthService', 'Error getting Profile Fire Base API');

        }
      else
      Logger().info('AuthService', 'Error getting the token from the Fire Base API');


      return AuthResponse(
          message:currentLangIsArabic?'خطأ في عملية تسجيل الدخول': 'Error in Login!', status: AuthStatus.UNAUTHORIZED);
    }
  }

   
   //This function is private to generalize to different authentication methods 
   //  phone , email , google ...etc

  Future<void> _loginApiUser(AuthSource authSource) async {
    var user = _auth.currentUser;

    // Change This
     try{
       ProfileResponse profileResponse = await _repository.getProfile(user!.uid);
       print(profileResponse.userRole);
       await Future.wait([
         _prefsHelper.setUserId(user.uid),
         _prefsHelper.setEmail(user.email!),
         _prefsHelper.setAdderss(profileResponse.address),
         _prefsHelper.setUsername(profileResponse.userName),
         _prefsHelper.setPhone(profileResponse.phone),
         _prefsHelper.setAuthSource(authSource),
         _prefsHelper.setRole(profileResponse.userRole),
       ]);
     }catch(e){
       throw GetProfileException('Error getting Profile Fire Base API');
     }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _prefsHelper.deleteToken();
    await _prefsHelper.cleanAll();
  }

  void fakeAccount() async{
  print('fake account');
 String uid = await FirebaseAuth.instance.currentUser!.uid;
 await _repository.deleteFakeProfile(uid);
    FirebaseAuth.instance.currentUser!.delete();
  }

 Future<AuthResponse> resetPassword(String email) async{
    try {
      final bool currentLangIsArabic = UtilsConst.lang == 'ar'?true:false;

      bool response = await _repository.getNewPassword(email);
      return AuthResponse(
          message:currentLangIsArabic?'تم ارسال الرمز ': 'The new code has been sent', status: AuthStatus.AUTHORIZED);
    } catch (e) {

      return AuthResponse(
          message: e.toString(), status: AuthStatus.UNAUTHORIZED);
    }
  }


  Future<AuthResponse> confirmWithCode(String code) async {
    final bool currentLangIsArabic = UtilsConst.lang == 'ar'?true:false;

  try{

    AuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: _verificationCode,
      smsCode: code,
    );
   await _auth.signInWithCredential(authCredential);
    return AuthResponse(
        message: currentLangIsArabic?'تم التحقق بنجاح':'Success Verification', status: AuthStatus.AUTHORIZED);
  }catch(e){
    print(e);
    return AuthResponse(
        message: currentLangIsArabic?'خطأ في عملية التحقق':'Error Verification', status: AuthStatus.UNAUTHORIZED);
  }

  }

  Future verifyWithPhone(String phone) async{
  try{
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (authCredentials) {
          _auth.signInWithCredential(authCredentials).then((credential) {
          //  phoneVerifyPublishSubject.add(AuthResponse(message:'AUTHORIZED', status: AuthStatus.AUTHORIZED));

          });
        },
        verificationFailed: (err) {

          phoneVerifyPublishSubject.add(AuthResponse(message: err.message!, status: AuthStatus.UNAUTHORIZED));
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          _verificationCode = verificationId;

          phoneVerifyPublishSubject.add(AuthResponse(message: 'CODE SENT', status:AuthStatus.CODE_SENT));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          phoneVerifyPublishSubject.add(AuthResponse(message: 'CODE TIMEOUT', status:AuthStatus.CODE_TIMEOUT));
        });
  }catch(e){
    phoneVerifyPublishSubject.add(AuthResponse(message:'Error', status: AuthStatus.UNAUTHORIZED));
  }

  }


}
