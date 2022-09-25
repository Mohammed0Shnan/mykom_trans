import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_profile/model/quick_location_model.dart';
import 'package:my_kom/module_profile/service/profile_service.dart';

class MyAddressesBloc extends Bloc<MyAddressesEvent, MyAddressesStates> {
  final ProfileService _service = ProfileService() ;

  MyAddressesBloc() : super(MyAddressesLoadingState()) {

    on<MyAddressesEvent>((MyAddressesEvent event, Emitter<MyAddressesStates> emit) {
      if (event is MyAddressesLoadingEvent)
        emit(MyAddressesLoadingState());
      else if (event is MyAddressesErrorEvent){
        emit(MyAddressesErrorState());
      }
      else if (event is MyAddressesSuccessEvent)
        emit(MyAddressesSuccessState(event.list));
    });
  }

  getLocations() async{
    this.add(MyAddressesLoadingEvent());
    _service.getMyLocations().then((value) {
      if (value!= null){
        this.add(MyAddressesSuccessEvent(value));
      } else{
        this.add(MyAddressesErrorEvent());
      }
    });
  }

  Future<void> removeLocation(String id) async{
   return await _service.deleteLocation(id).then((value) {
      if (value!= null){
        this.add(MyAddressesSuccessEvent(value));
      } else{
        this.add(MyAddressesErrorEvent());
      }
    });
  }

}

abstract class MyAddressesEvent { }
class MyAddressesInitEvent  extends MyAddressesEvent  {}

class MyAddressesSuccessEvent  extends MyAddressesEvent  {
  List<QuickLocationModel> list;
  MyAddressesSuccessEvent(this.list);
}

class MyAddressesLoadingEvent  extends MyAddressesEvent  {}

class MyAddressesErrorEvent  extends MyAddressesEvent  {

  MyAddressesErrorEvent();
}

abstract class MyAddressesStates {}

class MyAddressesInitState extends MyAddressesStates {}

class MyAddressesSuccessState extends MyAddressesStates {
  List<QuickLocationModel> list;

  MyAddressesSuccessState(this.list);
}

class MyAddressesLoadingState extends MyAddressesStates {}

class MyAddressesErrorState extends MyAddressesStates {
  MyAddressesErrorState();
}

