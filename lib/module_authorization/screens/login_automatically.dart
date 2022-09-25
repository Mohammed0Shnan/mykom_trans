import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/navigator_routes.dart';

class LoginAutomatically extends StatefulWidget {
  final LoginBloc _loginBloc = LoginBloc();
  final String password;
  final String email;
   LoginAutomatically({ required this.email,required this.password,Key? key}) : super(key: key);

  @override
  State<LoginAutomatically> createState() => _LoginAutomaticallyState();
}

class _LoginAutomaticallyState extends State<LoginAutomatically> {

@override
  void initState() {
   widget._loginBloc.login(widget.email,widget.password);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocConsumer<LoginBloc, LoginStates>(
          bloc: widget._loginBloc,
          listener: (context, LoginStates state)async {
            if (state is LoginSuccessState) {
              EasyLoading.showSuccess( state.message);
             // snackBarSuccessWidget(context, state.message);
              UserRole? role = await AuthService().userRole;
              if(role != null){

                Navigator.pushNamedAndRemoveUntil(
                    context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=> false);}

            } else if (state is LoginErrorState) {
              EasyLoading.showError(state.message);
             // snackBarErrorWidget(context, state.message);
            }
          },
          builder: (context, LoginStates state) {
            if (state is LoginLoadingState)
              return Center(
                child: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsConst.mainColor,
                      ),
                    )),
              );
            else
              return Container();
          }),
    );
  }
}
