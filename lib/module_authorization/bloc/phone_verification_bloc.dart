import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationStates> {
  final AuthService _service = AuthService();

  PhoneVerificationBloc() : super(PhoneVerificationInitState()) {
    on<PhoneVerificationEvent>((PhoneVerificationEvent event, Emitter<PhoneVerificationStates> emit) {
      if (event is PhoneVerificationLoadingEvent)
        emit(PhoneVerificationLoadingState());
      else if (event is PhoneVerificationErrorEvent){
        emit(PhoneVerificationErrorState(message: event.message));
      }
      else if (event is PhoneVerificationSuccessEvent)
      emit(PhoneVerificationSuccessState(message: event.message));
      else if (event is PhoneVerificationCurrentStateEvent)
        emit(PhoneVerificationCurrentState(message: event.message));

      else {
        emit(PhoneVerificationInitState());
      }

    });
  }

   registerPhoneNumber(String phoneNumber) {
    this.add(PhoneVerificationLoadingEvent());
    _service.phoneVerifyPublishSubject.listen((event) {
      print('phonnnnnnnnnnnnnnnnnnnneeee');
      print(event.status);
      switch (event.status) {

        case AuthStatus.CODE_SENT:
          this.add(PhoneVerificationCurrentStateEvent(message:'CODE SENT'));

          break;
        case AuthStatus.CODE_TIMEOUT:
          this.add(PhoneVerificationCurrentStateEvent(message:'CODE TIMEOUT'));

          break;
        default:
          this.add(PhoneVerificationCurrentStateEvent(message: 'UNAUTHORIZED'));
          break;
      }
    });
     _service.verifyWithPhone(phoneNumber);
  }

   confirmCaptainCode(String smsCode) {
     this.add(PhoneVerificationLoadingEvent());
     _service.confirmWithCode(smsCode).then((value) {
      if(value.status == AuthStatus.AUTHORIZED){
        this.add(PhoneVerificationSuccessEvent(message: value.message));
      }else
        this.add(PhoneVerificationErrorEvent(message: value.message));
    });
  }

  void deleteFakeAccount() {
    _service.fakeAccount();
  }

}

abstract class PhoneVerificationEvent { }
class RestPasswordInitEvent  extends PhoneVerificationEvent  {}

class PhoneVerificationSuccessEvent  extends PhoneVerificationEvent  {
  String message;
  PhoneVerificationSuccessEvent({required this.message});
}
class PhoneVerificationCurrentStateEvent  extends PhoneVerificationEvent  {
  String message;
  PhoneVerificationCurrentStateEvent({required this.message});
}

class PhoneVerificationLoadingEvent  extends PhoneVerificationEvent  {}

class PhoneVerificationErrorEvent  extends PhoneVerificationEvent  {
  String message;
  PhoneVerificationErrorEvent({required this.message});
}

abstract class PhoneVerificationStates {}

class PhoneVerificationInitState extends PhoneVerificationStates {}

class PhoneVerificationSuccessState extends PhoneVerificationStates {
    String message;
    PhoneVerificationSuccessState({required this.message});
}
class PhoneVerificationCurrentState extends PhoneVerificationStates {
  String message;
  PhoneVerificationCurrentState({required this.message});
}
class PhoneVerificationLoadingState extends PhoneVerificationStates {}

class PhoneVerificationErrorState extends PhoneVerificationStates {
    String message;
    PhoneVerificationErrorState({required this.message});
}
