import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class ProfileRequest {
  late final String email;
  late final String password;
  late final UserRole userRole;
  late final String userName;
  late final AddressModel address;
  late final String phone;
  ProfileRequest();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['email'] = this.email;
    //map['password'] = this.password ;
    map['userRole'] = this.userRole.name;
    map['userName'] = this.userName;
    map['phone'] = this.phone;
    map['address'] = this.address.toJson();
    return map;
  }
}

class EditProfileRequest {

  late final String userName;
  late final AddressModel address;
  late final String phone;
  EditProfileRequest();


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['userName'] = this.userName;
    map['phone'] = this.phone;
    map['address'] = this.address.toJson();
    return map;
  }
}




