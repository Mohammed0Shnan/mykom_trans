
import 'package:my_kom/utils/logger/logger.dart';

import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrdersListResponse {
  late String id;
  late String userId;
  late String storeId;
  late String addressName;
  late double orderValue;
  late String description;
  late String payment;
  late int  customerOrderID;
  OrdersListResponse(
      {
        required this.userId,
        required this.orderValue,
        required this.description,
        required this.addressName
      });

  // CreateOrderRequest.fromJson(Map<String, dynamic> json) {
  //   storeId = json['storeId'];
  //   destination = GeoJson.fromJson(json['destination']);
  //   phone = json['phone'];
  //   payment = json['payment'];
  //   date = json['date'];
  //   products = (json['products']).map((e) => null);
  // }

  OrdersListResponse.mainDetailsFromJson(Map<String, dynamic> data) {
    this.id = data['id']  ;
    this.description = data['description']  ;
    this.orderValue = data['order_value'];
    this.payment = data['payment'];
    this.addressName = data['address_name'] ;
    this.customerOrderID =data ['customer_order_id'] ;

  }
}


class GeoJson {
  late double lat;
  late double lon;

  GeoJson({required this.lat, required this.lon});

  GeoJson.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return;
    }
    else {
      this.lat = double.tryParse(data['lat'].toString())!;
      this.lon = double.tryParse(data['lon'].toString())!;
    }
    // if (data is List) {
    //   if (data.last is Map) {
    //     json = data.last;
    //   }
    //  else if (data is Map) {
    //     this.lat = double.tryParse(json['lat'].toString())!;
    //     this.lon = double.tryParse(json['lon'].toString())!;
    //   }
    // }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }

}



