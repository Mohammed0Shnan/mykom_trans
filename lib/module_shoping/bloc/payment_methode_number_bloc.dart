

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_shoping/models/card_model.dart';
import 'package:my_kom/module_shoping/service/card_service.dart';

class PaymentMethodeNumberBloc extends Cubit<PaymentState> {
  CardServices cardServices = CardServices();
  AuthPrefsHelper authPrefsHelper = AuthPrefsHelper();
  PaymentMethodeNumberBloc() : super(PaymentState(cards: [] , paymentMethodeCreditGroupValue: '')){
    getCards();
  }


 Future<void> getCards()async{
   String? uid =await authPrefsHelper.getUserId();
   await cardServices.getCards(userId: uid!).then((value) {
     PaymentState newState =  PaymentState(cards: value, paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue);
     return emit(newState);
   });


  }
  
  addOne(CardModel card){
    cardServices.createCard(id: card.id, userId: card.userId, exp_month: card.month, exp_year: card.year, last4: card.last4,card_number: card.cardNumber.toString()).then((value) {
      getCards();
    }).catchError((e){

    });
 // PaymentState newState =  PaymentState(cards: List.from(state.cards)..add(card), paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue);
//return emit(newState);
  }
  removeOne(CardModel card) {
    cardServices.deleteCard({'id':card.id}).then((value) {
     getCards();
    }).catchError((e){

    });
  //  PaymentState newState =  PaymentState(cards: List.from(state.cards)..remove(card), paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue);
  //  return emit(newState);
  }
  clear()=> emit(PaymentState(cards: [] , paymentMethodeCreditGroupValue: ''));
  changeSelect(String value){
  return emit(PaymentState(cards: state.cards , paymentMethodeCreditGroupValue: value));
  }

}
class PaymentState{
 String paymentMethodeCreditGroupValue;
  List<CardModel> cards;
 PaymentState({required this.cards , required this.paymentMethodeCreditGroupValue});
}