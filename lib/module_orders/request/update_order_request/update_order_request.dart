class UpdateOrderRequest {
 late int id;
late  String state;
late  String distance;

  UpdateOrderRequest({
   required this.id,
   required this.state,
   required this.distance,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['state'] = this.state;
    data['kilometer'] = this.distance;
    return data;
  }
}
