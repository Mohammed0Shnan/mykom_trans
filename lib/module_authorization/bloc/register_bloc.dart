import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterStates> {
  final AuthService _service = AuthService();

  RegisterBloc() : super(RegisterInitState()) {
    on<RegisterEvent>((RegisterEvent event, Emitter<RegisterStates> emit) {
      if (event is RegisterLoadingEvent)
        emit(RegisterLoadingState());
      else if (event is RegisterErrorEvent){
        emit(RegisterErrorState(message: event.data));
      }
      else if (event is RegisterSuccessEvent) 
      emit(RegisterSuccessState(data: event.data));


      /// profile states
      else if (event is CompleteLoadingEvent)
              emit(CompleteLoadingState());
            else if (event is CompleteErrorEvent){
              emit(CompleteErrorState(message: event.data));
            }
            else if (event is CompleteSuccessEvent)
            emit(CompleteSuccessState(data: event.data));
      else {
        emit(RegisterInitState());
      }
    });
  }

 

  register({required String email,required String password,required UserRole userRole}) async {
    this.add(RegisterLoadingEvent());
    _service.registerWithEmailAndPassword(email, password ,userRole, AuthSource.EMAIL).then((value) {
      if (value.state) {
        this.add(RegisterSuccessEvent(data: value.data));
      } else
        this.add(RegisterErrorEvent(data: value.data));
    });
  }
  
   createProfile(ProfileRequest request){
         this.add(CompleteLoadingEvent());
  _service.createProfile(request).then((value) {
          if (value.state) {
        this.add(CompleteSuccessEvent(data: value.data));
      } else
        this.add(CompleteErrorEvent(data:value.data));
  });
 }



  void deleteFakeAccount() {
    _service.fakeAccount();

  }

  ///
///


}



abstract class RegisterEvent {}

class RegisterInitEvent extends RegisterEvent {
    String data;
  RegisterInitEvent({required this.data});
}

class RegisterSuccessEvent extends RegisterEvent {
  String data;
  RegisterSuccessEvent({required this.data});
}

class RegisterLoadingEvent extends RegisterEvent {}

class RegisterErrorEvent extends RegisterEvent {
  String data;
  RegisterErrorEvent({required this.data});
}

abstract class RegisterStates {}

class RegisterInitState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
    String data;
  RegisterSuccessState({required this.data});
}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  String message;
  RegisterErrorState({required this.message});
}


////////////////// profile
///


class CompleteSuccessEvent extends RegisterEvent {
  String data;
  CompleteSuccessEvent({required this.data});
}

class CompleteLoadingEvent extends RegisterEvent {}

class CompleteErrorEvent extends RegisterEvent {
  String data;
  CompleteErrorEvent({required this.data});
}



class CompleteSuccessState extends RegisterStates {
    String data;
  CompleteSuccessState({required this.data});
}

class CompleteLoadingState extends RegisterStates {}

class CompleteErrorState extends RegisterStates {
  String message;
  CompleteErrorState({required this.message});
}