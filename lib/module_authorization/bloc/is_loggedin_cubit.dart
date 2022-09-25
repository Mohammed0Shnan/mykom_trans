import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';

class IsLogginCubit extends Cubit<IsLogginCubitState> {
  AuthService _authService = AuthService();
  IsLogginCubit() : super(IsLogginCubitState.NotLoggedIn){
    _authService.isLoggedIn.then((value) {
      if(value)
        emitLoginState();
      else
        emitNotLoginState();

    });
  }
  emitLoginState()=> emit(IsLogginCubitState.LoggedIn);
  emitNotLoginState()=> emit(IsLogginCubitState.NotLoggedIn);

}

enum IsLogginCubitState { LoggedIn, NotLoggedIn }
