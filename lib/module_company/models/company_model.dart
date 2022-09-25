import 'package:my_kom/module_company/models/product_model.dart';

class CompanyModel {
  late final String id;
  late final String storeId;
  late final String name;
  late final String name2;
  late String description;
  late String imageUrl;
  late List<ProductModel> products;
  late bool isActive;
  CompanyModel({required this.id, required this.name, required this.imageUrl,required this.description});

  CompanyModel.fromJson(Map<String, dynamic> map) {

    this.id = map['id'];
    this.name = map['name'];
    this.name2 = map['name2']==null?'':map['name2'];
    this.imageUrl = map['imageUrl'];
    this.description = map['description'];
    this.storeId = map['store_id'];
    this.isActive = map['is_active'];
    if( map['products'] != null){
      List<ProductModel> productFromResponse = [];
      map['products'].forEach((v) {
        productFromResponse.add(ProductModel.fromJson(v));
      });
      this.products = productFromResponse;

    }else{
      this.products =[];

    }

  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['name'] = this.name;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    map['products'] = this.products.map((e) =>e.toJson()).toList();


    return map;
  }
}
