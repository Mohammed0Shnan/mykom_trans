import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data' as types;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_localization/presistance/localization_preferences_helper.dart';
import 'package:my_kom/module_map/bloc/location_informatiion_loaded_cubit.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:my_kom/generated/l10n.dart';

import '../bloc/location_informatiion_loaded_cubit.dart';

class MapScreen extends StatefulWidget {
  final LocalizationPreferencesHelper _preferencesHelper =
  LocalizationPreferencesHelper();
   MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

const kGoogleApiKey = 'AIzaSyD2mHkT8_abpMD9LJl307Qhk7GHWuKqMJw';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _MapScreenState extends State<MapScreen> {
  late final MapBloc _mapBloc ;
  late final LocationInformationLoadCubit _informationLoadCubit;
   late GoogleMapController _controller ;

  final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(24.46515637636609, 54.351306818425655), zoom: 16.0);
  late final TextEditingController _searchController;
  bool? register= null;
  String language ='en';
  @override
  void initState() {
    _mapBloc = MapBloc();

    _informationLoadCubit = LocationInformationLoadCubit();
    _getMarker();
    widget._preferencesHelper.getLanguage().then((value) {
      if(value != null)
      language = value;
    });

    super.initState();
    _searchController = TextEditingController(text: '');
    _mapBloc.getCurrentPosition();
  }
  @override
  void dispose() {

    _informationLoadCubit.close();
    _controller.dispose();
    _searchController.dispose();
    if(!_mapBloc.isClosed)_mapBloc.close();
    super.dispose();
  }
 //  final Set<Marker> _markers = Set<Marker>();
 // // late GoogleMapController googleMapController;
  Map<String, dynamic>? location_from_search = null;

