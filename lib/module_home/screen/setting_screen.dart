import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/screen/about_my_kom_screen.dart';
import 'package:my_kom/module_home/screen/connect_us_screen.dart';
import 'package:my_kom/module_home/screen/privacy_my_kom_screen.dart';
import 'package:my_kom/module_home/screen/delivery_policy_screen.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class SettingScreen extends StatefulWidget {
  final  LocalizationService localizationService ;
  const SettingScreen({required this.localizationService,Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Expanded(
              child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                childAspectRatio:1,
                crossAxisSpacing: SizeConfig.widhtMulti *6,
                mainAxisSpacing:  SizeConfig.widhtMulti *5,
              ),

              children: [
                Container(
                  padding: EdgeInsets.only(top: 8,left: 4,right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0,1)
                    )]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.language_outlined ,color: ColorsConst.mainColor,size: 35),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: BlocBuilder<LocalizationService,LocalizationState>(
                            bloc: widget.localizationService ,
                            builder: (context, state){
                              String lang ;
                              if(state is LocalizationArabicState){
                                lang = 'ar';
                              }else{
                                lang = 'en';
                              }
                              return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,

                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('العربية',  style: TextStyle(fontWeight: FontWeight.bold,fontSize:14,color: Colors.black87)),//Text(S.of(context).arabic),
                                      value: 'ar',
                                    ),
                                    DropdownMenuItem(
                                      child:Text('English', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black87)),//, Text(S.of(context).english),
                                      value: 'en',
                                    ),
                                  ],
                                  value: lang,
                                  onChanged: (String? newLang) {
                                    widget.localizationService.setLanguage(newLang!);
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // GestureDetector(
                //   onTap: (){},
                //   child: Container(
                //     padding: EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         color: Colors.white,
                //         boxShadow: [BoxShadow(
                //             color: Colors.black12,
                //             blurRadius: 2,
                //             offset: Offset(0,1)
                //         )]
                //     ),
                //     child: Column(
                //       children: [
                //         Icon(Icons.settings_outlined ,color: ColorsConst.mainColor,size: 5* SizeConfig.heightMulti),
                //         SizedBox(height: 10,),
                //         Expanded(child: Text(S.of(context)!.settings, style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.2 * SizeConfig.heightMulti,color: Colors.black87),  ))
                //       ],
                //     ),
                //
                //   ),
                // ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutMyKomScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.info_outline ,color: ColorsConst.mainColor,size:35),
                        SizedBox(height: 10,),
                        Expanded(child: Text(S.of(context)!.aboutApp, style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize:  14,color: Colors.black87),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyMyKomScreen() ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lock_outline ,color: ColorsConst.mainColor,size: 35),
                        SizedBox(height: 10,),
                        Expanded(child: Text(S.of(context)!.privacyPolicy,textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize:  14,color: Colors.black87)  ))
                      ],
                    ),

                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryPolicyScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined ,color: ColorsConst.mainColor,size: 35,),
                        SizedBox(height: 10,),
                        Expanded(child: Text(S.of(context)!.deliveryPolicy,textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize:  14,color: Colors.black87),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ConnectUsScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.phone_outlined ,color: ColorsConst.mainColor,size: 35),
                        SizedBox(height: 10,),
                        Expanded(child: Text(S.of(context)!.contactUs, style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize:  14,color: Colors.black87) ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: ()async{
                  await  EasyLoading.show(status: S.of(context)!.pleaseWait);
                 bool res = await _authService.isLoggedIn;
                 if(res){
                   _authService.logout().then((value) {
                     Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
                     EasyLoading.showSuccess(S.of(context)!.signedOutSuccessfully);

                   });
                 }else{
                   await  EasyLoading.showError(S.of(context)!.notLoggedIN);
                 }

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.logout_outlined ,color: ColorsConst.mainColor,size: 35,),
                        SizedBox(height: 10,),
                        Expanded(child: Text(S.of(context)!.logout,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize:  14,color: Colors.black87) ))
                      ],
                    ),

                  ),
                ),

              ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
