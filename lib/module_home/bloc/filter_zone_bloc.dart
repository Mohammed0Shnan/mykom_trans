import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_home/models/search_model.dart';

class FilterZoneCubit extends Cubit<FilterZoneCubitState> {
  FilterZoneCubit() : super(FilterZoneCubitState(searchModel:SearchModel(storeId:'rbma6ffsivqpdEGjb7f3' , zoneName: 'Al Fujeraa')));

  setFilter(SearchModel searchModel){
   return emit(FilterZoneCubitState(searchModel: searchModel));
  }
}

class  FilterZoneCubitState {
  final SearchModel searchModel;
  FilterZoneCubitState({required this.searchModel});
}
