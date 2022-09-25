
import 'package:flutter_bloc/flutter_bloc.dart';

enum SwitchItemState{LIST,GRID}

class SwitchItemCubit extends Cubit<SwitchItemState> {
  SwitchItemCubit() : super(SwitchItemState.LIST);

  changeState() => emit(state == SwitchItemState.LIST
      ? SwitchItemState.GRID
      : SwitchItemState.LIST);

}

SwitchItemCubit switchItemBloc = SwitchItemCubit();