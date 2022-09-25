import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/module_profile/model/quick_location_model.dart';


class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferencesHelper _preferencesHelper =SharedPreferencesHelper();
  Future<MapData> getCurrentLocation() async {
        try {
          bool serviceEnabled;
          LocationPermission permission;
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            Future.error('Location services are disabled');
            throw('Location services are disabled');
          }

          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              Future.error('Location permissions are denied');
              throw('Location permissions are denied');

            }
          }

          if (permission == LocationPermission.deniedForever) {
            Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
            throw( 'Location permissions are permanently denied, we cannot request permissions.');

          }

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          LocationInformation s = await getPositionDetail(
              LatLng(position.latitude, position.longitude));

          return MapData(name: "${s.title!} ${s.subTitle!}",
              longitude: position.longitude,
              latitude: position.latitude,
              isError: false,
              message: 'success'
          );

        }catch(e){
          return MapData.error(e.toString());
        }


  }

  Future<bool> saveLocation(LatLng latLng ,String description) async {
    return true;
  }

  Future<LocationInformation> getPositionDetail(LatLng latLng) async {
   List<Placemark> placemarks = await placemarkFromCoordinates(
       latLng.latitude, latLng.longitude,
       localeIdentifier: 'en');
   LocationInformation address = _getDetailFromPlacemark(placemarks);
    return address;
  }

  Future<String> getSubArea(LatLng latLng)async{
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: UtilsConst.lang);

    Placemark place1 = placemarks[0];
    print(place1);
    String zone ='';
    if(place1.locality == ''){
      if(place1.subLocality ==''){
        if(place1.subAdministrativeArea ==''){
          zone = place1.administrativeArea!;
        }else{
          zone = place1.subAdministrativeArea!;
        }
      }else{
        zone = place1.subLocality!;
      }
    }else{
      zone=place1.locality!;
    }

    return zone;
  }



  LocationInformation _getDetailFromPlacemark(List<Placemark>? placemarks) {

    Placemark place1 = placemarks![0];
    //Placemark place2 = placemarks[1];
    LocationInformation _information = LocationInformation();
    _information.title ="${place1.name}";
    if(place1.street == ''){
 _information.subTitle = "${place1.name} ${place1.thoroughfare} ${place1.subLocality} ${place1.locality}";
    }
    else{
    _information.subTitle = '${place1.street}';
    }
    
        return _information;
  }


 Future<String?> getSubAreaPosition(LatLng? latLng)async {
   late String subArea ;
   try{
     if(latLng == null){
       MapData data =  await getCurrentLocation();
       subArea = await getSubArea(LatLng(data.latitude,data.longitude));
     }else{
       subArea = await getSubArea(latLng);
     }
     if(latLng == null)
     _preferencesHelper.setCurrentSubArea(subArea);

     return subArea;

   }catch(e){
     return null;
   }
  }

 Future<bool> checkAddressInArea(String storeId,String address) async{
   QuerySnapshot zone_response = await _firestore.collection('zones').where('store_id',isEqualTo: storeId).where('name',arrayContains: address).get();
   return zone_response.docs.length != 0;
  }

 Future<bool> saveQuickLocation(QuickLocationModel quickLocationModel) async{
    try{
      String? userId =await AuthPrefsHelper().getUserId();
      await _firestore.collection('users').doc(userId).collection('quick_locations').add(quickLocationModel.toJson());
      return true;
    }catch(e){
      print(e);
      return false;
    }

  }




}
