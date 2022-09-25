
import 'package:my_kom/module_map/models/address_model.dart';

class QuickLocationModel {
 late String id;
 late String display;
 late AddressModel address;
 QuickLocationModel({required this.id, required this.address ,required this.display,});
 Map<String, dynamic> toJson(){
  return {
   'display_name': display,
   'address': address.toJson(),
  };}

  QuickLocationModel.fromJson(Map<String, dynamic> map){
   this.id = map['id'];
   this.display = map['display_name'];
   this.address = AddressModel.fromJson(map['address']);
  }
}
