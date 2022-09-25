
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';

class CaptainOrdersListBloc extends Bloc<CaptainOrdersListEvent,CaptainOrdersListStates>{
  final OrdersService _ordersService = OrdersService();

  CaptainOrdersListBloc() : super(CaptainOrdersListLoadingState()) {

    on<CaptainOrdersListEvent>((CaptainOrdersListEvent event, Emitter<CaptainOrdersListStates> emit) {
      if (event is CaptainOrdersListLoadingEvent)
        {
          emit(CaptainOrdersListLoadingState());

        }
      else if (event is CaptainOrdersListErrorEvent){
        emit(CaptainOrdersListErrorState(message: event.message));
      }

      else if (event is CaptainOrdersListSuccessEvent){
        emit(CaptainOrdersListSuccessState(currentOrders: event.currentOrders,previousOrders: event.previousOrders,message: null));
      }
    });
  }



  void getMyOrders() {

     this.add(CaptainOrdersListLoadingEvent());
     _ordersService.orderPublishSubject.listen((value) {

       if(value != null){
         this.add(CaptainOrdersListSuccessEvent(currentOrders: value['cur']!,previousOrders: value['pre']!));

       }else
       {
         this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
       }
     });
     _ordersService.getMyOrders();
  }


  @override
  Future<void> close() {
    _ordersService.closeStream();
    return super.close();
  }
}

abstract class CaptainOrdersListEvent { }
class CaptainOrdersListInitEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListSuccessEvent  extends CaptainOrdersListEvent  {
  List<OrderModel>  currentOrders;
  List<OrderModel>  previousOrders;
  CaptainOrdersListSuccessEvent({required this.currentOrders,required this.previousOrders});
}
class CaptainOrdersListLoadingEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrdersListErrorEvent({required this.message});
}

class CaptainOrderDeletedErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrderDeletedErrorEvent({required this.message});
}


class CaptainOrderDeletedSuccessEvent  extends CaptainOrdersListEvent  {
  String orderID;
  CaptainOrderDeletedSuccessEvent({required this.orderID});
}



abstract class CaptainOrdersListStates {}

class CaptainOrdersListInitState extends CaptainOrdersListStates {}

class CaptainOrdersListSuccessState extends CaptainOrdersListStates {
  List<OrderModel>  currentOrders;
  List<OrderModel>  previousOrders;

  String? message;
  CaptainOrdersListSuccessState({required this.currentOrders,required this.previousOrders,required this.message});
}
class CaptainOrdersListLoadingState extends CaptainOrdersListStates {}

class CaptainOrdersListErrorState extends CaptainOrdersListStates {
  String message;
  CaptainOrdersListErrorState({required this.message});
}

class CaptainOrderDeletedErrorState extends CaptainOrdersListStates {
  String message;
  List<OrderModel>  data;
  CaptainOrderDeletedErrorState({ required this.data,required this.message});
}




