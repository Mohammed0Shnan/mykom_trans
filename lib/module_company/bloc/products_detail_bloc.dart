import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';

class ProductDetailBloc extends Bloc<DetailEvent, DetailStates> {
  final CompanyService _service = CompanyService();
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  ProductDetailBloc() : super(DetailLoadingState()) {

    on<DetailEvent>((DetailEvent event, Emitter<DetailStates> emit) {
      if (event is DetailLoadingEvent)
        emit(DetailLoadingState());
      else if (event is DetailErrorEvent){
        emit(DetailErrorState(message: event.message));
      }
      else if (event is DetailSuccessEvent){
        emit(DetailSuccessState(data: event.data));}
      // else if(event is UpdateDetailSuccessEvent){
      //   _update(event,emit);
      // }

    });
    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });
  }

  // _onSuccessEvent(DetailSuccessEvent event, Emitter<DetailStates> emit){
  // List<ProductModel> list = event.data;
  // Map<ProductModel , int> map = <ProductModel , int>{};
  // list.forEach((element) { map.addAll({element: 0});});
  // emit(DetailSuccessState(data: map));
  // }

  // _update1(){
  //   add(UpdateDetailSuccessEvent());
  //
  // }
  // _update(UpdateDetailSuccessEvent event, Emitter<DetailStates> emit){
  //
  //   CartState cartState =  shopBloc.state;
  //   if(this.state is DetailSuccessState){
  //
  //     Map currentState =( this.state as DetailSuccessState).data;
  //     if(cartState is CartLoaded){
  //       Map<ProductModel ,int> items = {};
  //       int q=0;
  //       Map<ProductModel ,int> map= cartState.cart.productQuantity(cartState.cart.products) ;
  //
  //
  //       currentState.forEach((key, value) {
  //         bool isAdded = false;
  //         for(int j=0;j<map.keys.length;j++){
  //           ProductModel productModel =   map.keys.elementAt(j);
  //           if(productModel.id == key.id){
  //
  //             q= map.values.elementAt(j);
  //             items.addAll({productModel:q});
  //             isAdded = ! isAdded;
  //
  //           }
  //         }
  //         if(!isAdded){
  //           q=0;
  //           items.addAll({key:q});
  //
  //         }
  //       });
  //       emit(DetailSuccessState(data: items));
  //     }
  // }



  getProductDetail(String productId) async {
    this.add(DetailLoadingEvent());
    _service.getProductDetail(productId).then((value) {
      if (value != null) {
        this.add(DetailSuccessEvent(data: value));
      } else{
        this.add(DetailErrorEvent(message: 'Error '));

      }
    });
  }
}

abstract class DetailEvent { }
class DetailInitEvent  extends DetailEvent  {}

class DetailSuccessEvent  extends DetailEvent  {
  ProductModel  data;
  DetailSuccessEvent({required this.data});
}
class UpdateDetailSuccessEvent  extends DetailEvent  {

  UpdateDetailSuccessEvent();
}

class DetailLoadingEvent  extends DetailEvent  {}

class DetailErrorEvent  extends DetailEvent  {
  String message;
  DetailErrorEvent({required this.message});
}

abstract class DetailStates {}

class DetailInitState extends DetailStates {}

class DetailSuccessState extends DetailStates {
  ProductModel  data;
  DetailSuccessState({required this.data});
}


class DetailLoadingState extends DetailStates {}

class DetailErrorState extends DetailStates {
    String message;
  DetailErrorState({required this.message});
}

