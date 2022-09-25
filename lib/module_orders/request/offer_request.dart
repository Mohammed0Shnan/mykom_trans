
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OfferRequest {
  late String offer_id;
  late String userId;
  late String phone;
  late GeoJson destination;
  late String addressName;
  late double orderValue;
  late String payment;
  late String? cardId;
  OfferRequest(
      {
     required this.userId,
     required this.destination,
     required this.phone,
     required this.payment,
     required this.orderValue, required this.addressName, required this.cardId,

      });

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = this.userId;
    data['offer_id'] = this.offer_id;
    data['card_id'] = this.cardId==null ? null : this.cardId ;
    data['phone'] = this.phone;
    data['destination'] = this.destination.toJson();
    data['order_value'] = this.orderValue;
    data['payment'] = this.payment;
    data['address_name'] = this.addressName;

    return data;
  }
}

