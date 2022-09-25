
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

class NotificationsBloc extends Bloc<NotificationsEvent,NotificationsStates>{
  final OrdersService _ordersService = OrdersService();

  NotificationsBloc() : super(NotificationsLoadingState()) {

    on<NotificationsEvent>((NotificationsEvent event, Emitter<NotificationsStates> emit) {
      if (event is NotificationsLoadingEvent)
        {
          emit(NotificationsLoadingState());

        }
      else if (event is NotificationsErrorEvent){
        emit(NotificationsErrorState(message: event.message));
      }

      else if (event is NotificationsSuccessEvent){
        emit(NotificationsSuccessState(notifications:event.notifications ,message: null));
      }


      // else if (event is CaptainOrderDeletedSuccessEvent){
      //   if(this.state is CaptainOrdersListSuccessState)
      //     {
      //       print(event.orderID);
      //       print('------------------');
      //      List<OrderModel> state = (this.state as  CaptainOrdersListSuccessState ).data;
      //      state.forEach((element) {
      //        print(element.id);
      //      }); print('=============================================');
      //       List<OrderModel> list =[];
      //       state.forEach((element) {
      //         if(element.id != event.orderID)
      //           list.add(element);
      //       });
      //
      //       print(list);
      //       emit(CaptainOrdersListSuccessState(data:list,message:'success'));
      //     }
      //
      //   else
      //   {
      //     emit(CaptainOrderDeletedErrorState(message: 'Success, Refresh!!!',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      //   }
      // }
      // else if(event is CaptainOrderDeletedErrorEvent){
      //   emit(CaptainOrderDeletedErrorState(message: 'Error',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      // }
    });
  }



  void getNotifications() {
    this.add(NotificationsLoadingEvent());
    _ordersService.notificationsPublishSubject.listen((value) {
      if (value != null) {
        this.add(NotificationsSuccessEvent(notifications: value));
      } else {
        this.add(NotificationsErrorEvent(message: 'Error In Fetch notifications !!'));
      }
    });
    _ordersService.getNotifications();
  }

  @override
  Future<void> close() {
    _ordersService.closeStream();
    return super.close();
  }
}

abstract class NotificationsEvent { }
class NotificationsInitEvent  extends NotificationsEvent  {}

class NotificationsSuccessEvent  extends NotificationsEvent  {
  List<NotificationModel>  notifications;
  NotificationsSuccessEvent({required this.notifications,});
}
class NotificationsLoadingEvent  extends NotificationsEvent  {}

class NotificationsErrorEvent  extends NotificationsEvent  {
  String message;
  NotificationsErrorEvent({required this.message});
}



abstract class NotificationsStates {}

class NotificationsInitState extends NotificationsStates {}

class NotificationsSuccessState extends NotificationsStates {
  List<NotificationModel>  notifications;
  String? message;
NotificationsSuccessState({required this.notifications,required this.message});
}
class NotificationsLoadingState extends NotificationsStates {}

class NotificationsErrorState extends NotificationsStates {
  String message;
  NotificationsErrorState({required this.message});
}