  /// Get Center Parameters
  Set<Circle> circleSets = {};
  LatLng? onCameraMoveEndLatLang;
  bool isPinMarkerVisible = false;
  types.Uint8List picUpMarker = types.Uint8List.fromList([]);
  final Mode _mode = Mode.overlay;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      register = ModalRoute.of(context)!.settings.arguments as bool;
     // setState((){});
    });
    return BlocConsumer<MapBloc, MapStates>(
      bloc: _mapBloc,
      listener: (context, state) async {
        if (state is MapSuccessState) {

          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
          _searchController.text = state.data.name;
          _mapBloc.getGesturePosition(latLng , '');
          // location_from_search = null;
           _move(latLng);
          // await getDetailFromLocation(latLng);
          // _informationLoadCubit.emitLoadedState();
        } else if (state is MapErrorState) {
          _informationLoadCubit.emitErrorState();
          showTopSnackBar(
            context,
            CustomSnackBar.error(
                icon: Icon(Icons.location_off_sharp),
                message: S.of(context)!.errorInGetCurrentLocation),
          );
        } else if (state is MapSuccessSavePositionState) {
          late AddressModel addressModel;
          if (location_from_search != null) {
            LatLng latLan = location_from_search!['po'] as LatLng;
            String n = location_from_search!['name'] as String;
            addressModel = AddressModel(
                description: n,
                latitude: latLan.latitude,
                longitude: latLan.longitude,
                geoData: {});
            String subArea = await _mapBloc.service
                .getSubArea(LatLng(latLan.latitude, latLan.longitude));
            addressModel.subArea = subArea;
          } else {
            addressModel = AddressModel(
                description: _searchController.text,
                latitude: state.latitude,
                longitude: state.longitude,
                geoData: {});
            String subArea = await _mapBloc.service
                .getSubArea(LatLng(state.latitude, state.longitude));
            addressModel.subArea = subArea;
          }

          ///for map error
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => Center(child: Container(
            height: 30,
            width: 30,
            child: (Platform.isIOS)?CupertinoActivityIndicator():CircularProgressIndicator(color: ColorsConst.mainColor,),
          ),)));
          await Future.delayed(Duration(seconds: 1));

          /// fetch data from map
          Navigator.of(context)..pop()..pop(addressModel);
          _mapBloc.close();
        } else if (state is MapGestureSuccessState) {
          location_from_search = null;
          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
         await  getDetailFromLocation(latLng);
          _informationLoadCubit.emitLoadedState();
          // mapBloc.service.getSubArea(latLng);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [

                  Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: GoogleMap(
                      // onTap: (v) {
                      //   print(v);
                      //   LatLng latLng = LatLng(v.latitude, v.longitude);
                      //   mapBloc.getGesturePosition(latLng, '');
                      // },
                     // minMaxZoomPreference: MinMaxZoomPreference(0 , 16),
                     // markers: _markers,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller =controller;
                      },
                     // circles: circleSets,
                      onCameraIdle: _getPinnedAddress,
                      onCameraMove: (position) async{
                        if(isPinMarkerVisible){
                          onCameraMoveEndLatLang =  await pickLocationOnMap(position);
                        }
                      },

                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: isPinMarkerVisible,
                    child: Image.memory(picUpMarker,height: 45,width: 45,alignment: Alignment.center,fit: BoxFit.cover,color: Colors.red,
                    frameBuilder: (context , child ,frame , wasSyncLoaded){
                      return Transform.translate(offset:  const Offset(0, -10) ,child: child,);
                    },
                    ),
                    ),
                  ),

                  // if (state is MapLoadingState)
                  //   Positioned.fill(
                  //     child: Container(
                  //       child: Center(
                  //         child: CupertinoActivityIndicator(
                  //           color: ColorsConst.mainColor,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _handlePressButton,
                              child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:Colors.black45,
                                            offset: Offset(0,1),
                                            blurRadius: 1,
                                           )
                                      ]),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: BlocBuilder<LocationInformationLoadCubit,LocationInformationLoadCubitState>(
                                          bloc: _informationLoadCubit,
                                          builder: (context,locationInfoState) {
                                            if(locationInfoState == LocationInformationLoadCubitState.LOADING)
                                              return CupertinoActivityIndicator();
                                            else if( locationInfoState == LocationInformationLoadCubitState.ERROR)
                                              return Icon(Icons.location_off , color: Colors.red,);
                                            return Icon(
                                              Icons.location_on,
                                              color: ColorsConst.mainColor,
                                            );
                                          }
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(4),
                                            alignment: Alignment.centerLeft,

                                            height: SizeConfig.heightMulti * 6,
                                            child: Text(
                                              _searchController.text == ''?
                                              'Search': _searchController.text
                                              ,
                                              style:_searchController.text == ''? GoogleFonts.lato(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)
                                              :GoogleFonts.lato(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(
                                        Icons.search,
                                        ),
                                      ),
                                    ],
                                  )
                                  ),
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsConst.mainColor,
                        elevation: 10,
                        child: Container(
                          height: 35.0,
                          child: TextButton(

                            onPressed: () {
                              if (location_from_search != null) {
                                LatLng latLan =
                                    location_from_search!['po'] as LatLng;
                                String n =
                                    location_from_search!['name'] as String;

                              _mapBloc.saveLocation(latLan, n);
                              } else {
                                if (state is MapGestureSuccessState) {
                                  LatLng latLng = LatLng(state.data.latitude,
                                      state.data.longitude);
                                  _mapBloc.saveLocation(latLng, state.data.name);
                                } else {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.info(
                                      backgroundColor: ColorsConst.mainColor,
                                      icon: Icon(Icons.location_on),
                                      message: S.of(context)!.selectAndSave,
                                    ),
                                    displayDuration: Duration(seconds: 1),
                                  );
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                register == null
                                    ? ''
                                    : register!
                                        ? S.of(context)!.mapSave
                                        : S.of(context)!.mapDelivery,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.1),
              child: FloatingActionButton(
                onPressed: () {
                  _mapBloc.getCurrentPosition();
                },
                child: Icon(Icons.my_location),
              ),
            ));
      },
    );
  }

  getDetailFromLocation(LatLng latLng) async {
    LocationInformation _currentAddress =
        await _mapBloc.service.getPositionDetail(latLng);
    // Marker marker = Marker(
    //     markerId: MarkerId('_current_position'),
    //     infoWindow: InfoWindow(
    //       title: _currentAddress.title,
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //     position: latLng);
    _searchController.text = "${_currentAddress.subTitle}";
    // _setMarker(marker);
  }
  //
  Future<void> _move(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16.0);
    final GoogleMapController controller = _controller; // await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // _setMarker(Marker marker) {
  //   _markers.clear();
  //   _markers.add(marker);
  //   setState(() {});
  // }

  /// search

  Future<void> _handlePressButton() async {

    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        radius: 5,
        language: language,
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "ae")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    _searchController.text = detail.result.name;

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    location_from_search = {'po': LatLng(lat, lng), 'name': detail.result.name};
    // _setMarker(Marker(
    //     markerId: const MarkerId("0"),
    //     position: LatLng(lat, lng),
    //     infoWindow: InfoWindow(title: detail.result.name)));

    final GoogleMapController controller =  _controller; // await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng),16.0));
  }



 Future<LatLng> pickLocationOnMap(CameraPosition _onCameraMovePosition) async {
    LatLng onCameraMovePosition = _onCameraMovePosition.target;
    // Circle pinCircle = Circle(circleId: const CircleId('0',
    // ),
    // radius: 1,
    //   zIndex: 1,
    //   strokeColor: Colors.black54,
    //   center: onCameraMovePosition,
    //   fillColor: Colors.blue.withOpacity(0.7),
    //
    // );
    //circleSets.add(pinCircle);
    return onCameraMovePosition;
  }

  Future<void> _getPinnedAddress()async{
    _informationLoadCubit.emitLoadingState();
   await  _mapBloc.getGesturePosition(onCameraMoveEndLatLang!, '');

  }
  //Future<types.Uint8List>
  _getMarker() async{
   types.ByteData byteData = await DefaultAssetBundle.of(context).load('assets/icons/address_delivery_icon.png');
   picUpMarker = byteData.buffer.asUint8List();
   isPinMarkerVisible = true;
   setState((){});
  /// return byteData.buffer.asUint8List();
  }
}

