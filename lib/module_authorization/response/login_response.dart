import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class LoginResponse{
 late String token;

 LoginResponse(this.token);
  LoginResponse.fromJson(Map<String , dynamic> map){
    this.token = map['token'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = this.token;
    return data;
  }
}


class ProfileResponse{
  late String email;
  late String userName;
  late String phone;
 late UserRole userRole;
 late AddressModel address;
  
  ProfileResponse.fromJson(Map<String , dynamic> map){
    this.userName = map['userName'];
    this.phone = map['phone'];
    this.email = map['email'];
     this.userRole = (map['userRole'] == '${UserRole.ROLE_USER.name}')? UserRole.ROLE_USER:UserRole.ROLE_OWNER ;
     this.address =AddressModel.fromJson( map['address']);
  }

}


class AuthResponse{
  AuthStatus status;
  String message;
  AuthResponse( {required this.message,required this.status});
}