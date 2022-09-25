// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_kom/module_shoping/models/parcher_model.dart';
//
//
// class PurchaseServices{
//   static const USER_ID = 'userId';
//
//   String collection = "purchases";
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<bool> createPurchase({required String orderID,required double amount,required String userId,required String date,required String cardId })async{
//    try{
//     await _firestore.collection(collection).add({
//        "order":orderID,
//        "amount": amount,
//        "userId": userId,
//        "date":date,
//        "cardId":cardId
//      });
//      return true;
//    }catch(e){
//      return false;
//    }
//
//   }
//
//
//   Future<List<PurchaseModel>> getPurchaseHistory({required String userId})async =>
//       _firestore.collection(collection).where(USER_ID, isEqualTo: userId).get().then((result){
//         List<PurchaseModel> purchaseHistory = [];
//         print("=== RESULT SIZE ${result.docs.length}");
//         for(DocumentSnapshot item in result.docs){
//           purchaseHistory.add(PurchaseModel.fromSnapshot(item));
//           print(" CARDS ${purchaseHistory.length}");
//         }
//         return purchaseHistory;
//       });
//
//
//  // void updateDetails(Map<String, dynamic> values){
//  //   _firestore.collection(collection).document(values["id"]).updateData(values);
//  // }
//
//
// //  Future<UserModel> getPurchaseById(String id) =>
// //      _firestore.collection(collection).document(id).get().then((doc){
// //        return PurchaseModel.fromSnapshot(doc);
// //      });
// }