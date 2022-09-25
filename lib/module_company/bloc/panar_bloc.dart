
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_home/models/advertisement_model.dart';

class PanarBloc extends Bloc<PanarEvent, PanarStates> {
  final CompanyService service ;
  // final ShopCartBloc shopBloc = shopCartBloc;
  // late StreamSubscription streamSubscription ;
  PanarBloc(this.service) : super(PanarLoadingState()) {

    on<PanarEvent>((PanarEvent event, Emitter<PanarStates> emit) {
      if (event is PanarLoadingEvent)
        emit(PanarLoadingState());
      else if (event is PanarErrorEvent){
        emit(PanarErrorState(message: event.message));
      }
      else if (event is PanarSuccessEvent){
        emit(PanarSuccessState(data: event.data));}

      else if (event is PanarZoneErrorEvent){
        emit(PanarZoneErrorState(message: event.message));
      }

      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }

    });

  }


  getAdvertisements(String? storeId)  {
    this.add(PanarLoadingEvent());
    service.advertisementsCompanyStoresPublishSubject.listen((value) {
      if (value != null) {
        this.add(PanarSuccessEvent(data: value));
      } else{
        this.add(PanarErrorEvent(message: 'Error in fetch advertisements'));
      }
    });
    service.getAdvertisements(storeId).onError((error, stackTrace) {
      this.add(PanarZoneErrorEvent(message: 'This area is currently available!! '));
    });
  }
}

abstract class PanarEvent { }
class PanarInitEvent  extends PanarEvent  {}

class PanarSuccessEvent  extends PanarEvent  {
  List <AdvertisementModel>  data;
  PanarSuccessEvent({required this.data});
}
class PanarUpdateProductsCompanySuccessEvent  extends PanarEvent  {

  PanarUpdateProductsCompanySuccessEvent();
}

class PanarLoadingEvent  extends PanarEvent  {}

class PanarErrorEvent  extends PanarEvent  {
  String message;
  PanarErrorEvent({required this.message});
}

class PanarZoneErrorEvent  extends PanarEvent  {
  String message;
  PanarZoneErrorEvent({required this.message});
}


abstract class PanarStates {}

class PanarInitState extends PanarStates {}

class PanarSuccessState extends PanarStates {
  List <AdvertisementModel>  data;
  PanarSuccessState({required this.data});
}


class PanarLoadingState extends PanarStates {}

class PanarErrorState extends PanarStates {
  String message;
  PanarErrorState({required this.message});
}


class PanarZoneErrorState extends PanarStates {
  String message;
  PanarZoneErrorState({required this.message});
}


//////
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_kom/module_company/models/product_model.dart';
// import 'package:my_kom/module_company/service/company_service.dart';
//
// class PanarBloc extends Bloc<PanarEvent, PanarStates> {
//   final CompanyService service ;
//   // final ShopCartBloc shopBloc = shopCartBloc;
//   // late StreamSubscription streamSubscription ;
//   PanarBloc(this.service) : super(PanarLoadingState()) {
//
//     on<PanarEvent>((PanarEvent event, Emitter<PanarStates> emit) {
//       if (event is PanarLoadingEvent)
//         emit(PanarLoadingState());
//       else if (event is PanarErrorEvent){
//         emit(PanarErrorState(message: event.message));
//       }
//       else if (event is PanarSuccessEvent){
//         emit(PanarSuccessState(data: event.data));}
//
//       else if (event is PanarZoneErrorEvent){
//         emit(PanarZoneErrorState(message: event.message));
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
//     this.add(PanarLoadingEvent());
//     service.recommendedProductsPublishSubject.listen((value) {
//       if (value != null) {
//         this.add(PanarSuccessEvent(data: value));
//       } else{
//         this.add(PanarErrorEvent(message: 'Error in fetch recommended products'));
//
//       }
//     });
//     service.getRecommendedProducts(storeId).onError((error, stackTrace) {
//       this.add(PanarZoneErrorEvent(message: 'This area is currently available!! '));
//     });
//   }
// }
//
// abstract class PanarEvent { }
// class PanarInitEvent  extends PanarEvent  {}
//
// class PanarSuccessEvent  extends PanarEvent  {
//   List <ProductModel>  data;
//   PanarSuccessEvent({required this.data});
// }
// class RecommendedUpdateProductsCompanySuccessEvent  extends PanarEvent  {
//
//   RecommendedUpdateProductsCompanySuccessEvent();
// }
//
// class PanarLoadingEvent  extends PanarEvent  {}
//
// class PanarErrorEvent  extends PanarEvent  {
//   String message;
//   PanarErrorEvent({required this.message});
// }
//
// class PanarZoneErrorEvent  extends PanarEvent  {
//   String message;
//   PanarZoneErrorEvent({required this.message});
// }
//
//
// abstract class PanarStates {}
//
// class PanarInitState extends PanarStates {}
//
// class PanarSuccessState extends PanarStates {
//   List <ProductModel>  data;
//   PanarSuccessState({required this.data});
// }
//
//
// class PanarLoadingState extends PanarStates {}
//
// class PanarErrorState extends PanarStates {
//   String message;
//   PanarErrorState({required this.message});
// }
//
//
// class PanarZoneErrorState extends PanarStates {
//   String message;
//   PanarZoneErrorState({required this.message});
// }
