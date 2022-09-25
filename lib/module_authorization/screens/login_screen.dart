import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/screens/reset_password_screen.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc _loginBloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _LoginFormKey = GlobalKey<FormState>();
  final TextEditingController _LoginEmailController = TextEditingController();
  final TextEditingController _LoginPasswordController =
      TextEditingController();

  late final PasswordHiddinCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.15,),
                Container(
                  width: SizeConfig.screenWidth * 0.6,
                  child: Image.asset('assets/new_logo.png'),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text(S.of(context)!.welcome,style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(height: 4,),
                Center(
                  child: Text(S.of(context)!.signInToContinue,style: GoogleFonts.lato(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: SizeConfig.screenHeight * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),


                  ),
                  child: Form(
                    key: _LoginFormKey,
                    child: ListView(
                      children: [
                        SizedBox(height: SizeConfig.heightMulti * 3,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(S.of(context)!.email,style:GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: SizeConfig.titleSize * 2
                                  ))),
                              subtitle: SizedBox(
                                child: TextFormField(
                                  style: TextStyle(fontSize: 16,
                                  height: 1
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _LoginEmailController,
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
                                      hintText: S.of(context)!.email,
                                      hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                    //S.of(context).name,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),

                                  validator: (result) {
                                    if (result!.isEmpty) {
                                      return  S.of(context)!.emailAddressIsRequired; //S.of(context).nameIsRequired;
                                    }
                                    if (!_validateEmailStructure(result))
                                      return 'Must write an email address';
                                    return null;
                                  },
                                ),
                              )),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),

                          ),
                          child: ListTile(
                            title: Padding(
                                padding: EdgeInsets.only(bottom:4),
                                child: Text( S.of(context)!.password,style:GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: SizeConfig.titleSize * 2
                                ))),
                            subtitle: BlocBuilder<PasswordHiddinCubit,
                                PasswordHiddinCubitState>(
                              bloc: cubit,
                              builder: (context, state) {
                                return SizedBox(
                                  child: TextFormField(

                                    controller: _LoginPasswordController,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1
                                    ),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical:12),
                                        errorStyle: GoogleFonts.lato(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w800,
                                        ),

                                        suffixIcon: SizedBox(
                                          height: 10,
                                          child: IconButton(
                                              onPressed: () {
                                                cubit.changeState();
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
                                        hintText:S.of(context)!.password,
                                        hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                    ),
                                    obscureText:
                                    state == PasswordHiddinCubitState.VISIBILITY
                                        ? false
                                        : true,

                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (v) => node.unfocus(),
                                    // Move focus to next
                                    validator: (result) {
                                      if (result!.isEmpty) {
                                        return  S.of(context)!.passwordIsRequired; //S.of(context).emailAddressIsRequired;
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
                          height: 4,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  RestPasswordScreen()
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 2.345 * SizeConfig.heightMulti),
                              child: Text( S.of(context)!.forgotPassword,
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                    fontSize: SizeConfig.titleSize * 1.5,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:SizeConfig.heightMulti *1.7,
                        ),
                        BlocConsumer<LoginBloc, LoginStates>(
                            bloc: widget._loginBloc,
                            listener: (context, LoginStates state)async {
                              if(state is LoginLoadingState)
                                EasyLoading.show();

                             else if (state is LoginSuccessState) {
                               EasyLoading.showSuccess( state.message);
                               // snackBarSuccessWidget(context, state.message);
                                UserRole? role = await AuthService().userRole;
                                if(role != null){
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=> false);
                                }

                              } else if (state is LoginErrorState) {
                               EasyLoading.showError( state.message);
                               // snackBarErrorWidget(context, state.message);
                              }
                            },
                            builder: (context, LoginStates state) {

                                return ListTile(
                                  title: Container(
                                    height: 55,
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(

                                            primary:ColorsConst.mainColor,
                                          ),
                                          onPressed: () {
                                            if (_LoginFormKey.currentState!
                                                .validate()) {
                                              String email =
                                              _LoginEmailController.text.trim();
                                              String password =
                                              _LoginPasswordController.text
                                                  .trim();
                                              widget._loginBloc
                                                  .login(email, password);
                                            }
                                          },
                                          child: Text( S.of(context)!.login,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  SizeConfig.titleSize * 2.3,
                                                  fontWeight: FontWeight.w700))),
                                    ),
                                  ),
                                );
                            }),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context)!.dontHaveAnAccount,
                                style:  GoogleFonts.lato(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black45,
                                  fontSize: SizeConfig.titleSize * 1.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      AuthorizationRoutes.REGISTER_SCREEN,
                                      arguments: UserRole.ROLE_USER
                                  );
                                },
                                child: Text( S.of(context)!.createAccount,
                                    style:  GoogleFonts.lato(
                                        fontSize: SizeConfig.titleSize * 1.8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue                          )

                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ))
          ],
        ),

    );
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
