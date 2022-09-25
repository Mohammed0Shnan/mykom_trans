
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/repository/order_repository/order_repository.dart';
import 'package:my_kom/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:my_kom/module_orders/request/order/order_request.dart';
import 'package:my_kom/module_orders/request/update_order_request/update_order_request.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom/module_orders/response/order_status/order_status_response.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/utils/status_helper/status_helper.dart';
import 'package:my_kom/module_shoping/service/payment_service.dart';
import 'package:my_kom/module_shoping/service/purchers_service.dart';
import 'package:my_kom/module_shoping/service/stripe.dart';
import 'package:rxdart/rxdart.dart';

class OrdersService {
  //final ProfileService _profileService;
  final  OrderRepository _orderRepository = OrderRepository();
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();
  final StripeServices _stripeServices = StripeServices();
 final  PurchaseServices _purchaseServices = PurchaseServices();

  final PublishSubject<Map<String,List<OrderModel>>?> orderPublishSubject =
  new PublishSubject();

  final PublishSubject<List<NotificationModel>?> notificationsPublishSubject =
  new PublishSubject();


  Future<void> getMyOrders() async {
    String? uid = await _authPrefsHelper.getUserId();
      _orderRepository.getMyOrders(uid!).listen((event) {
        Map<String,List<OrderModel>> orderList = {};
        List<OrderModel> cur =[];
        List<OrderModel> pre =[];
        event.docs.forEach((element2) {
          Map <String, dynamic> order = element2.data() as Map<String,
              dynamic>;
          order['id'] = element2.id;
          OrderModel orderModel = OrderModel.mainDetailsFromJson(order);
          if (orderModel.status == OrderStatus.FINISHED) {
            pre.add(orderModel);
          }
          else {
            cur.add(orderModel);
          }
        }
        );
        orderList['cur']= cur.reversed.toList();
        orderList['pre']= pre.reversed.toList();

        orderPublishSubject.add(orderList);

      }).onError((e){
        orderPublishSubject.add(null);
      });

  }




  Future<OrderModel?> getOrderDetails(String orderId) async {
    try{
    OrderDetailResponse? response =   await _orderRepository.getOrderDetails(orderId);

    if(response ==null)
      return null;
    OrderModel orderModel = OrderModel() ;
     orderModel.id = response.id;
     orderModel.storeId = response.storeId;
    orderModel.vipOrder = response.vipOrder;
    orderModel.products = response.products;
    orderModel.payment = response.payment;
    orderModel.orderValue = response.orderValue;
    orderModel.description = response.description;
    orderModel.addressName = response.addressName;
    orderModel.destination = response.destination;
    orderModel.phone = response.phone;
    orderModel.startDate =DateTime.parse(response.startDate);//DateTime.parse(response.startDate) ;
    orderModel.numberOfMonth = response.numberOfMonth;
    orderModel.deliveryTime = response.deliveryTime;
    orderModel.cardId = response.cardId;
    orderModel.status = response.status;
    orderModel.customerOrderID = response.customerOrderID;
    orderModel.productIds = response.products_ides;
    orderModel.note = response.note;
    orderModel.orderSource = response.orderSource;
    return orderModel;
    }catch(e){
      return null;
    }
  }

  Future<OrderModel?> getTrackingDetails(String orderId) async {
    try{
      OrderStatusResponse? response =   await _orderRepository.getTrackingDetails(orderId);

      if(response ==null)
        return null;
      OrderModel orderModel = OrderModel() ;
      orderModel.id = response.id;
      orderModel.customerOrderID = response.customerOrderID;
      orderModel.status = response.status;
      orderModel.payment = response.payment;
      return orderModel;
    }catch(e){
      return null;
    }
  }

