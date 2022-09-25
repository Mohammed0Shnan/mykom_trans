

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_map/service/map_service.dart';

class MapBloc extends Bloc<MapEvents, MapStates> {
  final MapService service = MapService();
  MapBloc() : super(MapInitState()) {
    on<MapEvents>((MapEvents event, Emitter<MapStates> emit) {
      if (event is MapLoadingEvent)
        emit(MapLoadingState());
      else if (event is MapSuccessEvent) emit(MapSuccessState(event.data,event.isRefresh));
      else if (event is MapGestureSuccessEvent) emit(MapGestureSuccessState(event.data));

      else if (event is MapErrorEvent) emit(MapErrorState(error_message: event.error_message));

      else if(event is MapSuccessSavePositionEvent){
        emit(MapSuccessSavePositionState(message: event.message,
        latitude: event.latitude,longitude: event.longitude
        ));
      }else {
        emit(MapInitState());
      }
    });
  }

  Future<void> getCurrentPosition() async {

    this.add(MapLoadingEvent());
    service.getCurrentLocation().then((value) {
      if(value.isError)
        this.add(MapErrorEvent(error_message: value.message.toString()));
      else
        this.add(MapSuccessEvent(value,false));
    });
  }

  getSubArea(){
    this.add(MapLoadingEvent());
    service.getSubAreaPosition(null).then((value) {
      if(value == null)
        this.add(MapErrorEvent(error_message: 'Error Get Current Location '));
      else{
        MapData map =  MapData(latitude: 0.0, longitude: 0.0, name:'', message: '', isError: false);
      map.subArea = value;
        this.add(MapSuccessEvent(map,false));
      }
    });
  }

  setLocationManually(String subArea){
    MapData map =  MapData(latitude: 0.0, longitude: 0.0, name:'', message: '', isError: false);
    map.subArea = subArea;
    this.add(MapSuccessEvent(map,false));
  }

  Future<void> getGesturePosition(LatLng latLng ,String description) async {
    this.add(MapGestureSuccessEvent(MapData(latitude: latLng.latitude,longitude: latLng.longitude,name:description,message: 'success',isError: false)));
  }

 //  Future<void> savePosition(Position position , String description)async{
 // this.add(MapLoadingEvent());
 //    _service.saveLocation(position,description).then((value) {
 //      if(value == null){
 //      this.add(MapErrorEvent());
 //      }else{
 //        this.add(MapSuccessSavePositionEvent());
 //      }
 //    });
 //  }

  Future<void> saveLocation(LatLng latLng, String description) async {
        this.add(MapSuccessSavePositionEvent(message: "Your address has been saved !" , latitude: latLng.latitude,longitude: latLng.longitude));

    // _service.saveLocation(latLng,description).then((value) {
    //   if(value == true)
    //     this.add(MapSuccessSavePositionEvent(message: "Your address has been saved !" , latitude: latLng.latitude,longitude: latLng.longitude));
    // else
    //     this.add(MapErrorEvent(error_message: 'error in save location !'));


    // });
  }

  void refresh(String subArea) {
    MapData newState = MapData(latitude: 0.0, longitude: 0.0, name: '', message:'', isError:false);
    newState.subArea = subArea;
    this.add(MapSuccessEvent(newState,true));
  }
  void init() {

    add(MapInitEvent());
  }
}

abstract class MapEvents {}

class MapInitEvent extends MapEvents {}

class MapSuccessEvent extends MapEvents {
  MapData data;
  bool  isRefresh;

  MapSuccessEvent(this.data,this.isRefresh);
}
class MapGestureSuccessEvent extends MapEvents {
  MapData data;
  MapGestureSuccessEvent(this.data);
}

class MapLoadingEvent extends MapEvents {}

class MapErrorEvent extends MapEvents {
  final String error_message;
  MapErrorEvent({required this.error_message});
}
class MapSuccessSavePositionEvent extends MapEvents {
  double latitude,longitude;
  String message;
  MapSuccessSavePositionEvent({required this.message,required this.latitude , required this.longitude});
}

abstract class MapStates {}

class MapInitState extends MapStates {}

class MapSuccessState extends MapStates {
  MapData data;
  bool  isRefresh;
  MapSuccessState(this.data,this.isRefresh);
}
class MapGestureSuccessState extends MapStates {
  MapData data;  MapGestureSuccessState(this.data);
}

class MapLoadingState extends MapStates {}
class MapSuccessSavePositionState extends MapStates {
  double latitude,longitude;
  String message;
  MapSuccessSavePositionState({required this.message,required this.latitude , required this.longitude});
}
class MapErrorState extends MapStates {
  final String error_message;
  MapErrorState({required this.error_message});
}

class MapData{
  late double longitude,latitude;
 late String name;
 late String subTitle;
 late String subArea;
 late String? message ;
 late bool isError;
  MapData({required this.latitude ,required this.longitude ,required this.name,required this.message,required this.isError});
  MapData.error(String error_message){
    this.latitude = 0.0;
    this.longitude = 0.0;
    this.name ='';
    this.isError = true;
    this.message = error_message;

  }

}

MapBloc mapBloc = MapBloc();
