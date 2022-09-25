import 'package:flutter_bloc/flutter_bloc.dart';

class OpenCloseMenuBloc extends Cubit<bool> {
  OpenCloseMenuBloc() : super(false) ;
  openMenu() => emit(true);
  closeMenu() => emit(false);
}
