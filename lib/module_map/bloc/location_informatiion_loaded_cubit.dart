import 'package:flutter_bloc/flutter_bloc.dart';

class LocationInformationLoadCubit extends Cubit<LocationInformationLoadCubitState> {
  LocationInformationLoadCubit() : super(LocationInformationLoadCubitState.LOADING);

  emitLoadingState()=>emit(  LocationInformationLoadCubitState.LOADING);
  emitLoadedState()=>emit(  LocationInformationLoadCubitState.LOADED);
  emitErrorState()=>emit(  LocationInformationLoadCubitState.ERROR);


}

enum LocationInformationLoadCubitState { LOADED, LOADING,ERROR }
