import 'package:my_kom/module_map/models/address_model.dart';

class EditProfileRequest {
  late final String userName;
  late final AddressModel address;
  late final String phone;
  EditProfileRequest(
      {required this.userName, required this.address, required this.phone});

  EditProfileRequest.fromJson(Map<String, dynamic> map) {
    this.userName = map['userName'];
    this.address = AddressModel.fromJson(map['address']);
    this.phone = map['phone'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['userName'] = this.userName;
    map['phone'] = this.phone;
    map['address'] = this.address.toJson();

    return map;
  }
}