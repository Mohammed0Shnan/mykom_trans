

class ProductCompanyStoreResponse{
  late String id;
  late String name;
  late String imageUrl;
  late String description;

  ProductCompanyStoreResponse();

  ProductCompanyStoreResponse.fromJsom(Map<String, dynamic> data){
    this.id= data['id'];
    this.name= data['name'];
    this.imageUrl= data['imageUrl'];
    this.description= data['description'];

  }

}