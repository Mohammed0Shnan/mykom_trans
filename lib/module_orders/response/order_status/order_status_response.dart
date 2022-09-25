//
// import 'package:my_kom/module_orders/response/orders/orders_response.dart';
//

import 'package:my_kom/consts/order_status.dart';

class OrderStatusResponse {
  late String id;
  late int customerOrderID;
  late OrderStatus  status;
  late String payment;
  OrderStatusResponse(
      {
        required this.id,
        required this.status

      });

  // CreateOrderRequest.fromJson(Map<String, dynamic> json) {
  //   storeId = json['storeId'];
  //   destination = GeoJson.fromJson(json['destination']);
  //   phone = json['phone'];
  //   payment = json['payment'];
  //   date = json['date'];
  //   products = (json['products']).map((e) => null);
  // }

  OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    this.id = json['id']  ;
    this.payment = json['payment']  ;
    this.customerOrderID = json['customer_order_id'];
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
}




// class OrderStatusResponse {
//  late String statusCode;
//  late String msg;
//  late OrderDetailsData data;
//
//   OrderStatusResponse({required this.statusCode,required this.msg,required this.data});
//
//   OrderStatusResponse.fromJson(Map<String, dynamic> json) {
//     statusCode = json['status_code'];
//     msg = json['msg'];
//     data = (json['Data'] != null ? new OrderDetailsData.fromJson(json['Data']) : null)!;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status_code'] = this.statusCode;
//     data['msg'] = this.msg;
//     if (this.data != null) {
//       data['Data'] = this.data.toJson();
//     }
//     return data;
//   }
// }
//
// class OrderDetailsData {
//  late int id;
//  late String ownerID;
//  late List<String> source;
//  late GeoJson destination;
//  late Date date;
//  late Date updateDate;
//  late String note;
//  late String payment;
//  late String phone;
//  late String recipientName;
//  late String recipientPhone;
//  late String state;
//  late GeoJson fromBranch;
//  late GeoJson location;
//  late String brancheName;
//  late String branchCity;
//   late List<AcceptedOrder> acceptedOrder;
//   late List<dynamic> record;
//  late String uuid;
//
//   OrderDetailsData(
//       {
//        required this.id,
//       required  this.ownerID,
//        required this.source,
//        required this.destination,
//        required this.date,
//        required this.updateDate,
//        required this.note,
//        required this.payment,
//        required this.recipientName,
//       required  this.recipientPhone,
//        required this.state,
//       required  this.phone,
//       required  this.fromBranch,
//       required  this.location,
//       required  this.brancheName,
//        required this.branchCity,
//        required this.acceptedOrder,
//       required  this.record,
//       required  this.uuid});
//
//   OrderDetailsData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     ownerID = json['ownerID'];
//     source = json['source'].cast<String>();
//     // destination = GeoJson.fromJson(json['destination']);
//     date = (json['date'] != null ? new Date.fromJson(json['date']) : null)!;
//     updateDate = (json['updateDate'] != null
//         ? new Date.fromJson(json['updateDate'])
//         : null)!;
//     note = json['note'];
//     payment = json['payment'];
//     phone = json['phone'];
//     recipientName = json['recipientName'];
//     recipientPhone = json['recipientPhone'];
//     state = json['state'];
//     fromBranch = GeoJson.fromJson(json['fromBranch']);
//     location = GeoJson.fromJson(json['location']);
//     brancheName = json['brancheName'];
//     branchCity = json['branchCity'];
//     try {
//       if (json['acceptedOrder'] != null) {
//         if (json['acceptedOrder'] is List) {
//           List<Map<String, dynamic>> orders = json['accptedOrder'];
//           acceptedOrder = <AcceptedOrder>[];
//           orders.forEach((element) {
//             acceptedOrder.add(AcceptedOrder.fromJson(element));
//           });
//         }
//       }
//     } catch (e) {
//     }
//     record = json['record'];
//     uuid = json['uuid'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['ownerID'] = this.ownerID;
//     data['source'] = this.source;
//     data['destination'] = this.destination;
//     if (this.date != null) {
//       data['date'] = this.date.toJson();
//     }
//     if (this.updateDate != null) {
//       data['updateDate'] = this.updateDate.toJson();
//     }
//     data['note'] = this.note;
//     data['payment'] = this.payment;
//     data['recipientName'] = this.recipientName;
//     data['recipientPhone'] = this.recipientPhone;
//     data['state'] = this.state;
//     data['fromBranch'] = this.fromBranch;
//     data['location'] = this.location;
//     data['brancheName'] = this.brancheName;
//     data['branchCity'] = this.branchCity;
//     try {
//       data['acceptedOrder'] = this.acceptedOrder;
//     } catch (e) {
//     }
//     data['record'] = this.record;
//     data['uuid'] = this.uuid;
//     return data;
//   }
// }
//
// class Date {
//  late Timezone timezone;
//  late int offset;
//  late int timestamp;
//
//   Date({required this.timezone,required this.offset,required this.timestamp});
//
//   Date.fromJson(Map<String, dynamic> json) {
//     timezone = (json['timezone'] != null
//         ? new Timezone.fromJson(json['timezone'])
//         : null)!;
//     offset = json['offset'];
//     timestamp = json['timestamp'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.timezone != null) {
//       data['timezone'] = this.timezone.toJson();
//     }
//     data['offset'] = this.offset;
//     data['timestamp'] = this.timestamp;
//     return data;
//   }
// }
//
// class Timezone {
// late  String name;
//  late List<Transitions> transitions;
//  late Location location;
//
//   Timezone({required this.name,required this.transitions,required this.location});
//
//   Timezone.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     if (json['transitions'] != null) {
//       transitions = <Transitions>[];
//       json['transitions'].forEach((v) {
//         transitions.add(new Transitions.fromJson(v));
//       });
//     }
//     location = (json['location'] != null
//         ? new Location.fromJson(json['location'])
//         : null)!;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = this.name;
//     if (this.transitions != null) {
//       data['transitions'] = this.transitions.map((v) => v.toJson()).toList();
//     }
//     if (this.location != null) {
//       data['location'] = this.location.toJson();
//     }
//     return data;
//   }
// }
//
// class Transitions {
// late  int ts;
// late  String time;
//  late int offset;
//  late bool isdst;
// late  String abbr;
//
//   Transitions({required this.ts,required this.time,required this.offset,required this.isdst,required this.abbr});
//
//   Transitions.fromJson(Map<String, dynamic> json) {
//     ts = json['ts'];
//     time = json['time'];
//     offset = json['offset'];
//     isdst = json['isdst'];
//     abbr = json['abbr'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['ts'] = this.ts;
//     data['time'] = this.time;
//     data['offset'] = this.offset;
//     data['isdst'] = this.isdst;
//     data['abbr'] = this.abbr;
//     return data;
//   }
// }
//
// class Location {
//  late String countryCode;
//  late int latitude;
//  late int longitude;
//  late String comments;
//
//   Location({required this.countryCode,required this.latitude,required this.longitude,required this.comments});
//
//   Location.fromJson(Map<String, dynamic> json) {
//     countryCode = json['country_code'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     comments = json['comments'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['country_code'] = this.countryCode;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['comments'] = this.comments;
//     return data;
//   }
// }
//
//
// class AcceptedOrder {
// late  int id;
// late  String captainID;
//  late String state;
//  late String captainName;
//  late String car;
// late  String image;
//  late Null uuid;
//  late String phone;
//
//   AcceptedOrder(
//       {
//        required this.id,
//        required this.captainID,
//         required this.state,
//       required  this.captainName,
//        required this.car,
//       required  this.image,
//       required  this.uuid,
//        required this.phone});
//
//   AcceptedOrder.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     captainID = json['captainID'];
//     state = json['state'];
//     captainName = json['captainName'];
//     car = json['car'];
//     image = json['image'];
//     uuid = json['uuid'];
//     phone = json['phone'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['captainID'] = this.captainID;
//     data['state'] = this.state;
//     data['captainName'] = this.captainName;
//     data['car'] = this.car;
//     data['image'] = this.image;
//     data['uuid'] = this.uuid;
//     data['phone'] = this.phone;
//     return data;
//   }
// }