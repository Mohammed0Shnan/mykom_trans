import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom/module_home/navigator_routes.dart';

class LoginAutomatically extends StatefulWidget {

  final String password;
  final String email;
   LoginAutomatically({ required this.email,required this.password,Key? key}) : super(key: key);

  @override
  State<LoginAutomatically> createState() => _LoginAutomaticallyState();
}

class _LoginAutomaticallyState extends State<LoginAutomatically> {
  final LoginBloc _loginBloc = LoginBloc();
@override
  void initState() {
   _loginBloc.login(widget.email,widget.password);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocListener<LoginBloc, LoginStates>(
          bloc: _loginBloc,
          listener: (context, LoginStates state)async {
            if (state is LoginSuccessState) {
              EasyLoading.showSuccess(state.message);

              // snackBarSuccessWidget(context, state.message);

                Navigator.pushNamedAndRemoveUntil(
                    context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=> false);

            } else if (state is LoginErrorState) {
              EasyLoading.showError(state.message);
            }
          },
        child: SizedBox.shrink(),

    ));
  }
}
