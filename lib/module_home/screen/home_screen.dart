import 'dart:async';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/bloc/check_zone_bloc.dart';
import 'package:my_kom/module_company/bloc/panar_bloc.dart';
import 'package:my_kom/module_company/bloc/recommended_product_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_home/models/advertisement_model.dart';
import 'package:my_kom/module_home/bloc/filter_zone_bloc.dart';
import 'package:my_kom/module_home/enums/advertisement_type.dart';
import 'package:my_kom/module_home/models/search_model.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/module_home/widgets/recommended_list_widget.dart';
import 'package:my_kom/module_home/widgets/recommended_shimmer_list.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeScreen extends StatefulWidget {
  final MapBloc mapBloc;

  final FilterZoneCubit filterZoneCubit;
  final AllCompanyBloc allCompanyBloc;
  final PanarBloc panarBloc;
  final RecommendedProductBloc recommendedBloc;
  final CheckZoneBloc checkZoneBloc;

  HomeScreen(
      {required this.mapBloc,
      required this.filterZoneCubit,
      required this.allCompanyBloc,
      required this.panarBloc,
      required this.checkZoneBloc,
      required this.recommendedBloc,
      Key? key})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final MapService mapService = MapService();
  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();

  @override
  void initState() {

    /// We don't need to call it until the first time because we're listening
    if (UtilsConst.isInit) {
      widget.mapBloc.getSubArea();
    }


    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      UtilsConst.isInit = true;
      _sharedPreferencesHelper.removeCurrentSubArea();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapStates>(
        bloc: widget.mapBloc,
        listener: (context, state) {
          if (state is MapSuccessState) {
            widget.checkZoneBloc.checkZone(state.data.subArea);
            UtilsConst.isInit = false;
            widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName: state.data.subArea));
          } else if (state is MapErrorState) {
            EasyLoading.dismiss();
          } else if (state is MapLoadingState) {
            EasyLoading.show(
              status: S.of(context)!.pleaseWait,
              maskType: EasyLoadingMaskType.black,
            );
          }
        },
        builder: (context, state) {
          if (state is MapSuccessState) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ),
                  elevation: 0,
                  leading: Builder(
                    builder: (context) {
                      return Container(
                        width: 10,
                        child:  Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.black,
                              ),
                        // child: IconButton(
                        //     icon: Icon(
                        //       Icons.notifications_active_outlined,
                        //       color: Colors.black,
                        //     ),
                        //     onPressed: () {
                        //       // Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationsScreen()));
                        //     }),
                      );
                    },
                  ),
                  backgroundColor: Colors.white,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MapRoutes.MAP_SCREEN, arguments: false)
                          .then((value) async {
                        if (value != null) {
                          AddressModel addressModel = (value as AddressModel);
                          widget.filterZoneCubit.setFilter(SearchModel(
                              storeId: '', zoneName: addressModel.subArea));
                          widget.checkZoneBloc.checkZone(addressModel.subArea);
                        }
                      });
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: Colors.black87,
                              ),
                              Text(
                                S.of(context)!.deliveryTo,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.black87,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          BlocBuilder<FilterZoneCubit, FilterZoneCubitState>(
                              bloc: widget.filterZoneCubit,
                              builder: (context, state) {
                                return Text(
                                  state.searchModel.zoneName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black54,
                                      fontSize: 16),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: CompanySearch(widget.allCompanyBloc));
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.black54,
                        ))
                  ],
                ),
                body: BlocConsumer<CheckZoneBloc, CheckZoneStates>(
                    bloc: widget.checkZoneBloc,
                    listener: (context, checkZoneState) async {
                      if (checkZoneState is CheckZoneSuccessState) {
                        /// Configure the shopping cart for the products of the specified store
                        shopCartBloc.startedShop();

                        /// Get Data From Apis
                        widget.panarBloc
                            .getAdvertisements(checkZoneState.storeId);
                        widget.allCompanyBloc
                            .getAllCompany(checkZoneState.storeId);
                        widget.recommendedBloc
                            .getRecommendedProducts(checkZoneState.storeId);

                        EasyLoading.dismiss();
                      } else if (checkZoneState is CheckZoneErrorState) {
                        EasyLoading.dismiss();
                        widget.allCompanyBloc.setInit();
                      }
                    },
                    builder: (context, checkZoneState) {
                      if (checkZoneState is CheckZoneSuccessState) {
                        return Material(
                          child: SafeArea(
                              top: true,
                              child: RefreshIndicator(
                                onRefresh: () =>
                                    _onRefresh(checkZoneState.storeId),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Advertisements Section
                                      ///
                                      Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: BlocBuilder<PanarBloc,
                                                  PanarStates>(
                                              bloc: widget.panarBloc,
                                              builder: (context, state) {
                                                if (state
                                                    is PanarSuccessState) {
                                                  List<AdvertisementModel>
                                                      advertisement =
                                                      state.data;
                                                  return PageViewWidget(
                                                      itemCount:
                                                          advertisement.length,
                                                      hieght: 160,
                                                      pageBuilder: (index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            AdvertisementModel
                                                                a =
                                                                advertisement[
                                                                    index];
                                                            List<String> route =
                                                                a.route
                                                                    .split('|');
                                                            if (route[0] ==
                                                                AdvertisementType
                                                                    .ADVERTISEMENT_PRODUCT
                                                                    .name) {
                                                              String productId =
                                                                  route[1];
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  CompanyRoutes
                                                                      .PRODUCTS_DETAIL_SCREEN,
                                                                  arguments:
                                                                      productId);
                                                            } else if (route[
                                                                    0] ==
                                                                AdvertisementType
                                                                    .ADVERTISEMENT_COMPANY
                                                                    .name) {
                                                              List<String>
                                                                  route_arrguments =
                                                                  route[1]
                                                                      .split(
                                                                          '&');
                                                              String companyId =
                                                                  route_arrguments[
                                                                      0];
                                                              String
                                                                  companyName =
                                                                  route_arrguments[
                                                                      1];
                                                              String
                                                                  companyImage =
                                                                  route_arrguments[
                                                                      2];
                                                              CompanyArgumentsRoute
                                                                  argumentsRoute =
                                                                  CompanyArgumentsRoute();
                                                              argumentsRoute
                                                                      .companyId =
                                                                  companyId
                                                                      .replaceAll(
                                                                          'id=',
                                                                          '');
                                                              argumentsRoute
                                                                      .companyName =
                                                                  companyName
                                                                      .replaceAll(
                                                                          'name=',
                                                                          '');
                                                              argumentsRoute
                                                                      .companyImage =
                                                                  companyImage
                                                                      .replaceAll(
                                                                          'image=',
                                                                          '');

                                                              Navigator.pushNamed(
                                                                  context,
                                                                  CompanyRoutes
                                                                      .COMPANY_PRODUCTS_SCREEN,
                                                                  arguments:
                                                                      argumentsRoute);
                                                            }
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            height: 160,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1),
                                                            ),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  advertisement[
                                                                          index]
                                                                      .imageUrl,
                                                              fadeInCurve: Curves
                                                                  .easeInOut,
                                                              progressIndicatorBuilder:
                                                                  (context, l,
                                                                          ll) =>
                                                                      Center(
                                                                child:
                                                                    Container(
                                                                  width: 50,
                                                                  height: 40,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: ll
                                                                        .progress,
                                                                    color: Colors
                                                                        .black12,
                                                                  ),
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (context, s,
                                                                          l) =>
                                                                      Icon(Icons
                                                                          .error),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                } else if (state
                                                    is PanarErrorState) {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(state.message),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              widget.panarBloc
                                                                  .getAdvertisements(
                                                                      checkZoneState
                                                                          .storeId);
                                                            },
                                                            child: Text(
                                                              S
                                                                  .of(context)!
                                                                  .refresh,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                            )),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (state
                                                    is PanarZoneErrorState) {
                                                  return Center(
                                                    child: Text(state.message),
                                                  );
                                                } else {
                                                  return Shimmer.fromColors(
                                                      baseColor: Colors
                                                          .grey.shade300
                                                          .withOpacity(0.8),
                                                      highlightColor:
                                                          Colors.grey.shade100,
                                                      enabled: true,
                                                      child: Center(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.white,
                                                          ),
                                                          height: 160,
                                                          width: SizeConfig
                                                                  .screenWidth *
                                                              0.9,
                                                        ),
                                                      ));
                                                }
                                              })),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      // /// Sections
                                      // Container(
                                      //   height: 115,
                                      //   width: double.infinity,
                                      //   color: Colors.white,
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     children: [
                                      //       Padding(
                                      //         padding: const EdgeInsets.symmetric(horizontal:8 ),
                                      //         child: Text('Sections',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black54),),
                                      //       ),
                                      //       SizedBox(height: 16,),
                                      //       Expanded(
                                      //         child: ListView(
                                      //           shrinkWrap: true,
                                      //           scrollDirection: Axis.horizontal,
                                      //           children: [
                                      //             InkWell(
                                      //
                                      //               onTap:(){
                                      //
                                      //       },hoverColor: Colors.black12,
                                      //               splashColor: Colors.black12,
                                      //               highlightColor: Colors.white,
                                      //               child: Container(
                                      //                 margin: EdgeInsets.symmetric(horizontal: 8),
                                      //                 child: Column(
                                      //                   crossAxisAlignment: CrossAxisAlignment.center,
                                      //                   children: [
                                      //                     // Container(
                                      //                     //   height: 25,
                                      //                     //   width: 25,
                                      //                     //   child: Image.asset('assets/app_icon.png'),
                                      //                     // ),
                                      //                     CircleAvatar(
                                      //                       radius: 25,
                                      //
                                      //                       backgroundColor: Colors.white,
                                      //                       backgroundImage: AssetImage(
                                      //                         'assets/water_section_icon.jpg'
                                      //                       ),
                                      //                     ),
                                      //                     SizedBox(height: 4,),
                                      //                     Text('Water' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black54),)
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Container(
                                      //               margin: EdgeInsets.symmetric(horizontal: 8),
                                      //               child: Column(
                                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                                      //                 children: [
                                      //                   CircleAvatar(
                                      //                     radius: 25,
                                      //                     backgroundColor: Colors.white,
                                      //                     backgroundImage: AssetImage(
                                      //                         'assets/frout_section_icon.jpg'
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(height: 4,),
                                      //                   Text('Frout' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black54),)
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //             Container(
                                      //               margin: EdgeInsets.symmetric(horizontal: 8),
                                      //               child: Column(
                                      //                 crossAxisAlignment: CrossAxisAlignment.center,
                                      //                 children: [
                                      //                   CircleAvatar(
                                      //                     radius: 25,
                                      //                     backgroundColor: Colors.white,
                                      //                     backgroundImage: AssetImage(
                                      //                         'assets/fish_section_icon.jpg'
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(height: 4,),
                                      //                   Text('Fish' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black54),)
                                      //                 ],
                                      //               ),
                                      //             )
                                      //           ],
                                      //         ),
                                      //         // child: ListView.builder(
                                      //         //   scrollDirection: Axis.horizontal,
                                      //         //   shrinkWrap: true,
                                      //         //     itemCount: 10,
                                      //         //     itemBuilder: (context,index){
                                      //         //   return Container(
                                      //         //     margin: EdgeInsets.symmetric(horizontal: 8),
                                      //         //     child: Column(
                                      //         //       crossAxisAlignment: CrossAxisAlignment.center,
                                      //         //       children: [
                                      //         //         CircleAvatar(
                                      //         //           radius: 25,
                                      //         //         ),
                                      //         //         SizedBox(height: 4,),
                                      //         //         Text('Water' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black54),)
                                      //         //       ],
                                      //         //     ),
                                      //         //   );
                                      //         // }),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      //
                                      /// Companies
                                      ///
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              S.of(context)!.companies,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                            // TextButton(
                                            //
                                            //   onPressed: () {
                                            //
                                            //   },
                                            //   child: Text(
                                            //     S.of(context)!.all,
                                            //     style: TextStyle(
                                            //         fontSize: 16,
                                            //         decoration: TextDecoration.underline,
                                            //         fontWeight: FontWeight.bold,
                                            //         color: Colors.blue),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      //
                                      BlocConsumer<AllCompanyBloc,
                                          AllCompanyStates>(
                                        bloc: widget.allCompanyBloc,
                                        listener: (context, state) {},
                                        builder: (context, state) {
                                          if (state is AllCompanySuccessState) {
                                            int itemLen = state.data.length;
                                            return Container(
                                              height: itemLen > 4 ? 225 : 125,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              width: SizeConfig.screenWidth,
                                              child: DescoveryGridWidget(
                                                data: state.data,
                                                // onRefresh: () {
                                                //  // _onRefresh(checkZoneState.storeId);
                                                // },
                                              ),
                                            );
                                          } else if (state
                                              is AllCompanyErrorState) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Container(
                                                    child: Text(state.message),
                                                  )),
                                                  IconButton(
                                                      onPressed: () {
                                                        widget.allCompanyBloc
                                                            .getAllCompany(
                                                                checkZoneState
                                                                    .storeId);
                                                      },
                                                      icon: Icon(Icons.refresh))
                                                ],
                                              ),
                                            );
                                          } else
                                            return Container(
                                                height: 125,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                width: SizeConfig.screenWidth,
                                                child:
                                                    ProductShimmerGridWidget());
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),

                                      /// Recommended Products Section
                                      ///
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          S.of(context)!.recommended,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        height: 210,
                                        width: SizeConfig.screenWidth,
                                        padding: EdgeInsets.only(
                                            bottom: 8.0, left: 8.0, right: 8.0),
                                        child: BlocBuilder<
                                                RecommendedProductBloc,
                                                RecommendedProductStates>(
                                            bloc: widget.recommendedBloc,
                                            builder: (context, state) {
                                              if (state
                                                  is RecommendedProductSuccessState) {
                                                return RecommendedListWidget(
                                                  data: state.data,
                                                );
                                              } else if (state
                                                  is RecommendedProductErrorState) {
                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: Container(
                                                        child:
                                                            Text(state.message),
                                                      )),
                                                      IconButton(
                                                          onPressed: () {
                                                            widget
                                                                .recommendedBloc
                                                                .getRecommendedProducts(
                                                                    checkZoneState
                                                                        .storeId);
                                                          },
                                                          icon: Icon(
                                                              Icons.refresh))
                                                    ],
                                                  ),
                                                );
                                              } else
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child:
                                                      RecommendedProductsShimmerWidget(),
                                                );
                                            }),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        );
                      } else if (checkZoneState is CheckZoneLoadingState) {
                        return SizedBox.shrink();
                      } else if (checkZoneState is CheckZoneErrorState) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.1,
                                ),
                                Container(
                                  width: SizeConfig.screenWidth * 0.7,
                                  child: Image.asset('assets/coming_soon.png'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.screenWidth * 0.1),
                                  child: Text(
                                    S.of(context)!.comingSoon,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        fontSize:18,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w800),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }));
          } else if (state is MapLoadingState) {
            return Scaffold();
          } else if (state is MapErrorState) {
            return Scaffold(
              body: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        child: Image.asset('assets/error.png'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        S.of(context)!.determineLocation,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontSize:18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black45),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        width: SizeConfig.screenWidth * 0.3,
                        color: ColorsConst.mainColor,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MapRoutes.MAP_SCREEN,
                                    arguments: false)
                                .then((value) {
                              if (value != null) {
                                AddressModel addressModel =
                                    (value as AddressModel);
                                widget.filterZoneCubit.setFilter(SearchModel(
                                    storeId: '',
                                    zoneName: addressModel.subArea));
                                widget.mapBloc
                                    .setLocationManually(addressModel.subArea);
                              }
                            });
                          },
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold();
          }
        });
  }

  Future<void> _onRefresh(String storeId) async {
    await widget.allCompanyBloc.getAllCompany(storeId);
  }
}

