
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class CreateOrderRequest {
  late String userId;
  late String storeId;
  late List<ProductModel> products;
  late String deliveryTime;
  late int numberOfMonth;
  late String startDate;
  late String phone;
  late GeoJson destination;
  late String addressName;
  late double orderValue;
  late String description;
  late String payment;
  late String status;
  late String? cardId;
  late int customerOrderID ;
  late bool vipOrder ;
  late String note ;
  late String? orderSource;
  late List<String> productsIdes;

  CreateOrderRequest(
      {
     required this.userId,
        required this.storeId,
     required this.destination,
     required this.phone,
     required this.payment,
     required this.products,
  required this.numberOfMonth,
  required this.deliveryTime,
  required this.orderValue,
  required this.startDate,
        required this.description,
        required this.addressName,
        required this.cardId,
        required this.customerOrderID
        ,required this.productsIdes,
        required this.vipOrder,
        required this.note,
        required this.orderSource
      });

  // CreateOrderRequest.fromJson(Map<String, dynamic> json) {
  //   storeId = json['storeId'];
  //   destination = GeoJson.fromJson(json['destination']);
  //   phone = json['phone'];
  //   payment = json['payment'];
  //   date = json['date'];
  //   products = (json['products']).map((e) => null);
  // }

  Map<String, dynamic> mainDetailsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userId'] = this.userId;
    data['vip_order'] = this.vipOrder;
     data['store_Id'] = this.storeId;
    data['status'] = this.status;
    data['payment'] = this.payment;
    data['description'] = this.description;
    data['order_value'] = this.orderValue;
    data['address_name'] = this.addressName;
    data['customer_order_id'] =this.customerOrderID;
    data['start_date'] = this.startDate;
    data['products_ides'] = this.productsIdes;
    data['order_source'] = this.orderSource;
    return data;
  }

  Map<String, dynamic> moreDetailsToJson() {

    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = this.userId;
    data['vip_order'] = this.vipOrder;
    data['card_id'] = this.cardId==null ? null : this.cardId ;
    data['products_ides'] = this.productsIdes;
    data['customer_order_id'] =this.customerOrderID;
     data['store_Id'] = this.storeId;
    data['products'] = this.products.map((e) =>e.toJson()).toList();
    data['delivery_time'] = this.deliveryTime;
    data['number_of_month'] = this.numberOfMonth;
    data['start_date'] = this.startDate;
    data['customer_order_id'] = this.customerOrderID;
    data['phone'] = this.phone;

    data['destination'] = this.destination.toJson();
    data['order_value'] = this.orderValue;
    data['payment'] = this.payment;
    data['address_name'] = this.addressName;
    data['description'] = this.description;
    data['note'] = this.note;
    data['order_source'] = this.orderSource;


    return data;
  }
}

