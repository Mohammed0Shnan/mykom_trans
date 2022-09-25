class ProductModel {
  late final String id;
  late final String? companyId;
  late final String title;
  late final String title2;
  late final String description;
  late final String description2;
  late final double price;
  late final double? old_price;
  late final int quantity;
  late final imageUrl;
  late  int? orderQuantity;
  late bool  isRecommended;

  ProductModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.old_price,
      required this.imageUrl,
      required this.quantity,
        required this.isRecommended
      });

  ProductModel.fromJson(dynamic json) {
    Map<String ,dynamic> map = json as Map<String ,dynamic>;
    this.id = map['id'];
    this.companyId = map['company_id'];
    this.title = map['title'];
    this.title2 = map['title2']==null?'': map['title2'];
    this.description = map['description'];
    this.description2 = map['description2']==null?'':map['description2'];
    this.price = 1.0 * map['price'];
    this.old_price = map['old_price'] == null? null: 1.0 * map['old_price'];
    this.quantity = map['quantity'];
    this.orderQuantity = map['order_quantity'];
    this.imageUrl = map['imageUrl'];
    this.isRecommended = map['isRecommended']==null? false:true;
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['company_id'] = this.companyId;
    map['title'] = this.title;
    map['title2'] = this.title2;
    map['description'] = this.description;
    map['price'] = this.price;
    map['old_price'] = this.old_price;
    map['quantity'] = this.quantity;
    map['order_quantity'] = this.orderQuantity;
    map['imageUrl'] = this.imageUrl;
    map['isRecommended'] = this.isRecommended;
    return map;
  }
}

class SpecificationsModel {
  late final String name;
  late final String value;
  late final List<SpecificationsModel> specifications;
  SpecificationsModel(
      {required this.name,
        required this.value,

      });

  SpecificationsModel.fromJson(Map<String, dynamic> map) {
    this.name = map['name'];
    this.value = map['value'];

  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    map['value'] = this.value;

    return map;
  }
}

