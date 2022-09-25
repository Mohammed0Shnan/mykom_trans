

import 'package:flutter_bloc/flutter_bloc.dart';

class AddRemoveProductQuantityBloc extends Cubit<int> {
  AddRemoveProductQuantityBloc() : super(0);
  
  addOne() => emit(state + 1);
  removeOne() => emit((state ==0?0:state-1));
  clear()=> emit(0);
  
}