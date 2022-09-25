import 'dart:async';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/bloc/check_zone_bloc.dart';
import 'package:my_kom/module_company/bloc/recomended_products_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_home/models/advertisement_model.dart';
import 'package:my_kom/module_home/bloc/filter_zone_bloc.dart';
import 'package:my_kom/module_home/enums/advertisement_type.dart';
import 'package:my_kom/module_home/models/search_model.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
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
   bool isInit;
   final MapBloc mapBloc ;
   final FilterZoneCubit filterZoneCubit;
   final AllCompanyBloc allCompanyBloc;
   final RecommendedProductsCompanyBloc recommendedProductsCompanyBloc;
   final CheckZoneBloc checkZoneBloc;
  HomeScreen({required this.mapBloc,required this.filterZoneCubit,
    required  this.allCompanyBloc,
    required this.recommendedProductsCompanyBloc,
    required this.checkZoneBloc,
    required this.isInit,
    Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
final MapService mapService = MapService();
final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
@override
  void initState() {
    _sharedPreferencesHelper.getCurrentSubArea().then((value) {
      if(value == null ){
        widget.mapBloc.getSubArea();
      }
      else{
        widget.mapBloc.refresh(value);
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive){
      _sharedPreferencesHelper.removeCurrentSubArea();
    }
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<MapBloc,MapStates>(
      bloc:  widget.mapBloc,
      listener: (context , state){
        if(state is MapSuccessState){

           if(state.isRefresh){
            if(widget.isInit){
              widget.isInit = !widget.isInit;
              widget.checkZoneBloc.checkZone(state.data.subArea);
            }else{
              EasyLoading.dismiss();
            }
          }
          else{
            widget.checkZoneBloc.checkZone(state.data.subArea);
          }
          widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName:state.data.subArea));
        }
         else if(state is MapErrorState)
          EasyLoading.dismiss();

      },
      builder: (context, state) {
        if(state is MapSuccessState){
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black,),
                elevation: 0,
                leading: Builder(
                  builder: (context){
                    return Icon(Icons.notifications_active_outlined,color: Colors.black,);
                    // return Container(
                    //   width: 10,
                    //   child:  IconButton(
                    //       icon: Icon(Icons.notifications_active_outlined,color: Colors.black,),
                    //       onPressed: () {
                    //        // Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationsScreen()));
                    //       }),
                    // );
                  },
                ) ,

                backgroundColor: Colors.white,
                title:  GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(MapRoutes.MAP_SCREEN,arguments: false).then((value) async{
                      if (value != null) {
                        AddressModel addressModel = (value as AddressModel);
                        widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName: addressModel.subArea));
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
                            Icon(Icons.location_on_outlined,size: 18,color: Colors.black87,),
                            Text(
                              S.of(context)!.deliveryTo,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: SizeConfig.titleSize * 1.8),
                            ),
                          ],
                        ),
                        BlocBuilder<FilterZoneCubit,FilterZoneCubitState>(
                            bloc:  widget.filterZoneCubit,
                            builder: (context,state) {
                              return Text(state.searchModel.zoneName,style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: SizeConfig.titleSize * 1.6),

                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: () {

                    showSearch(context: context, delegate: CompanySearch(widget.allCompanyBloc));
                  }, icon: Icon(Icons.search_rounded,color: Colors.black54,))

                ],
              ),
              body: BlocConsumer<CheckZoneBloc,CheckZoneStates>(
                bloc: widget.checkZoneBloc,
                listener: (context,checkZoneState)async{
                  if(checkZoneState is CheckZoneSuccessState){

                    /// Configure the shopping cart for the products of the specified store
                    shopCartBloc.startedShop();

                    widget.allCompanyBloc.getAllCompany(checkZoneState.storeId);
                    widget.recommendedProductsCompanyBloc.getRecommendedProducts(checkZoneState.storeId);

                  EasyLoading.dismiss();
                  }
                  else if(checkZoneState is CheckZoneErrorState){
                    EasyLoading.dismiss();
                    widget.allCompanyBloc.setInit();
                  }

                },
                builder: (context,checkZoneState) {
                  if(checkZoneState is CheckZoneSuccessState){
                    return Material(
                      child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: BlocBuilder<RecommendedProductsCompanyBloc,RecommendedProductsCompanyStates>(
                                      bloc: widget.recommendedProductsCompanyBloc,
                                      builder: (context,state) {
                                        if(state is RecommendedProductsCompanySuccessState){
                                          List<AdvertisementModel> advertisement = state.data;
                                          return PageViewWidget(
                                              itemCount: advertisement.length,
                                              hieght: SizeConfig.screenHeight * 0.19,
                                              pageBuilder: (index) {
                                                return GestureDetector(
                                                  onTap: (){
                                                    AdvertisementModel a =  advertisement[index];
                                                    List<String> route = a.route.split('|') ;
                                                    if(route[0] == AdvertisementType.ADVERTISEMENT_PRODUCT.name){
                                                      String productId = route[1];
                                                      Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:productId );

                                                    }else if(route[0] == AdvertisementType.ADVERTISEMENT_COMPANY.name){

                                                      List<String> route_arrguments=  route[1].split('&');
                                                      String companyId =route_arrguments[0];
                                                      String companyName =route_arrguments[1];
                                                      String companyImage =route_arrguments[2];
                                                      CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                                                      argumentsRoute.companyId = companyId.replaceAll('id=','');
                                                      argumentsRoute.companyName = companyName.replaceAll('name=','');
                                                      argumentsRoute.companyImage = companyImage.replaceAll('image=','');

                                                     Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                                    clipBehavior: Clip.antiAlias,
                                                    height: SizeConfig.screenHeight * 0.19,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border:Border.all(
                                                          color: Colors.black12,
                                                          width: 1

                                                      ),
                                                    ),
                                                    child:CachedNetworkImage(
                                                      imageUrl: advertisement[index].imageUrl,
                                                      fadeInCurve: Curves.easeInOut,
                                                      progressIndicatorBuilder: (context, l, ll) =>
                                                          Center(
                                                            child: Container(width: 50,
                                                              height: 40,
                                                              child:  CircularProgressIndicator(
                                                                value: ll.progress,
                                                                color: Colors.black12,
                                                              ),),
                                                          ),

                                                      errorWidget: (context, s, l) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                        else if (state is RecommendedProductsCompanyErrorState){
                                          return Center(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 20,),
                                                Text(state.message),
                                                SizedBox(height: 8,),
                                                GestureDetector(
                                                    onTap: (){
                                                      widget.recommendedProductsCompanyBloc.getRecommendedProducts(checkZoneState.storeId);

                                                    },
                                                    child: Text(S.of(context)!.refresh,style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),)),
                                                SizedBox(height: 20,),
                                              ],
                                            ),
                                          );
                                        }
                                        else if (state is RecommendedProductsCompanyZoneErrorState){
                                          return Center(
                                            child: Text(state.message),
                                          );
                                        }
                                        else{
                                          return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300.withOpacity(0.8),
                                              highlightColor: Colors.grey.shade100,
                                              enabled: true,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white,

                                                ),
                                                height:  SizeConfig.screenHeight * 0.19,
                                                width:  SizeConfig.screenWidth * 0.9,
                                              ));
                                        }

                                      }
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              /// Companies
                              ///

                              Expanded(
                                child: BlocConsumer<AllCompanyBloc, AllCompanyStates>(
                                  bloc: widget.allCompanyBloc,
                                  listener: (context, state) {

                                  },
                                  builder: (context, state) {
                                    if (state is AllCompanySuccessState) {
                                      return DescoveryGridWidget(
                                        data: state.data,
                                        onRefresh: () {
                                          _onRefresh(checkZoneState.storeId);
                                        },
                                      );
                                    } else if (state is AllCompanyErrorState) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Container(
                                                  child: Text(state.message),
                                                )),
                                            IconButton(onPressed: (){
                                              widget.allCompanyBloc.getAllCompany(checkZoneState.storeId);
                                            }, icon: Icon(Icons.refresh))
                                          ],
                                        ),
                                      );
                                    } else
                                      return ProductShimmerGridWidget();
                                  },
                                ),
                              )
                            ],
                          )),
                    );
                  }
                  else if(checkZoneState is CheckZoneLoadingState){
                    return SizedBox.shrink();
                   // return Center(
                   //    child: Material(
                   //
                   //      elevation: 8,
                   //      clipBehavior: Clip.antiAlias,
                   //      shape: RoundedRectangleBorder(
                   //          borderRadius: BorderRadius.circular(10)
                   //
                   //      ),
                   //      child: Container(
                   //        decoration: BoxDecoration(
                   //          color: Colors.white.withOpacity(0.5),
                   //        ),
                   //        padding: EdgeInsets.all(10),
                   //
                   //        width: 140,
                   //        height: 70,
                   //        child: Center(child: Row(
                   //          mainAxisAlignment: MainAxisAlignment.spaceAround,
                   //          children: [
                   //            Text(S.of(context)!.pleaseWait),
                   //            Container(
                   //              height: 20,
                   //              width: 20,
                   //              child: CircularProgressIndicator(
                   //
                   //                color: Colors.black54,),
                   //
                   //            ),
                   //          ],
                   //        ),),
                   //      ),
                   //    ),
                   //  );
                  }
                  else if(checkZoneState is CheckZoneErrorState){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * 0.1,),
                            Container(
                              width: SizeConfig.screenWidth * 0.7,
                              child: Image.asset('assets/coming_soon.png'),

                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
                              child:   Text(S.of(context)!.comingSoon,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.titleSize * 1.8,
                                    color: Colors.black45,
                                  fontWeight: FontWeight.w800
                                ),
                            ),

                            )
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Container(
                    );
                  }

                }
              )
            );

        }
        else if(state is MapLoadingState){
          return Scaffold(
          );
        }
        else if(state is MapErrorState){
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
                   SizedBox(height: 15,),
                   Text(S.of(context)!.determineLocation,
                   textAlign: TextAlign.center,
                     style: GoogleFonts.lato(
                       fontSize: SizeConfig.titleSize * 1.5,
                       fontWeight: FontWeight.w800,
                       color: Colors.black45
                     ),

                   ),
                   SizedBox(height: 20,),
                   Container(
                     height: 40,
                     width: SizeConfig.screenWidth *0.3,
                     color: ColorsConst.mainColor,
                     child: MaterialButton(
                       onPressed: (){
                         Navigator.of(context).pushNamed(MapRoutes.MAP_SCREEN,arguments: false).then((value) {
                           if (value != null) {
                             AddressModel addressModel = (value as AddressModel);
                             widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName: addressModel.subArea));
                             widget.checkZoneBloc.checkZone(addressModel.subArea);
                           }
                         });

                       },
                       child: Icon(Icons.location_on_outlined,size: 30,color: Colors.white,),
                     ),
                   )
                 ],
               ),
             ),
           ),
          );
        }
        else{
          return Scaffold();
        }


        
      }
    );
  }


  Future<void> _onRefresh(String storeId) async {

    await widget.allCompanyBloc.getAllCompany( storeId);
  }


}
class CompanySearch extends SearchDelegate<SearchModel?>{
  late AllCompanyBloc _allCompanyBloc ;


