

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderModel {
 late String id;
 late int customerOrderID;
 late String userId;
 late String storeId;
 late List<ProductModel> products;
 late String deliveryTime;
 late int numberOfMonth;
 late DateTime? startDate;
 late String phone;
 late String buildingHomeId;
 late GeoJson destination;
 late String addressName;
 late double orderValue;
 late String description;
 late String ar_description;
 late String payment;
 late OrderStatus status;
 late String? cardId;
 late bool vipOrder;
 late String note;
 late String? orderSource;
 late List<String> productIds;
 // late GeoJson to;
 // late String addressName;
 // late LatLng toOnMap;
 // late String from;
 // late  DateTime creationTime;
 // late  String paymentMethod;
 // late  OrderStatus status;
 // late  String ownerPhone;
 // late String captainPhone;
 // late String clientPhone;
 // late String chatRoomId;
 // late  String storeName;
 // late  String distance;

 //



 OrderModel();
  OrderModel.mainDetailsFromJson(Map<String, dynamic> json) {


   this.id = json['id'];
   this.addressName = json['address_name'];
   this.description = json['description'];
   this.ar_description = json['ar_description']==null? json['description'] :  json['ar_description'];
   this.orderValue = json['order_value'];
   this.payment = json['payment'];
   this.customerOrderID =json['customer_order_id'];
   this.vipOrder =json['vip_order'];
   this.orderSource =json['order_source'];
   //this.startDate = json['start_date']==null?null:DateTime.parse(json['start_date']);


   // List<ProductModel> productFromResponse = [];
   // json['products'].forEach((v) {
   //  productFromResponse.add(ProductModel.fromJson(v));
   // });
   // this.products = productFromResponse;

   OrderStatus state = OrderStatus.INIT;
   if(json['status'] == OrderStatus.IN_STORE.name){
    state = OrderStatus.IN_STORE;
   }
   else if(json['status'] == OrderStatus.DELIVERING.name){
    state = OrderStatus.DELIVERING;
   }
   else if(json['status'] == OrderStatus.FINISHED.name){
    state = OrderStatus.FINISHED;
   }
   else if(json['status'] == OrderStatus.GOT_CAPTAIN.name){
    state = OrderStatus.GOT_CAPTAIN;
   }
   else if(json['status'] == OrderStatus.GOT_CASH.name){
    state = OrderStatus.GOT_CASH;
   }
   else
   {
    state = OrderStatus.INIT;
   }
   this.status = state;
  }


 // OrderModel.formJson(Map<String, dynamic> json) {
 //
 //  this.id = json['id'];
 //  this.addressName = json['address_name'];
 //  this.description = json['description'];
 //  this.orderValue = json['order_value'];
 // }


}

class NotificationModel {
 late String id;
 late String title;
 late int offerId;
 late String storeId;
 late List<String> imageUrl;
 late DateTime? startDate;
 late String description;
 late double price;

 NotificationModel.fromJson(Map<String, dynamic> not) {
   this.id = not['id'];
   this.storeId = not['storeId'];
   List<String> images = [];
   not['imageUrl'].forEach((v) {
    images.add(v);
   });
   this.imageUrl = images;
   this.startDate = not['startDate'].toDate();
   this.price = not['price']* 1.0;
   this.description = not['description'];
   this.offerId = not['offer_id'];
   this.title = not['title'];
  }
}

