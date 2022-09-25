import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';

class AllCompanyBloc extends Bloc<AllCompanyEvent, AllCompanyStates> {
  final CompanyService _service ;

  AllCompanyBloc(this._service) : super(AllCompanyInitState()) {
    
    on<AllCompanyEvent>((AllCompanyEvent event, Emitter<AllCompanyStates> emit) {
      if (event is AllCompanyLoadingEvent)
        emit(AllCompanyLoadingState());
      else if (event is AllCompanyErrorEvent){
        emit(AllCompanyErrorState(message: event.message));
      }
      else if (event is AllCompanySuccessEvent) 
      emit(AllCompanySuccessState(data: event.data));

      else if (event is AllCompanyZoneErrorEvent)
        emit(AllCompanyZoneErrorState(message: event.message));

      else if(event is AllCompanyInitEvent) {
        print('----------- emit init state -------------');
        AllCompanyInitState();
      }
    });
  }

  getAllCompany(String storeId) async{
    this.add(AllCompanyLoadingEvent());
    _service.companyStoresPublishSubject.listen((value) {
      if (value != null){
        this.add(AllCompanySuccessEvent(data: value));
      } else{
        this.add(AllCompanyErrorEvent(message: 'Error '));
      }
    });
    try{
      _service.getAllCompanies(storeId);
    }catch(e){
      print( 'This area is currently available!! ');
      this.add(AllCompanyZoneErrorEvent(message: 'This area is currently available!! '));
    }

  }

  void setInit() {

    add(AllCompanySuccessEvent(data: []));
  }

}

abstract class AllCompanyEvent { }
class AllCompanyInitEvent  extends AllCompanyEvent  {}

class AllCompanySuccessEvent  extends AllCompanyEvent  {
  List<CompanyModel>  data;
  AllCompanySuccessEvent({required this.data});
}

class AllCompanyLoadingEvent  extends AllCompanyEvent  {}

class AllCompanyErrorEvent  extends AllCompanyEvent  {
  String message;
  AllCompanyErrorEvent({required this.message});
}

class AllCompanyZoneErrorEvent  extends AllCompanyEvent  {
  String message;
  AllCompanyZoneErrorEvent({required this.message});
}

abstract class AllCompanyStates {}

class AllCompanyInitState extends AllCompanyStates {}

class AllCompanySuccessState extends AllCompanyStates {
     List<CompanyModel>  data;
  AllCompanySuccessState({required this.data});
}

class AllCompanyLoadingState extends AllCompanyStates {}

class AllCompanyErrorState extends AllCompanyStates {
    String message;
  AllCompanyErrorState({required this.message});
}

class AllCompanyZoneErrorState extends AllCompanyStates {
  String message;
  AllCompanyZoneErrorState({required this.message});
}