  Future<OrderModel?> addNewOrder(
      {required List<ProductModel>  products ,required String storeId,required String addressName, required String deliveryTimes,
        required bool orderType , required GeoJson destination, required String phoneNumber,required String paymentMethod,
        required  double amount , required String? cardId,required int numberOfMonth,required bool reorder,String? description
        ,required int? customerOrderID,required List<String>? productsIds,
        required String note,
        required String? orderSource

      }
      ) async {

    String? uId = await _authPrefsHelper.getUserId();
    String? customername = await _authPrefsHelper.getUsername();
    DateTime date = DateTime.now();
    // if(paymentMethod == PaymentMethodConst.CREDIT_CARD){
    //  bool paymentResult =  await PaymentService().paymentByPaypal(amount: amount, displayName: customername!);
    //
    //  /// An error occurred in the payment process
    //  /// Throw Exception
    //  if(!paymentResult){
    //    throw Exception();
    //  }
    // }

    late CreateOrderRequest orderRequest;

    /// generate sequence id;
    ///

    int? customer_order_id = await _orderRepository.generateOrderID();

    if(!reorder){
      Map<ProductModel,int> productsMap = Map<ProductModel,int>();
      products.forEach((element) {
        if(!productsMap.containsKey(element)){
          productsMap[element]= 1;
        }
        else{
          productsMap[element] = productsMap[element]! + 1;
        }
      });

      List<ProductModel> newproducts = [];
      String description = '';
      List<String> products_ides = [];

      productsMap.forEach((key, value) {
       key.orderQuantity = value;

        description = description + key.orderQuantity.toString() + ' '+ key.title + ' + ';
        newproducts.add(key);
        products_ides.add(key.id);
      });

       if(customer_order_id== null)
         throw Exception();

       orderRequest = CreateOrderRequest(
          userId: uId!,
           storeId: storeId,
           vipOrder: orderType,
           destination: destination,
          phone: phoneNumber,
          payment: paymentMethod,
          products: newproducts,
          numberOfMonth: numberOfMonth,
          deliveryTime: deliveryTimes,
          orderValue: amount,
          startDate:date.toIso8601String(),// DateFormat('yyyy-MM-dd HH-mm').format(date)  ,
          description:description.substring(0 , description.length-2),
          addressName :addressName,
          cardId:cardId,
         customerOrderID:customer_order_id,
         productsIdes: products_ides,
         note: note,
         orderSource: orderSource

      );
      orderRequest.status = OrderStatus.INIT.name;
    }
    else{

      if(customer_order_id== null)
        throw Exception();

      orderRequest = CreateOrderRequest(
          userId: uId!,
          storeId: storeId,
          vipOrder: orderType,
          destination: destination,
          phone: phoneNumber,
          payment: paymentMethod,
          products: products,
          numberOfMonth: numberOfMonth,
          deliveryTime: deliveryTimes,
          orderValue: amount,
          startDate:date.toIso8601String(),// DateFormat('yyyy-MM-dd HH-mm').format(date),
          description:description!,
          addressName :addressName,
          cardId:cardId,
        customerOrderID:customer_order_id ,
        productsIdes: productsIds!,
        note: note,
          orderSource: orderSource

      );
      orderRequest.status = OrderStatus.INIT.name;
    }

    DocumentSnapshot orderSnapShot =await _orderRepository.addNewOrder(orderRequest);

    // bool purchaseResponse =  await _purchaseServices.createPurchase(amount: amount, cardId: cardId, userId: uId, orderID: orderSnapShot.id, date: DateTime.now().toIso8601String());
    // if(!purchaseResponse){
    //   throw Exception();
    // }

     await createpurchase(amount: amount, cardId: cardId!, userId: uId, orderID: orderSnapShot.id, date: DateTime.now());
    Map<String ,dynamic> map = orderSnapShot.data() as Map<String ,dynamic>;
    map['id'] = orderSnapShot.id;

    return OrderModel.mainDetailsFromJson(map);
  }

 Future<bool> createpurchase(
     {required double amount,required String cardId,required String userId,required String orderID,required DateTime date})async{
   bool purchaseResponse =  await _purchaseServices.createPurchase(amount: amount, cardId: cardId, userId: userId, orderID: orderID, date: DateTime.now().toIso8601String());
   if(!purchaseResponse){
     throw Exception();
   }
   return true;
  }

  closeStream(){
    orderPublishSubject.close();
  }

  Future<bool> deleteOrder(String orderId)async{
      bool response = await  _orderRepository.deleteOrder(orderId);
      if(response){
        return true;
      }else{
        return false;
      }
  }

 Future<OrderModel?> reorder(String orderID)async {
    OrderModel? order =  await getOrderDetails(orderID);

    if(order == null){

      return null;
    }
    else{

      OrderModel? neworder = await addNewOrder(orderSource: order.orderSource, note: order.note, storeId:order.storeId,productsIds: order.productIds,customerOrderID:order.customerOrderID,products: order.products, addressName: order.addressName, deliveryTimes: order.deliveryTime, orderType: order.vipOrder, destination: order.destination, phoneNumber: order.phone, paymentMethod: order.payment, amount: order.orderValue, cardId: order.cardId, numberOfMonth: order.numberOfMonth,
      reorder: true,
        description: order.description
      );

      if(neworder !=null)
     return neworder;
         else
      return null;
    }


 }


  Future<void> getNotifications()async {
    String? uid = await _authPrefsHelper.getUserId();
    _orderRepository.getNotifications(uid!).listen((event) {
     List<NotificationModel> notifications = [];
      event.docs.forEach((element2) {
        Map <String, dynamic> not = element2.data() as Map<String,
            dynamic>;
        // if(order['userId'] == uid) {
        //
        // }



        not['id'] = element2.id;

        NotificationModel  notificationModel = NotificationModel.fromJson(not);
        notifications.add(notificationModel);
      }
      );


     notificationsPublishSubject.add(notifications);

    }).onError((e){
      notificationsPublishSubject.add(null);
    });
  }

  Future<OrderModel?>  addNewOffer()async {}


}

