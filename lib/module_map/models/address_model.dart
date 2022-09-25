class AddressModel{
 late final double latitude, longitude;
 late final String description;

 late String subArea;
late  final Map<String , dynamic> geoData;
 AddressModel({required this.description , required this.latitude , required this.longitude , required this.geoData});
 Map<String, dynamic> toJson(){
  Map<String , dynamic> map = Map<String,dynamic>();
  map['name'] = this.description;
  map['position'] = {
   'latitude': this.latitude,
   'longitude':this.longitude
  };
  map['geoData']=this.geoData;
  return map;
 }

 AddressModel.fromJson(Map<String , dynamic> map){
  this.latitude = map['position']['latitude'];
  this.longitude = map['position']['longitude'];
  this.description = map['name'];
  this.geoData = map['geoData'];

 }


}

class LocationInformation{
  late String? title;
  late String? subTitle;
  LocationInformation();
}