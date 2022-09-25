// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
// import 'package:my_kom/module_shoping/models/card_model.dart';
// import 'package:my_kom/module_shoping/service/card_service.dart';
//
//
// class StripeServices{
//   final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();
//   // 'pk_test_51L31qjEOejDdCXYkIPhMYzZOWozqLu17OdSuRL6TmnUu64DxYmtgSD6jE5xwhI0VlOtDLvo6scxTb0UIJyVyLXfl00qapSV3TY'
//   static const PUBLISHABLE_KEY = "pk_test_A4nXLMSuUFOORBC9PE1x0TmK00Flkotazb";
//   //'sk_test_51L31qjEOejDdCXYkIUnoDodMUwISr1m4oQzQ6otRRXDKZGrid7r6FWljE7huuKQKogk1pofjWSFp1Tj8nJH3RgOH00TwZFnUWq'
//   static const SECRET_KEY = "sk_test_lkszgvX0S87KLLs7NmunPr5Z00F8lcHe6s";
//   static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
//   static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
//   static const CHARGE_URL = "https://api.stripe.com/v1/charges";
//   Map<String, String> headers = {
//     'Authorization': "Bearer  $SECRET_KEY",
//     "Content-Type": "application/x-www-form-urlencoded"
//   };
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//
//   Future<String> createStripeCustomer({required String email , required String uid})async{
//     Map<String, String> body = {
//       'email': email,
//     };
//     String stripeId = await http.post(
//     Uri.parse(CUSTOMERS_URL)
//     , body: body, headers: headers).then((response)async{
//      String stripeId = jsonDecode(response.body)["id"];
//       print("The stripe id is: $stripeId");
//
//      var existingProfile =
//          await _firestore.collection('users').doc(uid).get();
//
//      if (!existingProfile.exists) {
//        throw Exception('Profile dosnt exsit !');
//      }
//
//      existingProfile.reference
//          .update({'stripeId':stripeId})
//          .then((value) => null)
//          .catchError((error) {
//        throw Exception('Error in set data !');
//      });
//       // userService.updateDetails({
//       //   "id": userId,
//       //   "stripeId": stripeId
//       // });
//       return stripeId;
//     }).catchError((err){
//       print("==== THERE WAS AN ERROR ====: ${err.toString()}");
//       return null;
//     });
//
//     return stripeId;
//   }
//
//   Future<CardModel> addCard({required int cardNumber,required int month,required int year,required int cvc,required String stripeId,required String userId})async{
//     String? uid = await _authPrefsHelper.getUserId();
//
//     Map body = {
//       "type": "card",
//       "card[number]": cardNumber,
//       "card[exp_month]": month,
//       "card[exp_year]":year,
//       "card[cvc]":cvc
//     };
//     Dio().post(PAYMENT_METHOD_URL, data: body, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response)async{
//       String paymentMethod = response.data["id"];
//       print("=== The payment mathod id id ===: $paymentMethod");
//       http.post(Uri.parse("https://api.stripe.com/v1/payment_methods/$paymentMethod/attach"), body: {
//         "customer": stripeId
//       },
//       headers: headers
//       ).catchError((err){
//         print("ERROR ATTACHING CARD TO CUSTOMER");
//         print("ERROR: ${err.toString()}");
//
//       });
//
//       CardServices cardServices = CardServices();
//       cardServices.createCard(id: paymentMethod, last4: int.parse(cardNumber.toString().substring(11)), exp_month: month, exp_year: year, userId: userId, card_number: '');
//
//       var existingProfile =
//           await _firestore.collection('users').doc(uid).get();
//
//       if (!existingProfile.exists) {
//         throw Exception('Profile dosnt exsit !');
//       }
//
//       existingProfile.reference
//           .update({"id": userId,
//         "activeCard": paymentMethod})
//           .then((value) => null)
//           .catchError((error) {
//         throw Exception('Error in set data !');
//       });
//
//
//     });
//     CardModel cardModel = CardModel(id: stripeId,cardNumber:cardNumber.toString() ,userID: userId,last4: int.parse(cardNumber.toString().substring(11)),year: year,month: month);
//
//     //CardModel cardModel = CardModel(id: stripeId,cardNumber:cardNumber.toString() );
//     return cardModel;
//   }
//
//   Future<bool> charge({required String customer,required double amount,required String userId,required String cardId})async{
//     Map<String, dynamic> data ={
//       "amount": amount,
//       "currency": "usd",
//       "source": cardId,
//       "customer": customer
//     };
//     try{
//      await Dio().post(CHARGE_URL, data: data, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response){
//         print(response.toString());
//       });
//      return true;
//     }catch(e){
//       print("there was an error charging the customer: ${e.toString()}");
//       return false;
//     }
//   }
//
// }