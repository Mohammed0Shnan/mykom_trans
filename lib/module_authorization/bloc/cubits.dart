import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordHiddinCubit extends Cubit<PasswordHiddinCubitState> {
  PasswordHiddinCubit() : super(PasswordHiddinCubitState.VISIBILITY_OFF);

  changeState() => emit(state == PasswordHiddinCubitState.VISIBILITY
      ? PasswordHiddinCubitState.VISIBILITY_OFF
      : PasswordHiddinCubitState.VISIBILITY);
}

enum PasswordHiddinCubitState { VISIBILITY, VISIBILITY_OFF }
