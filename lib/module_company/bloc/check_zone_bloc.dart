
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

class CheckZoneBloc extends Bloc<CheckZoneEvent,CheckZoneStates>{
  final CompanyService companyService ;

  CheckZoneBloc(this.companyService) : super(CheckZoneInitState()) {

    on<CheckZoneEvent>((CheckZoneEvent event, Emitter<CheckZoneStates> emit) {
      if (event is CheckZoneLoadingEvent)
      {
        emit(CheckZoneLoadingState());

      }
      else if (event is CheckZoneErrorEvent){
        emit(CheckZoneErrorState(message: event.message));
      }

      else if (event is CheckZoneSuccessEvent){
        emit(CheckZoneSuccessState(storeId: event.storeId));
      }
    });
  }



   checkZone(String zone) {
    this.add(CheckZoneLoadingEvent());
    companyService.checkStore(zone).then((value) {
      if(value != null){
        add(CheckZoneSuccessEvent(storeId: value));
      }else{
        add(CheckZoneErrorEvent(message: 'This area is currently available!! '));
      }
    });
  }

  refreshZone() {
    this.add(CheckZoneLoadingEvent());
  }

}

abstract class CheckZoneEvent { }
class CheckZoneInitEvent  extends CheckZoneEvent  {}

class CheckZoneSuccessEvent  extends CheckZoneEvent  {
  String storeId;
  CheckZoneSuccessEvent({required this.storeId,});
}
class CheckZoneLoadingEvent  extends CheckZoneEvent  {}

class CheckZoneErrorEvent  extends CheckZoneEvent  {
  String message;
  CheckZoneErrorEvent({required this.message});
}




abstract class CheckZoneStates {}

class CheckZoneInitState extends CheckZoneStates {}

class CheckZoneSuccessState extends CheckZoneStates {

  String storeId;
  CheckZoneSuccessState({required this.storeId});
}
class CheckZoneLoadingState extends CheckZoneStates {}

class CheckZoneErrorState extends CheckZoneStates {
  String message;
  CheckZoneErrorState({required this.message});
}



