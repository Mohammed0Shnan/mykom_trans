import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/repository/auth_repository.dart';
import 'package:my_kom/module_authorization/requests/profile_request.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_profile/model/profile_model.dart';
import 'package:my_kom/module_profile/model/quick_location_model.dart';

class ProfileService{

  final AuthRepository _repository = AuthRepository();
  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProfileModel?> getMyProfile() async {
    var user = _auth.currentUser;
    // Change This
    try{
      ProfileResponse profileResponse = await _repository.getProfile(user!.uid);

      await Future.wait([
        _prefsHelper.setEmail(user.email!),
        _prefsHelper.setAdderss(profileResponse.address),
        _prefsHelper.setUsername(profileResponse.userName),
        _prefsHelper.setPhone(profileResponse.phone),
        _prefsHelper.setAuthSource(AuthSource.EMAIL),
        _prefsHelper.setRole(profileResponse.userRole),
      ]);
      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: user.email!,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }

  }

  Future<ProfileModel?> getUserProfile(String userID) async {

    // Change This
    try{
      ProfileResponse profileResponse = await _repository.getProfile(userID);

      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: profileResponse.email,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }

  }

  Future <ProfileModel?> editMyProfile(EditProfileRequest request)async {
    print('::::::::::::::::::::::::::::::::::::::::::');
    print(request.toJson());
    var user = _auth.currentUser;

    // Change This
    try{
      bool editResponse = await _repository.editProfile(user!.uid , request);
      ProfileResponse profileResponse = await _repository.getProfile(user.uid);
      await Future.wait([
        _prefsHelper.setEmail(user.email!),
        _prefsHelper.setAdderss(profileResponse.address),
        _prefsHelper.setUsername(profileResponse.userName),
        _prefsHelper.setPhone(profileResponse.phone),
        _prefsHelper.setAuthSource(AuthSource.EMAIL),
        _prefsHelper.setRole(profileResponse.userRole),
      ]);
      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: user.email!,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }
  }

 Future<List<QuickLocationModel>?> getMyLocations()async {
  String?  userId =await _prefsHelper.getUserId();
  try{
    return  FirebaseFirestore.instance.collection('users').doc(userId!).collection('quick_locations').get().then((value) {
      List<QuickLocationModel> quickLocations =[];
      value.docs.forEach((element) {
        Map<String,dynamic> q = element.data() as Map<String,dynamic>;
        q['id'] = element.id;
        QuickLocationModel quickLocationModel = QuickLocationModel.fromJson(q);
        quickLocations.add(quickLocationModel);
      });
      return quickLocations;
    });
  }catch(e){
    return null;
  }

  }

  Future<List<QuickLocationModel>?> deleteLocation(String id) async{
    String?  userId =await _prefsHelper.getUserId();
    try{
     FirebaseFirestore _fire =  FirebaseFirestore.instance;
      await _fire.collection('users').doc(userId!).collection('quick_locations').doc(id).delete();
      return  FirebaseFirestore.instance.collection('users').doc(userId).collection('quick_locations').get().then((value) {
        List<QuickLocationModel> quickLocations =[];
        value.docs.forEach((element) {
          Map<String,dynamic> q = element.data() as Map<String,dynamic>;
          q['id'] = element.id;
          QuickLocationModel quickLocationModel = QuickLocationModel.fromJson(q);
          quickLocations.add(quickLocationModel);
        });
        return quickLocations;
      });
    }catch(e){
      return null;
    }
  }

  Future<bool> deleteMyAccount()async {

    try{

      FirebaseFirestore _fire =  FirebaseFirestore.instance;
      await _fire.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userName':'deleted_account',
        'email':'deleted_account',
        'address':{}
      });
      await FirebaseAuth.instance.currentUser!.delete();
      await  _auth.signOut();
      return true;
    }catch(e){
      return false;
    }
  }
}