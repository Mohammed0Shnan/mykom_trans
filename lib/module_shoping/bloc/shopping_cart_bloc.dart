import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import "package:collection/collection.dart";

class ShopCartBloc extends Bloc<CartEvents,CartState> {
  final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  double mimimum_purch=0.0;
  ShopCartBloc() : super(CartLoading()){

    on<CartEvents>((CartEvents event, Emitter<CartState> emit){
      if(event is CartStartedEvent){
        emit(CartLoaded(cart: Cart(products: [],minimum_pursh: mimimum_purch)));
      }
      else if(event is CartAddedEvent){

        if(state is CartLoaded){
          emit(CartLoaded(cart: Cart(products: List.from( (state as CartLoaded ).cart.products)..add(event.productModel),minimum_pursh: mimimum_purch,)
          ));
        }
      }
      else if(event is CartRemovedEvent){
        if(state is CartLoaded){
          emit(CartLoaded(cart: Cart( products:List.from( (state as CartLoaded ).cart.products)..remove(event.productModel),minimum_pursh: mimimum_purch)
          ));
        }
      }


      else if(event is CartAddListEvent){
        if(state is CartLoaded){
          emit(CartLoaded(cart: Cart( products:List.from( (state as CartLoaded ).cart.products)..addAll(event.products),minimum_pursh: mimimum_purch)
          ));
        }}


      });
    add(CartStartedEvent());

  }

  startedShop()async{
   double? res = await _preferencesHelper.getMinimumPurchaseStore();
   print('<<<<<<<<<<<<<<<<<<< started shopping >>>>>>>>>>>>>>>>>>');
   mimimum_purch = res==null?0.0:res;
    add(CartStartedEvent());
  }

  Future<void> addProductToCart(ProductModel productModel) async{
    this.add(CartAddedEvent(productModel));
  }

 Future<void> removeProductFromCart(ProductModel productModel) async{
   this.add(CartRemovedEvent(productModel));
 }

 Future addProductsToCart(ProductModel productModel, int quantity) async{
   List<ProductModel> products =[];

   for(int i=0;i<quantity;i++){
     products.add(productModel);
   }
  this.add(CartAddListEvent(products));
   return ;
  }
  
}






abstract class  CartState {

}
class CartLoading extends CartState{

}
class CartLoaded  extends CartState{

 final Cart cart ;
  CartLoaded({ this.cart = const Cart()});
}
class CartError extends CartState{

}


abstract class  CartEvents extends Equatable{
  @override
  List<Object?> get props => [];
}
class CartStartedEvent extends CartEvents{
  @override
  List<Object?> get props => [];

}
class CartAddListEvent extends CartEvents{
  List<ProductModel> products;
  CartAddListEvent(this.products);
  @override
  List<Object?> get props => [];
}
class CartAddedEvent  extends CartEvents{
  ProductModel productModel;
  CartAddedEvent(this.productModel);
  @override
  List<Object?> get props => [];
}
class CartRemovedEvent extends CartEvents{
  ProductModel productModel;
  CartRemovedEvent(this.productModel);
  @override
  List<Object?> get props => [];
}





class Cart extends Equatable {
  final double minimum_pursh ;
  final List<ProductModel>products;
  const Cart({this.products = const <ProductModel>[],this.minimum_pursh =0.0});

 Map<ProductModel,int> productQuantity(List<ProductModel> products){
   Map<ProductModel,int> quantityMap = Map<ProductModel,int>();

   Map<String , List<ProductModel>> _gruoped_products_list =   groupBy(products, (ProductModel p0) =>p0.id);
   _gruoped_products_list.forEach((key, value) {
     quantityMap[value.first] = value.length;
   });

   // _gruoped_list_product.forEach((element) {
   //   if(!quantityMap.containsKey(element)){
   //     quantityMap[element]= 1;
   //   }
   //   else{
   //     quantityMap[element] =    quantityMap[element]! + 1;
   //   }
   // });


   return quantityMap;

 }
 double get subTotal=>products.fold(0, (total, current) => total + current.price);

  double deliveryFee(subTotal){
    if(subTotal >= 500.0){
      return 20.0;
    }else{
      return 50.0;
    }
  }

  double total(subTotal , deliveryFee){
    return subTotal+ deliveryFee(subTotal);
  }

 bool minimum(){
 return  subTotal < this.minimum_pursh ? false:true;

  }
  String freeDelivery(subTotal){
    if(subTotal>= 30.0){
      return 'You have free delivery';
    }else{
      double missing = 30.0 - subTotal;
      return 'Add \$${missing.toStringAsFixed(2)} for FREE Delivery';
    }
  }

  String get subTotalString=>subTotal.toString();
  String get totalString=>subTotal.toString();
  String get deliveryFreeString=>deliveryFee(subTotal).toStringAsFixed(2);
  String get freeDeliveryString=>freeDelivery(subTotal);


  @override
  List<Object?> get props => [products];
}

ShopCartBloc shopCartBloc = ShopCartBloc();