class CompanySearch extends SearchDelegate<SearchModel?> {
  late AllCompanyBloc _allCompanyBloc;

  CompanySearch(AllCompanyBloc bloc) {
    _allCompanyBloc = bloc;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {

    return ListTile(
      onTap: () {},
      title: Text(UtilsConst.lang == 'en' ?'Select Result From Suggestions':'الرجاء الاختيار من الاقتراحات'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<AllCompanyBloc, AllCompanyStates>(
        bloc: _allCompanyBloc,
        builder: (context, state) {
          if (state is AllCompanySuccessState) {
            List<CompanyModel> companies = state.data;
            companies.removeWhere((element) => element.isActive == false);
            List<CompanyModel> suggestionList = [];
            if (UtilsConst.lang == 'en')
              suggestionList = companies
                  .where((element) => element.name.toUpperCase().startsWith(query.toUpperCase()))
                  .toList();
            else
              suggestionList = companies
                  .where((element) => element.name2.toUpperCase().startsWith(query.toUpperCase()))
                  .toList();

            return ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.location_city),
                    onTap: () {
                      CompanyArgumentsRoute argumentsRoute =
                          CompanyArgumentsRoute();
                      argumentsRoute.companyId = suggestionList[index].id;
                      argumentsRoute.companyImage =
                          suggestionList[index].imageUrl;
                      argumentsRoute.companyName = suggestionList[index].name;
                      argumentsRoute.companyName2 = suggestionList[index].name2;
                      Navigator.pushNamed(
                          context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,
                          arguments: argumentsRoute);
                    },
                    title: RichText(
                      text: TextSpan(
                          text: (UtilsConst.lang == 'en')
                              ? suggestionList[index].name.substring(0, query.length)
                              : suggestionList[index]
                                  .name2
                                  .substring(0, query.length),
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          children: [
                            TextSpan(
                              text: (UtilsConst.lang == 'en')
                                  ? suggestionList[index]
                                      .name
                                      .substring(query.length,suggestionList[index]
                                  .name.length)
                                  : suggestionList[index]
                                      .name2
                                      .substring(query.length,suggestionList[index]
                                  .name2.length),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.5),
                            )
                          ]),
                    ),
                  );
                });
          } else {
            return Platform.isIOS?CupertinoActivityIndicator(): CircularProgressIndicator(
              color: ColorsConst.mainColor,
            );
          }
        });
  }
}
