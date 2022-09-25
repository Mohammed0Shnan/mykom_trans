import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_profile/model/quick_location_model.dart';

class CheckAddressBloc extends Bloc<CheckAddressEvent, CheckAddressStates> {
  final MapService _service = MapService() ;

  CheckAddressBloc() : super(CheckAddressLoadingState()) {

    on<CheckAddressEvent>((CheckAddressEvent event, Emitter<CheckAddressStates> emit) {
      if (event is CheckAddressLoadingEvent)
        emit(CheckAddressLoadingState());
      else if (event is CheckAddressErrorEvent){
        emit(CheckAddressErrorState());
      }
      else if (event is CheckAddressSuccessEvent)
        emit(CheckAddressSuccessState(saved: event.saved));
    });
  }

  checkAddress( String storeId,String address) async{
    this.add(CheckAddressLoadingEvent());
    _service.checkAddressInArea(storeId, address).then((value) {
      if (value){
        this.add(CheckAddressSuccessEvent(saved: false));
      } else{
        this.add(CheckAddressErrorEvent());
      }
    });
  }

  saveAddress(QuickLocationModel quickLocationModel) async{
    _service.saveQuickLocation(quickLocationModel).then((value) {
      if (value){
        this.add(CheckAddressSuccessEvent(saved: true));
      } else{
        this.add(CheckAddressErrorEvent());
      }
    });
  }
}

abstract class CheckAddressEvent { }
class CheckAddressInitEvent  extends CheckAddressEvent  {}

class CheckAddressSuccessEvent  extends CheckAddressEvent  {
  bool saved;
  CheckAddressSuccessEvent({required this.saved});
}

class CheckAddressLoadingEvent  extends CheckAddressEvent  {}

class CheckAddressErrorEvent  extends CheckAddressEvent  {

  CheckAddressErrorEvent();
}

abstract class CheckAddressStates {}

class CheckAddressInitState extends CheckAddressStates {}

class CheckAddressSuccessState extends CheckAddressStates {
  bool saved;
  CheckAddressSuccessState({required this.saved});
}

class CheckAddressLoadingState extends CheckAddressStates {}

class CheckAddressErrorState extends CheckAddressStates {
  CheckAddressErrorState();
}

