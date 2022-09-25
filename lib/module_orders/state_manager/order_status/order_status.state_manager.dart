
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
class OrderStatusBloc extends Bloc<OrderStatusEvent,OrderStatusStates> {
  final OrdersService _ordersService = OrdersService();

  OrderStatusBloc() : super(OrderStatusLoadingState()) {

    on< OrderStatusEvent>((  OrderStatusEvent event, Emitter<OrderStatusStates> emit) {
      if (event is   OrderStatusLoadingEvent)
        emit(OrderStatusLoadingState());
      else if (event is  OrderStatusErrorEvent){
        emit(OrderStatusErrorState(message: event.message));
      }
      else if (event is   OrderStatusSuccessEvent){
        emit(OrderStatusSuccessState(data: event.data));}
      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }
    });


  }

  void getOrderDetails(String orderId) {
    this.add(OrderStatusLoadingEvent());

    _ordersService.getTrackingDetails(orderId).then((order) {
      if (order == null) {
        this.add(OrderStatusErrorEvent(message: 'Error !!!'));
        return;
      } else {
        this.add(OrderStatusSuccessEvent(data: order));
        // _authService.userRole.then((role) {
        //   if (role == UserRole.ROLE_USER) {
        //     _stateSubject
        //         .add(OrderDetailsStateCaptainOrderLoaded(order, screenState));
        //   } else if (role == UserRole.ROLE_OWNER) {
        //     _stateSubject
        //         .add(OrderDetailsStateOwnerOrderLoaded(order, screenState));
        //   } else {
        //     _stateSubject.add(OrderDetailsStateError(
        //         'Error Defining Login Type', screenState));
        //   }
        // });
      }
    });
  }

  // void updateOrder(OrderModel model) {
  //   _ordersService.updateOrder(model.id, model).then((value) {
  //     getOrderDetails(model.id);
  //   });
  // }

  void report(int orderId, String reason) {
   // _reportService.createReport(orderId, reason);
  }
}


abstract class OrderStatusEvent { }

class OrderStatusSuccessEvent  extends OrderStatusEvent  {
  OrderModel  data;
  OrderStatusSuccessEvent({required this.data});
}

class  OrderStatusLoadingEvent  extends  OrderStatusEvent  {}

class   OrderStatusErrorEvent  extends   OrderStatusEvent  {
  String message;
  OrderStatusErrorEvent({required this.message});
}

abstract class   OrderStatusStates {}


class  OrderStatusSuccessState extends  OrderStatusStates {
  OrderModel data;
  OrderStatusSuccessState({required this.data});
}


class   OrderStatusLoadingState extends   OrderStatusStates {}

class   OrderStatusErrorState extends   OrderStatusStates {
  String message;
  OrderStatusErrorState({required this.message});
}