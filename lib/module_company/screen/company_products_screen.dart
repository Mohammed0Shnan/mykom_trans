import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/products_company_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_company/screen/widgets/product_shimmer.dart';
import 'package:my_kom/module_orders/ui/widgets/no_data_for_display_widget.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/module_shoping/bloc/add_remove_product_quantity_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'dart:io' show Platform;
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class CompanyProductScreen extends StatefulWidget {

  final AuthService _authService = AuthService();

  CompanyProductScreen({Key? key}) : super(key: key);

  @override
  State<CompanyProductScreen> createState() => _CompanyProductScreenState();
}

class _CompanyProductScreenState extends State<CompanyProductScreen> {
  final TextEditingController _serachController = TextEditingController();
  final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  late final  CompanyModel company;
  @override
  void initState() {

    super.initState();
  }

 bool isInit =true;
  @override
  Widget build(BuildContext context) {

    CompanyArgumentsRoute argumentsRoute =   (ModalRoute.of(context)!.settings.arguments) as CompanyArgumentsRoute;
    company = CompanyModel(id: argumentsRoute.companyId, name: argumentsRoute.companyName, imageUrl: argumentsRoute.companyImage, description: 'description');
    company.name2 = argumentsRoute.companyName2;
    if(isInit){
      productsCompanyBloc.getProducts( company.id);
      setState(() {
        isInit = !isInit;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Platform.isIOS
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back)),
                      Hero(
                        tag: 'company' + company.id,
                        child: Container(
                          height: 35,
                          width: 35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                          
                            // child: Image.network( widget.company!.imageUrl,
                            // fit: BoxFit.cover,
                            // )
                            child: CachedNetworkImage(
                              imageUrl: company.imageUrl,
                              progressIndicatorBuilder:
                                  (context, l, ll) =>
                                  Center(
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        value: ll.progress,
                                        color: Colors.black12,
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, s, l) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        UtilsConst.lang == 'en'?
                     company.name:company.name2,
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  BlocBuilder<ShopCartBloc,CartState>(
                      bloc: shopCartBloc,
                      builder: (context,state) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),

                          alignment: Alignment.center,
                          width:40,
                          height:40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8)
                          ),
                          child:     Badge(
                            // position: BadgePosition.topEnd(top: 0, end: 3),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                           state is CartLoaded?   state.cart.products.length.toString():'0',
                              style: TextStyle(color: Colors.white,fontSize: 11),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
                                onPressed: () {
                                  widget._authService.isLoggedIn.then((value) {
                                    if(value){
                                      Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);

                                    }else{
                                      loginCheakAlertWidget(context);
                                    }
                                  });
                                }),
                          ),
                        );
                      }
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
            
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 1)
                    ]),
                child: SizedBox(
                  height:  35,
                  child: TextFormField(
                    controller: _serachController,
                    style: TextStyle(
                     fontSize: 15
                    ),
                    onChanged: (String query){
                      productsCompanyBloc.search(query.toUpperCase());
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical:6),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 22,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            productsCompanyBloc.search(_serachController.text);
                          },
                        ),
                        hintText:S.of(context)!.searchForYourProducts,
                        hintStyle: TextStyle(color: Colors.black26,fontSize: 13.5)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocConsumer<ProductsCompanyBloc, ProductsCompanyStates>(
                  bloc: productsCompanyBloc,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ProductsCompanySuccessState)
                      return  _buildProductListWidget(state.data);
                    else if (state is ProductsCompanyErrorState) {
                      return Center(
                          child: Container(
                        child: Text(state.message),
                      ));
                    } else
                      return ProductShimmerList();
                  },
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(height: 75,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [BoxShadow(
                offset:Offset(0,-3),
                color: Colors.black12,
                blurRadius: 3
            )]

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 2,),
            FutureBuilder<double?>(
                future: _preferencesHelper.getMinimumPurchaseStore(),
                builder: (context,AsyncSnapshot<double?> snap){
                  if(snap.hasData){
                   return Text('${S.of(context)!.minimumAlert}  ${snap.data} ${ UtilsConst.lang == 'en'?'AED':'د.إ'}',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.w600,color: Colors.black54),);
                  }else{
                  return Text('${S.of(context)!.minimumAlert}  ${ UtilsConst.lang == 'en'?'AED':'د.إ'} ',style: TextStyle(fontSize:12.5,fontWeight: FontWeight.w600,color: Colors.black54),);
                  }
            }),
            Container(
              height: 38,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: ColorsConst.mainColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  widget._authService.isLoggedIn.then((value) {
                    if(value){
                      Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);

                    }else{
                      loginCheakAlertWidget(context);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${S.of(context)!.seeTheCart}',style: TextStyle(color: Colors.white,fontSize: 16.0),),
                    BlocBuilder<ShopCartBloc,CartState>(
                        bloc: shopCartBloc,
                        builder: (context,state) {
                          if(state is CartLoaded ){

                            return Text('${state.cart.totalString}  ${ UtilsConst.lang == 'en'?'AED':'د.إ'}',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.4));
                          }
                          else{
                            return Text('',style: TextStyle(color: Colors.white,fontSize: 17.0));
                          }

                        }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListWidget(List<ProductModel> items) {

    if (items.length == 0) {
      return Center(
        child:  Container(
            child: SingleChildScrollView(
              child:       Center(
                  child:   NoDataForDisplayWidget()
              ),
            )),
      );
    } else {

          String _currency = UtilsConst.lang == 'en' ? 'AED':'د.إ';
            return AnimationLimiter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  onRefresh: () => onRefresh(),

                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.9,
                      children: List.generate(
                          items.length,
                              (index){
                                final AddRemoveProductQuantityBloc addRemoveBloc =AddRemoveProductQuantityBloc();
                         return  AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 2,
                            duration: Duration(milliseconds: 350),
                            child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:items[index].id );

                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,

                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: Hero(
                                        tag:'product'+items[index].id,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            /// The image section
                                            AspectRatio(
                                              aspectRatio:  2.1,
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                          // child: Image.network( items[index].imageUrl,
                                                          //   fit: BoxFit.fitHeight,
                                                          // )
                                                        child:  CachedNetworkImage(
                                                          imageUrl: items[index]
                                                              .imageUrl,
                                                          progressIndicatorBuilder:
                                                              (context, l, ll) =>
                                                              Center(
                                                                child: Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  child: CircularProgressIndicator(
                                                                    value: ll.progress,
                                                                    color: Colors.black12,
                                                                  ),
                                                                ),
                                                              ),
                                                          errorWidget: (context,
                                                              s, l) =>
                                                              Center(child: Icon(Icons.error,size: 40,color: Colors.black45,)),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    (items[index].old_price != null)
                                                        ?  (UtilsConst.lang == 'ar')?Positioned(
                                                        top: 0,

                                                        right: 0,
                                                        child: Container(
                                                          alignment:
                                                          Alignment.center,
                                                          width: SizeConfig
                                                              .widhtMulti *
                                                              13,
                                                          height: SizeConfig
                                                              .heightMulti *
                                                              4,
                                                          decoration: BoxDecoration(
                                                              color: Colors.orange,
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                      10))),
                                                          child: Text(
                                                           S.of(context)!.rival,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 15.5),
                                                          ),
                                                        )):Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: Container(
                                                          alignment:
                                                          Alignment.center,
                                                          width: SizeConfig
                                                              .widhtMulti *
                                                              13,
                                                          height: SizeConfig
                                                              .heightMulti *
                                                              4,
                                                          decoration: BoxDecoration(
                                                              color: Colors.orange,
                                                              borderRadius:(UtilsConst.lang == 'ar')?
                                                              BorderRadius.only(bottomLeft: Radius.circular(10)):
                                                              BorderRadius.only(bottomRight: Radius.circular(10))
                                                          ),
                                                          child: Text(
                                                            S.of(context)!.rival,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 16),
                                                          ),
                                                        ))
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4,),

                                            /// The price section
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Row(
                                                children: [
                                                  (items[index].old_price !=
                                                      null)
                                                      ? Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                                        child: Text(
                                                    items[index]
                                                          .old_price
                                                          .toString()+ " "+_currency,
                                                    overflow:
                                                    TextOverflow
                                                          .ellipsis,
                                                    style: TextStyle(
                                                          decoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                          color: Colors
                                                              .black26,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                          fontSize:11.5),
                                                  ),
                                                      )
                                                      : SizedBox.shrink(),
                                                  SizedBox(width: 8,),
                                                  Expanded(
                                                    child: Text(
                                                      items[index]
                                                          .price
                                                          .toString() + " "+_currency ,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize: 13.5),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),

                                            /// The name section
                                            AspectRatio(
                                              aspectRatio: 4.5,
                                              child: Container(
                                                // height: 40,
                                                padding: EdgeInsets.symmetric(horizontal:8),
                                                child: Row(
                                                  children: [
                                                    Expanded(

                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                                        child: Text(
                                                          UtilsConst.lang == 'en'?
                                                          items[index].title:
                                                          items[index].title2,

                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              color: Colors.black54,
                                                              overflow: TextOverflow
                                                                  .ellipsis),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      items[index]
                                                          .quantity
                                                          .toString() +' '+ S.of(context)!.plot,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.black26,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize:12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ///
                                            SizedBox(
                                              height:8,
                                            ),
                                            AspectRatio(
                                              aspectRatio: 6.5,
                                              child: Container(
                                                 margin: EdgeInsets.symmetric(horizontal: 4),
                                                 // height: 30,
                                                 child: Row(
                                                   mainAxisAlignment:
                                                   MainAxisAlignment
                                                       .spaceBetween,
                                                   children: [

                                                     Expanded(
                                                       flex:10,
                                                       child: LayoutBuilder(
                                                         builder: (BuildContext
                                                         context,
                                                             BoxConstraints
                                                             constraints) {
                                                           double w = constraints
                                                               .maxWidth;

                                                           return Container(
                                                             clipBehavior:
                                                             Clip.antiAlias,
                                                             decoration:
                                                             BoxDecoration(
                                                               boxShadow: [
                                                                 BoxShadow(
                                                                     color: Colors
                                                                         .black12)
                                                               ],
                                                               borderRadius:
                                                               BorderRadius
                                                                   .circular(
                                                                   5),
                                                               color: Colors
                                                                   .white
                                                                   .withOpacity(
                                                                   0.1),
                                                             ),
                                                             child: Stack(
                                                               children: [
                                                                 Row(
                                                                   mainAxisAlignment:
                                                                   MainAxisAlignment
                                                                       .spaceBetween,
                                                                   children: [
                                                                     Container(
                                                                       alignment: Alignment.center,
                                                                       color: ColorsConst
                                                                           .mainColor,
                                                                       width: w /
                                                                           3,
                                                                       child: Center(
                                                                         child: IconButton(
                                                                             onPressed: () {
                                                                               addRemoveBloc.removeOne();
                                                                             },
                                                                             icon: Icon(
                                                                               Icons.remove,
                                                                               size:15,
                                                                               color:
                                                                               Colors.white,
                                                                             )),
                                                                       ),
                                                                     ),
                                                                     BlocBuilder<AddRemoveProductQuantityBloc , int>(
                                                                         bloc:addRemoveBloc ,
                                                                         builder: (context,state){
                                                                           return  Container(
                                                                             child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0),),
                                                                           );
                                                                         }),
                                                                     Container(
                                                                       alignment: Alignment.center,

                                                                       width: w /
                                                                           3,
                                                                       color: ColorsConst
                                                                           .mainColor,
                                                                       child:
                                                                       Center(
                                                                         child: Center(
                                                                           child: IconButton(
                                                                               onPressed: () {
                                                                                 addRemoveBloc.addOne();

                                                                               },
                                                                               icon: Icon(
                                                                                 Icons.add,

                                                                                 size:15,

                                                                                 color: Colors.white,
                                                                               )),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ],
                                                                 ),
                                                               ],
                                                             ),
                                                           );
                                                         },
                                                       ),
                                                     ),
                                                     SizedBox(width: 8,),
                                                     SizedBox(
                                                       // height: 10,

                                                       child: ElevatedButton
                                                           .icon(

                                                         onPressed: () {
                                                           widget._authService.isLoggedIn.then((value) {
                                                             if(value){
                                                               if(addRemoveBloc.state == 0){

                                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                   content:  Text(S.of(context)!.selectTheNumberOfItemsRequired,style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                                                                   backgroundColor: Colors.black54,
                                                                   duration: const Duration(seconds: 1),

                                                                 ));
                                                               }
                                                               else{
                                                                 shopCartBloc.addProductsToCart(items[index],addRemoveBloc.state).then((value) {
                                                                   addRemoveBloc.clear();
                                                                 });
                                                               }

                                                             }else{
                                                               loginCheakAlertWidget(context);
                                                             }
                                                           });

                                                         },
                                                         label: Text(
                                                           S.of(context)!.added,
                                                           style: TextStyle(
                                                               color: Colors
                                                                   .white,
                                                               fontSize: 13,
                                                               fontWeight:
                                                               FontWeight
                                                                   .w900),
                                                         ),
                                                         icon: Icon(
                                                           Icons
                                                               .shopping_cart_outlined,
                                                           size:16,
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          );}))
                ),
              ),
            );



    }
  }

 Future<void> onRefresh()async {
    productsCompanyBloc.getProducts(company.id);
  }
}
