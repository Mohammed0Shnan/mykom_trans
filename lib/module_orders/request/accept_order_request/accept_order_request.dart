class updateOrderRequest {
  late String orderID;
  late String state;
 // late String duration;

  updateOrderRequest({required this.orderID,required this.state});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   data['status'] = this.state;
    return data;
  }
}
