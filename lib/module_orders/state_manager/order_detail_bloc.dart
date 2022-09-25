
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent,OrderDetailStates> {
  final OrdersService _service = OrdersService();
  OrderDetailBloc() : super(OrderDetailLoadingState()) {

    on< OrderDetailEvent>((  OrderDetailEvent event, Emitter<OrderDetailStates> emit) {
      if (event is   OrderDetailLoadingEvent)
        emit(OrderDetailLoadingState());
      else if (event is   OrderDetailErrorEvent){
        emit(OrderDetailErrorState(message: event.message));
      }
      else if (event is   OrderDetailSuccessEvent){
        emit(OrderDetailSuccessState(data: event.data));}
    });


  }



  void getOrderDetail({required String orderId}) {
    this.add(OrderDetailLoadingEvent());
    _service
        .getOrderDetails(orderId)
        .then((response) {
          if(response != null){
            this.add(OrderDetailSuccessEvent(data: response));
          }else{
            this.add(OrderDetailErrorEvent(message: 'Error in get order detail !!'));
          }
      }
    );
  }
}



abstract class OrderDetailEvent { }

class OrderDetailSuccessEvent  extends OrderDetailEvent  {
  OrderModel  data;
  OrderDetailSuccessEvent({required this.data});
}

class   OrderDetailLoadingEvent  extends  OrderDetailEvent  {}

class   OrderDetailErrorEvent  extends   OrderDetailEvent  {
  String message;
  OrderDetailErrorEvent({required this.message});
}

abstract class   OrderDetailStates {}


class   OrderDetailSuccessState extends  OrderDetailStates {
  OrderModel data;
  OrderDetailSuccessState({required this.data});
}


class   OrderDetailLoadingState extends   OrderDetailStates {}

class   OrderDetailErrorState extends   OrderDetailStates {
  String message;
  OrderDetailErrorState({required this.message});
}