
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';

class NewOrderBloc extends Bloc<CreateOrderEvent,CreateOrderStates> {
  final OrdersService _service = OrdersService();
  NewOrderBloc() : super(CreateOrderInitState()) {

    on<CreateOrderEvent>((CreateOrderEvent event, Emitter<CreateOrderStates> emit) {
      if (event is CreateOrderLoadingEvent)
        emit(CreateOrderLoadingState());
      else if (event is CreateOrderErrorEvent){
        emit(CreateOrderErrorState(message: event.message));
      }
      else if (event is CreateOrderSuccessEvent){
        emit(CreateOrderSuccessState(data: event.data));}
      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }
    });

    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });

  }


  // void loadBranches(NewOrderScreenState screenState, LatLng location) {
  //    // _profileService.getMyBranches().then((value) {
  //      _stateSubject.add(NewOrderStateBranchesLoaded([], location, screenState));
  //  //  });
  // }

  void addNewOrder({required String? orderSource,required String note,required String storeId,required List<ProductModel>  product ,required int numberOfMonth,required String addressName, required String deliveryTimes,
  required bool orderType , required GeoJson destination, required String phoneNumber,required String paymentMethod,
    required  double orderValue , required String cardId
  }) {
    this.add(CreateOrderLoadingEvent());
    _service
        .addNewOrder(orderSource:orderSource,note:note, storeId: storeId, productsIds: null,customerOrderID: null, products: product, addressName: addressName,deliveryTimes: deliveryTimes, numberOfMonth: numberOfMonth,orderType: orderType, destination: destination, phoneNumber: phoneNumber, paymentMethod: paymentMethod, amount: orderValue, cardId: cardId,
    reorder: false,description: null)
        .then((response) {
          if(response != null){
            this.add(CreateOrderSuccessEvent(data: response));
          }else{
            this.add(CreateOrderErrorEvent(message: 'Error in create order'));
          }
      }
    );
  }
  reorder(String orderID){
    this.add(CreateOrderLoadingEvent());
    _service
        .reorder(orderID)
        .then((response) {
      if(response!= null){
        this.add(CreateOrderSuccessEvent(data:response ));
      }else{
        this.add(CreateOrderErrorEvent(message: 'Error in create order'));
      }
    }
    );
  }
}



abstract class CreateOrderEvent { }
class CreateOrderInitEvent  extends CreateOrderEvent  {}

class CreateOrderSuccessEvent  extends CreateOrderEvent  {
  OrderModel  data;
  CreateOrderSuccessEvent({required this.data});
}

class CreateOrderLoadingEvent  extends CreateOrderEvent  {}

class CreateOrderErrorEvent  extends CreateOrderEvent  {
  String message;
  CreateOrderErrorEvent({required this.message});
}

abstract class CreateOrderStates {}

class CreateOrderInitState extends CreateOrderStates {}

class CreateOrderSuccessState extends CreateOrderStates {
  OrderModel data;
  CreateOrderSuccessState({required this.data});
}


class CreateOrderLoadingState extends CreateOrderStates {}

class CreateOrderErrorState extends CreateOrderStates {
  String message;
  CreateOrderErrorState({required this.message});
}