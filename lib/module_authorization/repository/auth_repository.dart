
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/requests/login_request.dart';
import 'package:my_kom/module_authorization/requests/profile_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> register(String email, String password) async {
    //var user = _firebaseAuth.currentUser;

    try {
      UserCredential resualt =await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return resualt.user!.uid;
    }catch(e){
      throw e;
    }

    // String? userId = null;
    // await _firebaseAuth
    //     .createUserWithEmailAndPassword(
    //   email: request.email,
    //   password: request.password,
    // );
    // //     .then((UserCredential credential) async {
    // //   User? user = credential.user;
    // //   userId = user!.uid;
    // //
    // //   if (userId != null)
    // //     await _firestore
    // //         .collection('users')
    // //         .doc(userId)
    // //         .set(request.toJson())
    // //         .catchError((error) {
    // //       throw Exception(error.toString());
    // //     });
    // //   return await user.getIdToken();
    // // }).catchError((error) {
    // //   throw error;
    // // });


  }

  Future<bool> createProfile(ProfileRequest request) async {
    var user = _firebaseAuth.currentUser;
    try{
      var existingProfile =
      await _firestore.collection('users').doc(user!.uid).set(request.toJson());
      return true;
    }catch(e){
      throw e;
    }


    // correct exit point
    return true;
  }

  Future<LoginResponse> signIn(LoginRequest request) async {
    var creds = await _firebaseAuth.signInWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );

    try {
      String token = await creds.user!.getIdToken();
      return LoginResponse(token);
    } catch (e) {
      throw e;
    }
  }

  Future<ProfileResponse> getProfile(String uid) async {
    try {
      var existProfile = await _firestore.collection('users').doc(uid).get();
      Map<String  ,dynamic > result = existProfile.data()!;
      print('result');
      print(result);
      return ProfileResponse.fromJson(result);
    } catch (e) {
      throw Exception();
    }
  }

  Future<bool>editProfile(String uid, EditProfileRequest request)  async {
    print('***************************');
    print(request.toJson());

    var existingProfile =
    await _firestore.collection('users').doc(uid).get();

    if (!existingProfile.exists) {
      throw Exception('Profile dosnt exsit !');
    }

    existingProfile.reference
        .update(request.toJson())
        .then((value) => null)
        .catchError((error) {
      throw Exception('Error in set data !');
    });

    // correct exit point
    return true;
  }

  Future<bool> getNewPassword(String email) async{
    try{
      _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
      throw e;
    }
  }

  Future deleteFakeProfile(uid) async{
    try{

         _firestore.collection('users').doc(uid).delete();


    }catch(e){

    }


  }

}
