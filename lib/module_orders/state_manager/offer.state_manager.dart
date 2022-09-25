
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';

class OfferBloc extends Bloc<OfferEvent,OfferStates> {
  final OrdersService _service = OrdersService();
  OfferBloc() : super(OfferInitState()) {

    on<OfferEvent>((OfferEvent event, Emitter<OfferStates> emit) {
      if (event is OfferLoadingEvent)
        emit(OfferLoadingState());
      else if (event is OfferErrorEvent){
        emit(OfferErrorState(message: event.message));
      }
      else if (event is OfferSuccessEvent){
        emit(OfferSuccessState(data: event.data));}
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

  void addOffer({required String addressName,
  required DateTime date , required GeoJson destination, required String phoneNumber,required String paymentMethod,
    required  double orderValue , required String cardId,required int offerId,
  }) {
    this.add(OfferLoadingEvent());
    _service
        .addNewOffer()
        .then((response) {
          if(response != null){
            this.add(OfferSuccessEvent(data: response));
          }else{
            this.add(OfferErrorEvent(message: 'Error in create order'));
          }
      }
    );
  }

}



abstract class OfferEvent { }
class OfferInitEvent  extends OfferEvent  {}

class OfferSuccessEvent  extends OfferEvent  {
  OrderModel  data;
  OfferSuccessEvent({required this.data});
}

class OfferLoadingEvent  extends OfferEvent  {}

class OfferErrorEvent  extends OfferEvent  {
  String message;
  OfferErrorEvent({required this.message});
}

abstract class OfferStates {}

class OfferInitState extends OfferStates {}

class OfferSuccessState extends OfferStates {
  OrderModel data;
  OfferSuccessState({required this.data});
}


class OfferLoadingState extends OfferStates {}

class OfferErrorState extends OfferStates {
  String message;
  OfferErrorState({required this.message});
}