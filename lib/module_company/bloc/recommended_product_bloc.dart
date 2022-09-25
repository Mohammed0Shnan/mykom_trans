
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';

class RecommendedProductBloc extends Bloc<RecommendedProductEvent, RecommendedProductStates> {
  final CompanyService service ;
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  RecommendedProductBloc(this.service) : super(RecommendedProductLoadingState()) {

    on<RecommendedProductEvent>((RecommendedProductEvent event, Emitter<RecommendedProductStates> emit) {
      if (event is RecommendedProductLoadingEvent)
        emit(RecommendedProductLoadingState());
      else if (event is RecommendedProductErrorEvent){
        emit(RecommendedProductErrorState(message: event.message));
      }
      else if (event is RecommendedProductSuccessEvent){
        emit(RecommendedProductSuccessState(data: event.data));}

      else if (event is RecommendedProductZoneErrorEvent){
        emit(RecommendedProductZoneErrorState(message: event.message));
      }

      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }

    });

  }


  getRecommendedProducts(String storeId)  {
    this.add(RecommendedProductLoadingEvent());

    service.recommendedProductsPublishSubject.listen((value) {
      if (value != null) {
        this.add(RecommendedProductSuccessEvent(data: value));
      } else{
        this.add(RecommendedProductErrorEvent(message: 'Error in fetch advertisements'));
      }
    });
    service.getRecommendedProducts(storeId).onError((error, stackTrace) {
      this.add(RecommendedProductZoneErrorEvent(message: 'This area is currently available!! '));
    });
  }
}

abstract class RecommendedProductEvent { }
class RecommendedProductInitEvent  extends RecommendedProductEvent  {}

class RecommendedProductSuccessEvent  extends RecommendedProductEvent  {
  List <ProductModel>  data;
  RecommendedProductSuccessEvent({required this.data});
}
class RecommendedProductUpdateProductsCompanySuccessEvent  extends RecommendedProductEvent  {

  RecommendedProductUpdateProductsCompanySuccessEvent();
}

class RecommendedProductLoadingEvent  extends RecommendedProductEvent  {}

class RecommendedProductErrorEvent  extends RecommendedProductEvent  {
  String message;
  RecommendedProductErrorEvent({required this.message});
}

class RecommendedProductZoneErrorEvent  extends RecommendedProductEvent  {
  String message;
  RecommendedProductZoneErrorEvent({required this.message});
}


abstract class RecommendedProductStates {}

class RecommendedProductInitState extends RecommendedProductStates {}

class RecommendedProductSuccessState extends RecommendedProductStates {
  List <ProductModel>  data;
  RecommendedProductSuccessState({required this.data});
}


class RecommendedProductLoadingState extends RecommendedProductStates {}

class RecommendedProductErrorState extends RecommendedProductStates {
  String message;
  RecommendedProductErrorState({required this.message});
}


class RecommendedProductZoneErrorState extends RecommendedProductStates {
  String message;
  RecommendedProductZoneErrorState({required this.message});
}


