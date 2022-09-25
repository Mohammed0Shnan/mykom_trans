import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/register_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/screens/login_automatically.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:my_kom/generated/l10n.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterBloc _bloc = RegisterBloc();
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with WidgetsBindingObserver{
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late final MapBloc  _mapBloc;
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();
  final TextEditingController _registerUserNameController =
      TextEditingController();
  final TextEditingController _registerAddressController =
      TextEditingController();
  final TextEditingController _registerPhoneNumberController =
      TextEditingController();

  late final PasswordHiddinCubit cubit1, cubit2;
  late final UserRole userRole;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userRole =  ModalRoute.of(context)!.settings.arguments as UserRole;
    });
    _mapBloc =MapBloc();
    _mapBloc.getCurrentPosition();
    super.initState();
    cubit1 = PasswordHiddinCubit();
    cubit2 = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    _mapBloc.close();
    cubit1.close();
    cubit2.close();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached){
    widget._bloc.deleteFakeAccount();
    }
  }


  late AddressModel addressModel;
  
  late String countryCode;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight ,
            color: ColorsConst.mainColor,
            padding: EdgeInsets.only(top: 20),
            child:   Container(

              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),

                  Text(S.of(context)!.createNewAccount,
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w900,
                          fontSize: 28)),
                  SizedBox(
                    height:SizeConfig.screenHeight * 0.02,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context)!.alreadyHaveOne+'  ',
                          style: TextStyle(
                              fontSize: 17 ,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w800
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AuthorizationRoutes.LOGIN_SCREEN);
                          },
                          child: Text(S.of(context)!.login,

                              style:  GoogleFonts.lato(
                                decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87                          )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ),
          Positioned(
            top: 150,
            left: 0,
            bottom: 0,
            right: 0,
            child:     Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
              ),
              
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height:20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:  16),
                      child: Form(
                        key: _registerFormKey,
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          direction: Axis.vertical,
                          children: [
                            ListTile(
                                title: Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text(S.of(context)!.name,style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 15
                                    ))),
                                subtitle: SizedBox(
                                  child: TextFormField(

                                    controller: _registerUserNameController,
                                    style: TextStyle(
                                        fontSize: 15,
                                        height:1
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                        isDense: true,
                                        errorStyle: GoogleFonts.lato(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w800,


                                        ),
                                        border:OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                style:BorderStyle.solid ,
                                                color: Colors.black87
                                            ),
                                            borderRadius: BorderRadius.circular(10)

                                        ),hintText: S.of(context)!.name
                                        , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                      //S.of(context).name,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    // Move focus to next
                                    validator: (result) {
                                      if (result!.isEmpty) {
                                        return  S.of(context)!.nameIsRequired; //S.of(context).nameIsRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                )),
                            SizedBox(height: 4,),
                            ListTile(
                                title: Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text(S.of(context)!.email, style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 15
                                    ))),
                                subtitle: SizedBox(

                                  child: TextFormField(
                                    style: TextStyle(fontSize: 15,
                                        height:1
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _registerEmailController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                        isDense: true,
                                        border:OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                style:BorderStyle.solid ,
                                                color: Colors.black87
                                            ),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        hintText: S.of(context)!.email
                                        ,
                                        hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 15)
                                      //S.of(context).name,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    // Move focus to next
                                    validator: (result) {
                                      if (result!.isEmpty) {
                                        return S.of(context)!.emailAddressIsRequired; //S.of(context).nameIsRequired;
                                      }
                                      if (!_validateEmailStructure(result))
                                        return 'Must write an email';
                                      return null;
                                    },
                                  ),
                                )),
                            SizedBox(
                                height:4
                            ),
                            ListTile(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(S.of(context)!.password, style:GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 15
                                  ))),
                              subtitle: SizedBox(
                                child: BlocBuilder<PasswordHiddinCubit,
                                    PasswordHiddinCubitState>(
                                  bloc: cubit1,
                                  builder: (context, state) {
                                    return SizedBox(
                                      child: TextFormField(
                                        controller: _registerPasswordController,
                                        style: TextStyle(fontSize: 15,
                                            height: 1
                                        ),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                            suffixIconConstraints: BoxConstraints(
                                              minWidth: 2,
                                              minHeight: 30,
                                            ),
                                            suffixIcon: SizedBox(
                                              height: 2,
                                              child: IconButton(
                                                  onPressed: () {
                                                    cubit1.changeState();
                                                  },
                                                  icon: state ==
                                                      PasswordHiddinCubitState
                                                          .VISIBILITY
                                                      ? Icon(Icons.visibility)
                                                      : Icon(Icons.visibility_off)),
                                            ),
                                            border:OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    style:BorderStyle.solid ,
                                                    color: Colors.black87
                                                ),
                                                borderRadius: BorderRadius.circular(10)

                                            ),
                                            hintText:S.of(context)!.password
                                            , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 15)
                                        ),
                                        obscureText: state ==
                                            PasswordHiddinCubitState.VISIBILITY
                                            ? false
                                            : true,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => node.nextFocus(),

                                        // Move focus to next
                                        validator: (result) {
                                          if (result!.isEmpty) {
                                            return S.of(context)!.passwordIsRequired; //S.of(context).emailAddressIsRequired;
                                          }
                                          if (result.length < 5) {
                                            return  S.of(context)!.shortPassword;
                                          }

                                          return null;
                                        },

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height:4,
                            ),
                            ListTile(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(S.of(context)!.confirmPassword,style:GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 15
                                  ))),
                              subtitle: SizedBox(
                                child: BlocBuilder<PasswordHiddinCubit,
                                    PasswordHiddinCubitState>(
                                  bloc: cubit2,
                                  builder: (context, state) {
                                    return SizedBox(
                                      child: TextFormField(
                                        controller:
                                        _registerConfirmPasswordController,
                                        style: TextStyle(fontSize: 15,
                                            height: 1
                                        ),
                                        decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
                                            suffixIconConstraints: BoxConstraints(
                                              minWidth: 2,
                                              minHeight: 30,
                                            ),
                                            suffixIcon: SizedBox(
                                              height: 2,
                                              child: IconButton(
                                                  onPressed: () {
                                                    cubit2.changeState();
                                                  },
                                                  icon: state ==
                                                      PasswordHiddinCubitState
                                                          .VISIBILITY
                                                      ? Icon(Icons.visibility)
                                                      : Icon(Icons.visibility_off)),
                                            ),
                                            border:OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    style:BorderStyle.solid ,
                                                    color: Colors.black87
                                                ),
                                                borderRadius: BorderRadius.circular(10)

                                            ),
                                            hintText:
                                            S.of(context)!.confirmPassword // S.of(context).password,
                                            , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                        ),
                                        validator: (result) {
                                          if (result!.trim() !=
                                              _registerPasswordController.text
                                                  .trim()) {
                                            return UtilsConst.lang == 'ar'?'تأكيد غير متطابق':'Confirm pass mismatch';
                                          }
                                          if (result.isEmpty) {
                                            return S.of(context)!.confirmPasswordRequired;
                                          }
                                          return null;
                                        },
                                        obscureText: state ==
                                            PasswordHiddinCubitState.VISIBILITY
                                            ? false
                                            : true,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () => node.nextFocus(),// Submit and hide keyboard
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: 4,),
                            ListTile(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text( S.of(context)!.address, style:GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize:15
                                  ))),
                              subtitle: SizedBox(
                                child: TextFormField(
                                  controller:
                                  _registerAddressController,
                                  style: TextStyle(
                                      fontSize: 15,
                                      height:1
                                  ),
                                  readOnly: true,
                                  enableInteractiveSelection: true,

                                  decoration: InputDecoration(

                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                                      errorStyle: GoogleFonts.lato(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w800,


                                      ),
                                      suffixIconConstraints: BoxConstraints(
                                        minHeight: 40,
                                        minWidth: 4
                                      ),

                                      suffixIcon: SizedBox(
                                        height: 2,
                                        child: BlocConsumer<MapBloc,MapStates>(
                                          bloc:_mapBloc ,
                                          listener: (context,state){
                                            if(state is MapSuccessState){
                                              _registerAddressController.text = state.data.name;

                                            }
                                          },
                                          builder: (context, state){

                                            return   GestureDetector(
                                              onTap: (){
                                                _mapBloc.getCurrentPosition();
                                                // Navigator.pushNamed(
                                                //     context, MapRoutes.MAP_SCREEN,arguments: true)
                                                //     .then((value) {
                                                //   if (value != null) {
                                                //     addressModel = (value as AddressModel);
                                                //     _registerAddressController.text =
                                                //         addressModel.description;
                                                //   }
                                                // });
                                              },
                                              child: Container(
                                                width: 40,
                                                padding: EdgeInsets.all(4),

                                                child:state is MapLoadingState? Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CircularProgressIndicator(color: Colors.green,),
                                                ): state is MapSuccessState?
                                                Icon(
                                                    Icons.check,
                                                    size: 24,

                                                    color: Colors.green): Icon(
                                                    Icons.my_location_outlined,
                                                    size: 24,
                                                    color: Colors.green),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // prefixIcon:
                                      // Icon(Icons.location_on),
                                      border:OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              style:BorderStyle.solid ,
                                              color: Colors.black87
                                          ),
                                          borderRadius: BorderRadius.circular(10)

                                      )
                                      , hintText: S.of(context)!.address,
                                      hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 15)// S.of(context).email,
                                  ),

                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      node.nextFocus(),
                                  // Move focus to next
                                  validator: (result) {
                                    if (result!.isEmpty) {
                                      return  S.of(context)!.addressIsRequired; //S.of(context).emailAddressIsRequired;
                                    }

                                    return null;
                                  },
                                ),
                              ),),
                            BlocConsumer<MapBloc,MapStates>(
                              bloc:_mapBloc ,
                              listener: (context,state){
                                if(state is MapSuccessState){
                                  _registerAddressController.text = state.data.name;
                                  String _des = state.data.name;
                                  double _late = state.data.latitude;
                                  double _long = state.data.longitude;

                                  AddressModel _addr = AddressModel(description: _des, latitude: _late, longitude: _long, geoData: {});
                                  setState((){
                                    addressModel = _addr;
                                  });

                                }
                              },
                              builder: (context, state){
                                if(state is MapSuccessState){
                                  return Container(
                                    height: 25,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.greenAccent.shade100,
                                    child: Center(child: Text(S.of(context)!.registerAddressSuccessMessage,style: TextStyle(color: Colors.black,fontSize: 12),)),
                                  );
                                }
                                else if(state is MapErrorState){
                                  return Container(
                                    height: 25,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.red.shade100,
                                    child: Center(child: Text(S.of(context)!.registerAddressErrorMessage,style: TextStyle(color: Colors.black,fontSize: 12),)),
                                  );
                                }
                                else return SizedBox.shrink();

                              },
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            ListTile(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text( S.of(context)!.phone,style:GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize:15
                                  ))),
                              subtitle: SizedBox(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                  controller:
                                  _registerPhoneNumberController,

                                  decoration: InputDecoration(
                                      border:OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              style:BorderStyle.solid ,
                                              color: Colors.black87
                                          ),
                                          borderRadius: BorderRadius.circular(10)

                                      ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 0,right: 16,top: 12,bottom: 12),
                                    prefixIcon: SizedBox(
                                      height: 2,
                                      width: 50,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 16,),
                                          Icon(Icons.phone),
                                          SizedBox(
                                          height: 60,
                                            child: CountryCodePicker(
                                              flagWidth: 22,
                                              initialSelection:
                                              'دولة الإمارات العربية المتحدة',
                                              showOnlyCountryWhenClosed: false,
                                              onInit: (initC){
                                                countryCode =initC!.dialCode!;
                                              },
                                              textStyle: TextStyle(fontSize: 12),
                                              favorite: [
                                                '+971',
                                                'دولة الإمارات العربية المتحدة'
                                              ],
                                              onChanged: (c) {
                                                countryCode =c.dialCode!;
                                              },

                                            ),
                                          ),
                                          Divider(
                                            height: 30,
                                            color: Colors.black,
                                            thickness: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 140,
                                        minHeight: 44
                                      ),

                                      hintText:
                                      '123412212' // S.of(context).email,
                                      , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                  ),
                                  validator: (result) {
                                    if (result!.isEmpty) {
                                      return  S.of(context)!.phoneIsRequired;
                                    } else if (!_validatePhoneNumberStructure(
                                        result)) {
                                      return S.of(context)!.validPhone;
                                    } else
                                      return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height:25,
                            ),
                            BlocConsumer<RegisterBloc, RegisterStates>(
                              bloc: widget._bloc,
                              listener: (context, state) {
                                if (state is RegisterSuccessState) {
                                  EasyLoading.show();
                                  String _email  =_registerEmailController.text.trim();
                                        String _password  =_registerPasswordController.text.trim();

                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                                        LoginAutomatically(email: _email, password: _password)
                                        ),(route)=>false);
                                } else if (state is RegisterErrorState) {
                                  EasyLoading.showError(state.message);

                                }
                              },
                              builder: (context, state) {
                                if (state is RegisterLoadingState)
                                  return Center(
                                      child: Container(
                                          margin: EdgeInsets.all(20),
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator()));
                                else
                                  return ListTile(
                                    title: Container(
                                        height:55,
                                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: ClipRRect(
                                          clipBehavior: Clip.antiAlias,
                                          borderRadius: BorderRadius.circular(10)
                                          ,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(

                                                primary:
                                                Color.fromARGB(255, 28, 174, 147),
                                              ),
                                              onPressed: () {
                                                if (_registerFormKey.currentState!
                                                        .validate()) {
                                                      String email =
                                                      _registerEmailController.text
                                                          .trim();
                                                      String password =
                                                      _registerPasswordController.text
                                                          .trim();
                                                      String name =
                                                      _registerUserNameController.text
                                                          .trim();
                                                      String phone =
                                                          countryCode+ _registerPhoneNumberController
                                                              .text
                                                              .trim();

                                                      RegisterRequest request = RegisterRequest(
                                                          email: email,
                                                          password: password,
                                                          userRole: userRole,
                                                          userName: name,
                                                          address: addressModel,
                                                          phone: phone
                                                      ) ;
                                                      widget._bloc.register(request:request);

                                                    }



                                              },
                                              child: Text(S.of(context)!.register,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:17,
                                                      fontWeight: FontWeight.w700))),
                                        )
                                    ),
                                  );
                              },
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ) ,

          ),
        ],
      ),
    );
  }





  bool _validatePasswordStructure(String value) {
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateEmailStructure(String value) {
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validatePhoneNumberStructure(String value) {
    String pattern = r'([0-9]{9}$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
