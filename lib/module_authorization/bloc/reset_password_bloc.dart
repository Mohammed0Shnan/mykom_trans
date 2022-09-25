import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestPasswordBloc extends Bloc<RestPasswordEvent, RestPasswordStates> {
  final AuthService _service = AuthService();

  RestPasswordBloc() : super(RestPasswordInitState()) {
    on<RestPasswordEvent>((RestPasswordEvent event, Emitter<RestPasswordStates> emit) {
      if (event is LoginLoadingEvent)
        emit(RestPasswordLoadingState());
      else if (event is RestPasswordErrorEvent){
        emit(RestPasswordErrorState(message: event.message));
      }
      else if (event is RestPasswordSuccessEvent)
      emit(RestPasswordSuccessState(message: event.message));

      else {
        emit(RestPasswordInitState());
      }
    });
  }


  resetPassword(String email) async {
    this.add(LoginLoadingEvent());
    _service.resetPassword(email).then((value) {
      if (value.status == AuthStatus.AUTHORIZED) {
        this.add(RestPasswordSuccessEvent(message: value.message));
      } else{
        this.add(RestPasswordErrorEvent(message: value.message));

      }
    });
  }
}

abstract class RestPasswordEvent { }
class RestPasswordInitEvent  extends RestPasswordEvent  {}

class RestPasswordSuccessEvent  extends RestPasswordEvent  {
  String message;
  RestPasswordSuccessEvent({required this.message});
}

class LoginLoadingEvent  extends RestPasswordEvent  {}

class RestPasswordErrorEvent  extends RestPasswordEvent  {
  String message;
  RestPasswordErrorEvent({required this.message});
}

abstract class RestPasswordStates {}

class RestPasswordInitState extends RestPasswordStates {}

class RestPasswordSuccessState extends RestPasswordStates {
    String message;
    RestPasswordSuccessState({required this.message});
}

class RestPasswordLoadingState extends RestPasswordStates {}

class RestPasswordErrorState extends RestPasswordStates {
    String message;
    RestPasswordErrorState({required this.message});
}
