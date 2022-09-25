import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final AuthService _service = AuthService();

  LoginBloc() : super(LoginInitState()) {
    on<LoginEvent>((LoginEvent event, Emitter<LoginStates> emit) {
      if (event is LoginLoadingEvent)
        emit(LoginLoadingState());
      else if (event is LoginErrorEvent){
        emit(LoginErrorState(message: event.message));
      }
      else if (event is LoginSuccessEvent) 
      emit(LoginSuccessState(message: event.message));

      else {
        emit(LoginInitState());
      }
    });
  }


  login(String email, String password) async {
    this.add(LoginLoadingEvent());
    _service.signInWithEmailAndPassword(email, password).then((value) {
      if (value.status == AuthStatus.AUTHORIZED) {
        this.add(LoginSuccessEvent(message: value.message));
      } else{
        this.add(LoginErrorEvent(message: value.message));

      }
    });
  }
}

abstract class LoginEvent { }
class LoginInitEvent  extends LoginEvent  {}

class LoginSuccessEvent  extends LoginEvent  {
  String message;
  LoginSuccessEvent({required this.message});
}

class LoginLoadingEvent  extends LoginEvent  {}

class LoginErrorEvent  extends LoginEvent  {
  String message;
  LoginErrorEvent({required this.message});
}

abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginSuccessState extends LoginStates {
    String message;
  LoginSuccessState({required this.message});
}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
    String message;
  LoginErrorState({required this.message});
}
