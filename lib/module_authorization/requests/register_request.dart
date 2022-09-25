import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class RegisterRequest {
  late final String email;
  late final String password;
  late final UserRole userRole;
  late final String userName;
  late final AddressModel address;
  late final String phone;
  RegisterRequest(
      {required this.email,
      required this.password,
      required this.userRole,required this.userName, required this.address, required this.phone});

  RegisterRequest.fromJson(Map<String, dynamic> map) {
    this.email = map['email'];
    this.password = map['password'];
    this.userRole = map['userRole'];
    this.userName = map['userName'];
    this.address = AddressModel.fromJson(map['address']);
    this.phone = map['phone'];

  }

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

