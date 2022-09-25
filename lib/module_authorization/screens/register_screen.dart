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
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  final GlobalKey<FormState> _registerCompleteFormKey = GlobalKey<FormState>();
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
  late final PageController _pageController;
  late final UserRole userRole;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userRole =  ModalRoute.of(context)!.settings.arguments as UserRole;
    });
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    cubit1 = PasswordHiddinCubit();
    cubit2 = PasswordHiddinCubit();
  }

  @override
  void dispose() {
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
      body: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.heightMulti * 9,
            color: ColorsConst.mainColor,

          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                /// Page Number One
                ///
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          height: SizeConfig.screenHeight * 0.22,
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),

                              Text(S.of(context)!.createNewAccount,
                                  textAlign:TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w900,
                                      fontSize: SizeConfig.titleSize * 4)),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.02,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context)!.alreadyHaveOne,
                                      style: TextStyle(
                                          fontSize: SizeConfig.titleSize * 1.9 ,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AuthorizationRoutes.LOGIN_SCREEN);
                                      },
                                      child: Text(S.of(context)!.login,
                                          style:  GoogleFonts.acme(
                                              fontSize: SizeConfig.titleSize * 2,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal:  SizeConfig.screenWidth * 0.04),
                          child: Form(
                            key: _registerFormKey,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              direction: Axis.vertical,
                              children: [
                                ListTile(
                                    title: Padding(
                                        padding: EdgeInsets.only(bottom: 4),
                                        child: Text(S.of(context)!.email, style:GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: SizeConfig.titleSize * 2
                                        ))),
                                    subtitle: SizedBox(
                                     // height: 42.0,
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16,
                                        height:1
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _registerEmailController,
                                        decoration: InputDecoration(
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
                                            hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
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
                                          fontSize: SizeConfig.titleSize * 2
                                      ))),
                                  subtitle: SizedBox(
                                    child: BlocBuilder<PasswordHiddinCubit,
                                        PasswordHiddinCubitState>(
                                      bloc: cubit1,
                                      builder: (context, state) {
                                        return SizedBox(
                                          child: TextFormField(
                                            controller: _registerPasswordController,
                                            style: TextStyle(fontSize: 16,
                                                height: 1
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      cubit1.changeState();
                                                    },
                                                    icon: state ==
                                                            PasswordHiddinCubitState
                                                                .VISIBILITY
                                                        ? Icon(Icons.visibility)
                                                        : Icon(Icons.visibility_off)),
                                                border:OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2,
                                                        style:BorderStyle.solid ,
                                                        color: Colors.black87
                                                    ),
                                                    borderRadius: BorderRadius.circular(10)

                                                ),
                                                hintText:S.of(context)!.password
                                                , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
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
                                  height:6,
                                ),
                                ListTile(
                                  title: Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(S.of(context)!.confirmPassword,style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: SizeConfig.titleSize * 2
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
                                            style: TextStyle(fontSize: 16,
                                                height: 1
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      cubit2.changeState();
                                                    },
                                                    icon: state ==
                                                            PasswordHiddinCubitState
                                                                .VISIBILITY
                                                        ? Icon(Icons.visibility)
                                                        : Icon(Icons.visibility_off)),
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
                                            textInputAction: TextInputAction.done,
                                            onFieldSubmitted: (_) => node
                                                .unfocus(), // Submit and hide keyboard
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:SizeConfig.screenHeight * 0.02,
                                ),
                                Center(
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: 2,
                                    effect: ExpandingDotsEffect(
                                        dotColor: Colors.black12,
                                        dotHeight: 10,
                                        dotWidth: 10,
                                        spacing: 2,
                                        activeDotColor: ColorsConst.mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height:SizeConfig.screenHeight * 0.04,
                                ),
                                BlocConsumer<RegisterBloc, RegisterStates>(
                                  bloc: widget._bloc,
                                  listener: (context, state) {
                                    if (state is RegisterSuccessState) {
                                      _pageController.jumpToPage(1);
                                    } else if (state is RegisterErrorState) {
                                      snackBarErrorWidget(context, state.message);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is RegisterLoadingState)
                                      return Center(
                                          child: Container(
                                            margin: EdgeInsets.all(20),
                                              width: 30,
                                              height: 30,
                                              child: CircularProgressIndicator(color: ColorsConst.mainColor,)));
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
                                                    widget._bloc.register(
                                                        userRole: userRole,
                                                        email: email,
                                                        password: password);
                                                  }
                                                },
                                                child: Text(S.of(context)!.next,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        SizeConfig.titleSize * 2.3,
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
                ),

                //////////////////////////
                //////////////////////////
                /////////////////////////
                /// Page Number Tow

                WillPopScope(
                  onWillPop: ()=> _willPop(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.04),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40,),
                          Text(S.of(context)!.completeYourDetail,
                              textAlign:TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w900,
                                  fontSize: SizeConfig.titleSize * 3.9)),
                          SizedBox(height: SizeConfig.heightMulti ,),
                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 30),
                          //   alignment: Alignment.center,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'When registering, you agree to ! ',
                          //         style: TextStyle(
                          //             fontSize: SizeConfig.titleSize * 1.8,
                          //             color: Colors.black54,
                          //             fontWeight: FontWeight.w700
                          //         ),
                          //       ),
                          //       SizedBox(width: 5,),
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () {},
                          //           child: Container(
                          //             child: Text('the Privacy and Security Policy',
                          //                 style: TextStyle(
                          //                     fontSize: SizeConfig.titleSize * 2,
                          //                     fontWeight: FontWeight.w800,
                          //                     color: ColorsConst.mainColor)),
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height:SizeConfig.screenHeight * 0.07,
                          ),
                          Form(
                            key: _registerCompleteFormKey,
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
                                          fontSize: SizeConfig.titleSize * 2
                                      ))),
                                    subtitle: SizedBox(
                                      child: TextFormField(
                                        controller: _registerUserNameController,
                                        style: TextStyle(
                                          fontSize: 16,
                                          height:1
                                        ),
                                        decoration: InputDecoration(
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
                                SizedBox(
                                  height: 4,
                                ),
                                ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text( S.of(context)!.address, style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: SizeConfig.titleSize * 2
                                      ))),
                                    subtitle: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              child: TextFormField(
                                                controller:
                                                    _registerAddressController,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height:1
                                                ),
                                                readOnly: true,
                                                enableInteractiveSelection: true,

                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                                    errorStyle: GoogleFonts.lato(
                                                      color: Colors.red.shade700,
                                                      fontWeight: FontWeight.w800,


                                                    ),
                                                    prefixIcon:
                                                        Icon(Icons.location_on),
                                                    border:OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            style:BorderStyle.solid ,
                                                            color: Colors.black87
                                                        ),
                                                        borderRadius: BorderRadius.circular(10)

                                                    ), hintText: S.of(context)!.address,
                                                    hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)// S.of(context).email,
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
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.pushNamed(
                                                  context, MapRoutes.MAP_SCREEN,arguments: true)
                                                  .then((value) {
                                                if (value != null) {
                                                  addressModel = (value as AddressModel);
                                                  _registerAddressController.text =
                                                      addressModel.description;
                                                }
                                              });
                                            },
                                            child: Container(

                                              width: SizeConfig.heightMulti * 5.5,
                                              height: SizeConfig.heightMulti * 5.5,
                                              decoration: BoxDecoration(
                                                  color: ColorsConst.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: Icon(
                                                  Icons.my_location_outlined,
                                                  size: SizeConfig.heightMulti * 4,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 4,
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: Text( S.of(context)!.phone,style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: SizeConfig.titleSize * 2
                                    ))),
                                  subtitle: Container(
                                    height: SizeConfig.heightMulti * 5.5,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                         horizontal: 10),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black45,
                                            width: 1
                                          ),
                                          borderRadius: BorderRadius.circular(10)

                                      ),
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone),
                                          CountryCodePicker(

                                            initialSelection:
                                                'دولة الإمارات العربية المتحدة',
                                            showOnlyCountryWhenClosed: false,
                                            onInit: (initC){
                                              countryCode =initC!.dialCode!;
                                            },
                                            favorite: [
                                              '+971',
                                              'دولة الإمارات العربية المتحدة'
                                            ],
                                            onChanged: (c) {
                                              countryCode =c.dialCode!;
                                            },
                                          ),
                                          Divider(
                                            height: 30,
                                            color: Colors.black,
                                            thickness: 10,
                                          ),
                                          Expanded(
                                              child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: 14
                                            ),
                                            controller:
                                                _registerPhoneNumberController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,

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
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: 2,
                                    effect: ExpandingDotsEffect(
                                        dotColor: Colors.black12,
                                        dotHeight: 10,
                                        dotWidth: 10,
                                        spacing: 2,
                                        activeDotColor: ColorsConst.mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BlocConsumer<RegisterBloc, RegisterStates>(
                                  bloc: widget._bloc,
                                  listener: (context, state) {
                                    if(state is CompleteLoadingState)
                                      EasyLoading.show();
                                    else if (state is CompleteErrorState) {
                                      EasyLoading.showError(state.message);
                                     // snackBarErrorWidget(context, state.message);
                                    } else if (state is CompleteSuccessState) {
                                      //snackBarSuccessWidget(context, state.data);
                                       String _email  =_registerEmailController.text.trim();
                                      String _password  =_registerPasswordController.text.trim();

                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                                      LoginAutomatically(email: _email, password: _password)
                                      ),(route)=>false);
                                    // String phone_number = countryCode+ _registerPhoneNumberController
                                    //        .text
                                    //        .trim();
                                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                       //     PhoneCodeSentScreen(phoneNumber: phone_number,email:_email,password: _password ,)
                                       // ));
                                    }
                                  },
                                  builder: (context, state) {

                                      return ListTile(
                                        title: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias
                                          ,
                                            borderRadius:BorderRadius.circular(10),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                  Color.fromARGB(255, 28, 174, 147),
                                                ),
                                                onPressed: () {

                                                  if (_registerCompleteFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    String name =
                                                    _registerUserNameController.text
                                                        .trim();
                                                    String phone =
                                                   countryCode+ _registerPhoneNumberController
                                                        .text
                                                        .trim();
                                                    ProfileRequest profileRequest =
                                                    ProfileRequest(
                                                        userName: name,
                                                        address: addressModel,
                                                        phone: phone);
                                                    widget._bloc
                                                        .createProfile(profileRequest);
                                                  }
                                                },
                                                child: Text( S.of(context)!.register,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                        SizeConfig.titleSize * 2.3,
                                                        fontWeight: FontWeight.w700))),
                                          ),
                                        ),
                                      );
                                  },
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _willPop(){
    widget._bloc.deleteFakeAccount();
    Navigator.pop(context);


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
