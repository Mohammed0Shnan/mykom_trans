
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class ProfileModel {
 late String userName;
 late String email;

 late String phone;
 late UserRole userRole;
 late AddressModel address;

  ProfileModel({
   required this.userName,
    required this.phone,
   required this.email,

   required this.userRole,
    required  this.address
  });
}