  CompanySearch(AllCompanyBloc bloc){
    _allCompanyBloc = bloc;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: (){
      query ='';
    }, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: transitionAnimation,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: (){

      },
      title: Text('Select Result From Suggestions'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     return BlocBuilder<AllCompanyBloc,AllCompanyStates>(
       bloc: _allCompanyBloc,
       builder: (context,state) {
         if(state is AllCompanySuccessState){
           List<CompanyModel>companies =  state.data;
           companies.removeWhere((element) => element.isActive ==false);
           final suggestionList = companies.where((element) =>element.name.startsWith(query)  ).toList();

           return ListView.builder(
               itemCount:suggestionList.length ,
               itemBuilder: (context,index){
                 return ListTile(leading: Icon(Icons.location_city),
                   onTap: (){
                     CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                     argumentsRoute.companyId = suggestionList[index].id;
                     argumentsRoute.companyImage = suggestionList[index].imageUrl;
                     argumentsRoute.companyName = suggestionList[index].name;

                     Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
                   },
                   title: RichText(
                     text: TextSpan(
                         text: suggestionList[index].name.substring(0,query.length),
                         style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),
                         children: [
                           TextSpan(
                             text: suggestionList[index].name.substring(query.length),
                             style: TextStyle(color: Colors.grey,fontSize: 16),

                           )
                         ]
                     ),
                   ),
                 );
               });
         }else{
           return CircularProgressIndicator(color: ColorsConst.mainColor,);
         }

       }
     );
  }



}