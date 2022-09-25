
import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel{
 static const ID = 'id';

 static const USER_ID = 'userId';
 static const MONTH = 'exp_month';
 static const YEAR = 'exp_year';
 static const LAST_FOUR = 'last4';

late String _id;
 late String _cardNumber;
 late String _userId;
 late int _month;
 late int _year;
 late int _last4;
 CardModel({required String id , required String cardNumber,required String  userID,
 required int  month,required int  year,required int  last4
 }){
  this._id = id;
  this._cardNumber = cardNumber;
  this._month = month;
  this._year = year;
   this._last4 = last4;
   this._userId = userID;
 }
//  getters
 String get id => _id;
 String get cardNumber => _cardNumber;
 String get userId => _userId;
 int get month => _month;
 int get year => _year;
 int get last4 => _last4;

 CardModel.fromSnapshot(DocumentSnapshot snapshot){
  Map map = snapshot.data() as Map;
  _id = map[ID];
  _userId = map[USER_ID];
  _month = map[MONTH];
  _year = map[YEAR];
  _last4 = map[LAST_FOUR];
  _cardNumber = map['card_number'];
 }

 CardModel.fromMap(Map data, {required String customerId}){
  _id = data[ID];
  _userId = data[USER_ID];
  _month = data[MONTH];
  _year = data[YEAR];
  _last4 = data[LAST_FOUR];
 }

 Map<String, dynamic> toMap(){
  return {
   ID: _id,
   USER_ID: _userId,
   MONTH: _month,
   YEAR: _year,
   LAST_FOUR: _last4
  };
 }

}