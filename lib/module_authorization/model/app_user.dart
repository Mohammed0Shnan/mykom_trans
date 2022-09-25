import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class AppUser {
 late final String id;
 late final String email;
 late final AddressModel address;
 late final String user_name;
 late final phone_number;
 late final AuthSource authSource;
 late final UserRole userRole;
 late final String? stripeId;
 late final String? activeCard ;

  AppUser({required this.id, required this.email,required this.authSource,required this.userRole,required this.address ,required this.phone_number ,required this.user_name,required this.stripeId,required this.activeCard});

  AppUser.fromJsom(Map<String, dynamic> data){
    this.id= data['id'];
    this.email= data['email'];
    this.address=AddressModel.fromJson(data['address']) ;
    this.phone_number= data['phone'];
    this.user_name= data['userName'];

    late UserRole user_role;
    if( UserRole.ROLE_OWNER.name ==data['userRole']){
      user_role = UserRole.ROLE_OWNER;
    }else if(UserRole.ROLE_USER.name ==data['userRole'])
{
  user_role = UserRole.ROLE_USER;
}
    this.userRole = user_role;

  }

}