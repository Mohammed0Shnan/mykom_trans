import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';

class ProductsCompanyBloc extends Bloc<ProductsCompanyEvent, ProductsCompanyStates> {
  final CompanyService _service = CompanyService();
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  ProductsCompanyBloc() : super(ProductsCompanyInitState()) {

    on<ProductsCompanyEvent>((ProductsCompanyEvent event, Emitter<ProductsCompanyStates> emit) {
      if (event is ProductsCompanyLoadingEvent)
        emit(ProductsCompanyLoadingState());
      else if (event is ProductsCompanyErrorEvent){
        emit(ProductsCompanyErrorState(message: event.message));
      }
      else if (event is ProductsCompanySuccessEvent){
        emit(ProductsCompanySuccessState(data: event.data));}
      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }

    });
    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });
  }

  // _onSuccessEvent(ProductsCompanySuccessEvent event, Emitter<ProductsCompanyStates> emit){
  // List<ProductModel> list = event.data;
  // Map<ProductModel , int> map = <ProductModel , int>{};
  // list.forEach((element) { map.addAll({element: 0});});
  // emit(ProductsCompanySuccessState(data: map));
  // }

  // _update1(){
  //   add(UpdateProductsCompanySuccessEvent());
  //
  // }
  // _update(UpdateProductsCompanySuccessEvent event, Emitter<ProductsCompanyStates> emit){
  //
  //   CartState cartState =  shopBloc.state;
  //   if(this.state is ProductsCompanySuccessState){
  //
  //     Map currentState =( this.state as ProductsCompanySuccessState).data;
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
  //       emit(ProductsCompanySuccessState(data: items));
  //     }
  // }

  List<ProductModel> products =[];
  search(String query){
    print(query);
    List<ProductModel> suggestionList = products.where((element) => element.title.startsWith(query)).toList();
    this.add(ProductsCompanySuccessEvent(data: suggestionList));

  }

  getProducts(String compny_id) async {
    this.add(ProductsCompanyLoadingEvent());
    _service.productCompanyStoresPublishSubject.listen((value) {
      if (value != null) {
        products = value;
        this.add(ProductsCompanySuccessEvent(data: products));
      } else{
        this.add(ProductsCompanyErrorEvent(message: 'Error '));

      }
    });
    _service.getCompanyProducts(compny_id);
  }
}

abstract class ProductsCompanyEvent { }
class ProductsCompanyInitEvent  extends ProductsCompanyEvent  {}

class ProductsCompanySuccessEvent  extends ProductsCompanyEvent  {
  List <ProductModel>  data;
  ProductsCompanySuccessEvent({required this.data});
}
class UpdateProductsCompanySuccessEvent  extends ProductsCompanyEvent  {

  UpdateProductsCompanySuccessEvent();
}

class ProductsCompanyLoadingEvent  extends ProductsCompanyEvent  {}

class ProductsCompanyErrorEvent  extends ProductsCompanyEvent  {
  String message;
  ProductsCompanyErrorEvent({required this.message});
}

abstract class ProductsCompanyStates {}

class ProductsCompanyInitState extends ProductsCompanyStates {}

class ProductsCompanySuccessState extends ProductsCompanyStates {
  List <ProductModel>  data;
  ProductsCompanySuccessState({required this.data});
}


class ProductsCompanyLoadingState extends ProductsCompanyStates {}

class ProductsCompanyErrorState extends ProductsCompanyStates {
    String message;
  ProductsCompanyErrorState({required this.message});
}

ProductsCompanyBloc productsCompanyBloc = ProductsCompanyBloc();