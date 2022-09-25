

class AdvertisementModel{
  late String id;
  late String title;
  late String body;
  late String storeID;
  late String imageUrl;
  late String route;
  AdvertisementModel({required this.id ,required this.title,required this.body, required this.imageUrl,required this.route,required this.storeID});

  AdvertisementModel.fromJson(Map<String, dynamic> data){
    print('******************* from json ***********');
    print(data);
    this.id = data['id'];
    this.imageUrl= data['image_url'];
    this.storeID= data['storeID'];
    this.title= data['title'];
    this.body= data['body'];
    this.route= data['route'];
  }
}