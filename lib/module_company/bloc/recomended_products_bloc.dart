
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_home/models/advertisement_model.dart';

class RecommendedProductsCompanyBloc extends Bloc<RecommendedProductsCompanyEvent, RecommendedProductsCompanyStates> {
  final CompanyService service ;
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  RecommendedProductsCompanyBloc(this.service) : super(RecommendedProductsCompanyLoadingState()) {

    on<RecommendedProductsCompanyEvent>((RecommendedProductsCompanyEvent event, Emitter<RecommendedProductsCompanyStates> emit) {
      if (event is RecommendedProductsCompanyLoadingEvent)
        emit(RecommendedProductsCompanyLoadingState());
      else if (event is RecommendedProductsCompanyErrorEvent){
        emit(RecommendedProductsCompanyErrorState(message: event.message));
      }
      else if (event is RecommendedProductsCompanySuccessEvent){
        emit(RecommendedProductsCompanySuccessState(data: event.data));}

      else if (event is RecommendedProductsCompanyZoneErrorEvent){
        emit(RecommendedProductsCompanyZoneErrorState(message: event.message));
      }

      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }

    });

  }


  getRecommendedProducts(String? storeId) async {
    print(storeId);
    this.add(RecommendedProductsCompanyLoadingEvent());
    service.advertisementsCompanyStoresPublishSubject.listen((value) {
      if (value != null) {
        this.add(RecommendedProductsCompanySuccessEvent(data: value));
      } else{
        this.add(RecommendedProductsCompanyErrorEvent(message: 'Error in fetch advertisements'));
      }
    });
    service.getAdvertisements(storeId).onError((error, stackTrace) {
      this.add(RecommendedProductsCompanyZoneErrorEvent(message: 'This area is currently available!! '));
    });
  }
}

abstract class RecommendedProductsCompanyEvent { }
class RecommendedProductsCompanyInitEvent  extends RecommendedProductsCompanyEvent  {}

class RecommendedProductsCompanySuccessEvent  extends RecommendedProductsCompanyEvent  {
  List <AdvertisementModel>  data;
  RecommendedProductsCompanySuccessEvent({required this.data});
}
class RecommendedUpdateProductsCompanySuccessEvent  extends RecommendedProductsCompanyEvent  {

  RecommendedUpdateProductsCompanySuccessEvent();
}

class RecommendedProductsCompanyLoadingEvent  extends RecommendedProductsCompanyEvent  {}

class RecommendedProductsCompanyErrorEvent  extends RecommendedProductsCompanyEvent  {
  String message;
  RecommendedProductsCompanyErrorEvent({required this.message});
}

class RecommendedProductsCompanyZoneErrorEvent  extends RecommendedProductsCompanyEvent  {
  String message;
  RecommendedProductsCompanyZoneErrorEvent({required this.message});
}


abstract class RecommendedProductsCompanyStates {}

class RecommendedProductsCompanyInitState extends RecommendedProductsCompanyStates {}

class RecommendedProductsCompanySuccessState extends RecommendedProductsCompanyStates {
  List <AdvertisementModel>  data;
  RecommendedProductsCompanySuccessState({required this.data});
}


class RecommendedProductsCompanyLoadingState extends RecommendedProductsCompanyStates {}

class RecommendedProductsCompanyErrorState extends RecommendedProductsCompanyStates {
  String message;
  RecommendedProductsCompanyErrorState({required this.message});
}


class RecommendedProductsCompanyZoneErrorState extends RecommendedProductsCompanyStates {
  String message;
  RecommendedProductsCompanyZoneErrorState({required this.message});
}


//////
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_kom/module_company/models/product_model.dart';
// import 'package:my_kom/module_company/service/company_service.dart';
//
// class RecommendedProductsCompanyBloc extends Bloc<RecommendedProductsCompanyEvent, RecommendedProductsCompanyStates> {
//   final CompanyService service ;
//   // final ShopCartBloc shopBloc = shopCartBloc;
//   // late StreamSubscription streamSubscription ;
//   RecommendedProductsCompanyBloc(this.service) : super(RecommendedProductsCompanyLoadingState()) {
//
//     on<RecommendedProductsCompanyEvent>((RecommendedProductsCompanyEvent event, Emitter<RecommendedProductsCompanyStates> emit) {
//       if (event is RecommendedProductsCompanyLoadingEvent)
//         emit(RecommendedProductsCompanyLoadingState());
//       else if (event is RecommendedProductsCompanyErrorEvent){
//         emit(RecommendedProductsCompanyErrorState(message: event.message));
//       }
//       else if (event is RecommendedProductsCompanySuccessEvent){
//         emit(RecommendedProductsCompanySuccessState(data: event.data));}
//
//       else if (event is RecommendedProductsCompanyZoneErrorEvent){
//         emit(RecommendedProductsCompanyZoneErrorState(message: event.message));
//       }
//
//       // else if(event is UpdateProductsCompanySuccessEvent){
//       //   _update(event,emit);
//       // }
//
//     });
//
//   }
//
//
//   getRecommendedProducts(String? storeId) async {
//     this.add(RecommendedProductsCompanyLoadingEvent());
//     service.recommendedProductsPublishSubject.listen((value) {
//       if (value != null) {
//         this.add(RecommendedProductsCompanySuccessEvent(data: value));
//       } else{
//         this.add(RecommendedProductsCompanyErrorEvent(message: 'Error in fetch recommended products'));
//
//       }
//     });
//     service.getRecommendedProducts(storeId).onError((error, stackTrace) {
//       this.add(RecommendedProductsCompanyZoneErrorEvent(message: 'This area is currently available!! '));
//     });
//   }
// }
//
// abstract class RecommendedProductsCompanyEvent { }
// class RecommendedProductsCompanyInitEvent  extends RecommendedProductsCompanyEvent  {}
//
// class RecommendedProductsCompanySuccessEvent  extends RecommendedProductsCompanyEvent  {
//   List <ProductModel>  data;
//   RecommendedProductsCompanySuccessEvent({required this.data});
// }
// class RecommendedUpdateProductsCompanySuccessEvent  extends RecommendedProductsCompanyEvent  {
//
//   RecommendedUpdateProductsCompanySuccessEvent();
// }
//
// class RecommendedProductsCompanyLoadingEvent  extends RecommendedProductsCompanyEvent  {}
//
// class RecommendedProductsCompanyErrorEvent  extends RecommendedProductsCompanyEvent  {
//   String message;
//   RecommendedProductsCompanyErrorEvent({required this.message});
// }
//
// class RecommendedProductsCompanyZoneErrorEvent  extends RecommendedProductsCompanyEvent  {
//   String message;
//   RecommendedProductsCompanyZoneErrorEvent({required this.message});
// }
//
//
// abstract class RecommendedProductsCompanyStates {}
//
// class RecommendedProductsCompanyInitState extends RecommendedProductsCompanyStates {}
//
// class RecommendedProductsCompanySuccessState extends RecommendedProductsCompanyStates {
//   List <ProductModel>  data;
//   RecommendedProductsCompanySuccessState({required this.data});
// }
//
//
// class RecommendedProductsCompanyLoadingState extends RecommendedProductsCompanyStates {}
//
// class RecommendedProductsCompanyErrorState extends RecommendedProductsCompanyStates {
//   String message;
//   RecommendedProductsCompanyErrorState({required this.message});
// }
//
//
// class RecommendedProductsCompanyZoneErrorState extends RecommendedProductsCompanyStates {
//   String message;
//   RecommendedProductsCompanyZoneErrorState({required this.message});
// }
