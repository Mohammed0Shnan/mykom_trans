import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';

class ProductsCompanyBloc extends Bloc<ProductsCompanyEvent, ProductsCompanyStates> {
  final CompanyService _service = CompanyService();
  ProductsCompanyBloc() : super(ProductsCompanyLoadingState()) {

    on<ProductsCompanyEvent>((ProductsCompanyEvent event, Emitter<ProductsCompanyStates> emit) {
      if (event is ProductsCompanyLoadingEvent)
        emit(ProductsCompanyLoadingState());
      else if (event is ProductsCompanyErrorEvent){
        emit(ProductsCompanyErrorState(message: event.message));
      }
      else if (event is ProductsCompanySuccessEvent)
      emit(ProductsCompanySuccessState(data: event.data));
    });

        
  }


  // getProducts(String compny_id) async {
  //   this.add(ProductsCompanyLoadingEvent());
  //   _service.getCompanyProducts(compny_id).then((value) {
  //     if (value != null) {
  //       this.add(ProductsCompanySuccessEvent(data: value));
  //     } else{
  //       this.add(ProductsCompanyErrorEvent(message: 'Error '));
  //
  //     }
  //   });
  // }
}

abstract class ProductsCompanyEvent { }
class ProductsCompanyInitEvent  extends ProductsCompanyEvent  {}

class ProductsCompanySuccessEvent  extends ProductsCompanyEvent  {
  List<ProductModel>  data;
  ProductsCompanySuccessEvent({required this.data});
}

class ProductsCompanyLoadingEvent  extends ProductsCompanyEvent  {}

class ProductsCompanyErrorEvent  extends ProductsCompanyEvent  {
  String message;
  ProductsCompanyErrorEvent({required this.message});
}

abstract class ProductsCompanyStates {}

class ProductsCompanyInitState extends ProductsCompanyStates {}

class ProductsCompanySuccessState extends ProductsCompanyStates {
     List<ProductModel>  data;
  ProductsCompanySuccessState({required this.data});
}

class ProductsCompanyLoadingState extends ProductsCompanyStates {}

class ProductsCompanyErrorState extends ProductsCompanyStates {
    String message;
  ProductsCompanyErrorState({required this.message});
}

ProductsCompanyBloc productsCompanyBloc = ProductsCompanyBloc();