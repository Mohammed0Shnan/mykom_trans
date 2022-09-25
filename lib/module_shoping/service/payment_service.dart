// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:http/http.dart' as http;
//
// class PaymentService {
// final double amount =0;
// final String url = 'https://us-central1-mykom-tech-dist.cloudfunctions.net/paypalPayment';
//
//
// static init(){
// StripePayment.setOptions(
//   StripeOptions(publishableKey: 'pk_test_51L31qjEOejDdCXYkIPhMYzZOWozqLu17OdSuRL6TmnUu64DxYmtgSD6jE5xwhI0VlOtDLvo6scxTb0UIJyVyLXfl00qapSV3TY',
//   )
// );
// }
//
// Future<PaymentMethod> createPaymentMethod()async{
//   print('the transaction amount to be charged is : $amount ');
//   PaymentMethod paymentMethod =await StripePayment.paymentRequestWithCardForm(
//     CardFormPaymentRequest()
//   );
//   return paymentMethod;
// }
//
// Future<void> processPayment(String paymentMethodID)async{
//   final _client = Dio(BaseOptions(
//     sendTimeout: 60000,
//     receiveTimeout: 60000,
//     connectTimeout: 60000,
//   ));
//   final Response response = await  _client.post('$url?amount=$amount&currency=USD&paym=${paymentMethodID}');
//   if(response.data != 'error'){
//     final paymentInent = jsonDecode(response.data);
//     final status = paymentInent['paymentIntent']['status'];
//     if(status == 'succeeded'){
//       print('Payment complete. ${paymentInent['paymentIntent']['amount'].toString()}');
//     }
//     else{
//       print('Payment failed.');
//     }
//   }
// }
//
//
// ///
// ///
//
//
//  Future<bool> paymentByPaypal({required double amount,required String displayName})async{
//
//   try{
//     var request =   BraintreeDropInRequest(
//       tokenizationKey: '',
//       collectDeviceData: true,
//       paypalRequest: BraintreePayPalRequest(
//           amount:'$amount',
//           displayName: displayName,
//           /// AED
//           currencyCode:'CVE'
//       ),
//       cardEnabled: false,
//     );
//     BraintreeDropInResult? result =await BraintreeDropIn.start(request);
//
//     if(result != null){
//       print(result.paymentMethodNonce.description);
//       print(result.paymentMethodNonce.nonce);
//       final http.Response response = await http.post(Uri.parse(
//           '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}'
//       ));
//       final  payResult = jsonDecode(response.body);
//       if(payResult['result'] == 'success'){
//         print('payment done');
//       }
//
//       return true;
//     }else{
//       return false;
//     }
//   }catch(e){
//     return false;
//   }
//
//
//   }
//
// }
