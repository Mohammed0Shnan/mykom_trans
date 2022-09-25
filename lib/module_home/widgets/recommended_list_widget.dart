import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class RecommendedListWidget extends StatelessWidget {
  final List<ProductModel> data;

  const RecommendedListWidget(
      {required this.data, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCompanyItems(data);
  }

  Widget _buildCompanyItems(List<ProductModel> items) {
    if (items.length == 0) {
      return Center(
          child: Container(
            child: Text(UtilsConst.lang == 'en'? 'There are no recommended products':'الا يوجد منتجات موصى بها'),
          ));
    } else {
      String _currency = UtilsConst.lang == 'en' ? 'AED':'د.إ';

      return AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
            physics: Platform.isAndroid
                ? ClampingScrollPhysics()
                : BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 400),
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {

                     Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:items[index].id );

                      },
                      child: Container(
                        height: 110,
                        width: 130,
                        margin: EdgeInsets.only(left: 12.0,bottom: 8.0),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// The image section
                            Container(
                              height: 90.0,
                              width: 130,
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
                                        height: 25.0,
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
                                              fontSize: 14.0),
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
                                        height: 25.0,
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
                                              fontSize: 14.0),
                                        ),
                                      ))
                                      : SizedBox.shrink()
                                ],
                              ),
                            ),
                            SizedBox(height: 8,),
                            //
                            /// The price section
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  (items[index].old_price !=
                                      null)
                                      ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal:6),
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
                                          fontSize:10),
                                    ),
                                  )
                                      : SizedBox.shrink(),
                                  SizedBox(width: 6,),
                                  Text(
                                    items[index]
                                        .price
                                        .toString()+ " "+_currency,
                                    overflow: TextOverflow
                                        .ellipsis,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontSize: 11),
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(height: 4,),
                            /// The name section
                            Container(
                              // height: 40,
                              padding: EdgeInsets.symmetric(horizontal:13),
                              child: Text(
                                UtilsConst.lang == 'en'?
                                items[index].title:
                                items[index].title2,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight:
                                    FontWeight.w700,

                                    color: Colors.black54,
                                    overflow: TextOverflow
                                        .ellipsis),
                              ),
                            ),
                            SizedBox(height: 4,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Text(
                                items[index]
                                    .quantity
                                    .toString() +' '+ S.of(context)!.plot,
                                style: TextStyle(
                                    color:
                                    Colors.black26,
                                    fontWeight:
                                    FontWeight.w700,
                                    fontSize:11),
                              ),
                            ),
                            // ///
                            // SizedBox(
                            //   height:4,
                            // ),
                            // AspectRatio(
                            //   aspectRatio: 5.8,
                            //   child: Container(
                            //     margin: EdgeInsets.symmetric(horizontal: 4),
                            //     // height: 30,
                            //     child: Row(
                            //       mainAxisAlignment:
                            //       MainAxisAlignment
                            //           .spaceBetween,
                            //       children: [
                            //
                            //         Expanded(
                            //           flex:10,
                            //           child: LayoutBuilder(
                            //             builder: (BuildContext
                            //             context,
                            //                 BoxConstraints
                            //                 constraints) {
                            //               double w = constraints
                            //                   .maxWidth;
                            //
                            //               return Container(
                            //                 clipBehavior:
                            //                 Clip.antiAlias,
                            //                 decoration:
                            //                 BoxDecoration(
                            //                   boxShadow: [
                            //                     BoxShadow(
                            //                         color: Colors
                            //                             .black12)
                            //                   ],
                            //                   borderRadius:
                            //                   BorderRadius
                            //                       .circular(
                            //                       5),
                            //                   color: Colors
                            //                       .white
                            //                       .withOpacity(
                            //                       0.1),
                            //                 ),
                            //                 child: Stack(
                            //                   children: [
                            //                     Row(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment
                            //                           .spaceBetween,
                            //                       children: [
                            //                         Container(
                            //                           alignment: Alignment.center,
                            //                           color: ColorsConst
                            //                               .mainColor,
                            //                           width: w /
                            //                               3,
                            //                           child: Center(
                            //                             child: IconButton(
                            //                                 onPressed: () {
                            //                                   addRemoveBloc.removeOne();
                            //                                 },
                            //                                 icon: Icon(
                            //                                   Icons.remove,
                            //                                   size:15,
                            //                                   color:
                            //                                   Colors.white,
                            //                                 )),
                            //                           ),
                            //                         ),
                            //                         BlocBuilder<AddRemoveProductQuantityBloc , int>(
                            //                             bloc:addRemoveBloc ,
                            //                             builder: (context,state){
                            //                               return  Container(
                            //                                 child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                            //                               );
                            //                             }),
                            //                         Container(
                            //                           alignment: Alignment.center,
                            //
                            //                           width: w /
                            //                               3,
                            //                           color: ColorsConst
                            //                               .mainColor,
                            //                           child:
                            //                           Center(
                            //                             child: Center(
                            //                               child: IconButton(
                            //                                   onPressed: () {
                            //                                     addRemoveBloc.addOne();
                            //
                            //                                   },
                            //                                   icon: Icon(
                            //                                     Icons.add,
                            //
                            //                                     size:15,
                            //
                            //                                     color: Colors.white,
                            //                                   )),
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         ),
                            //         SizedBox(width: 8,),
                            //         SizedBox(
                            //           // height: 10,
                            //           child: ElevatedButton
                            //               .icon(
                            //
                            //             onPressed: () {
                            //               widget._authService.isLoggedIn.then((value) {
                            //                 if(value){
                            //                   if(addRemoveBloc.state == 0){
                            //
                            //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //                       content:  Text(S.of(context)!.selectTheNumberOfItemsRequired,style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                            //                       backgroundColor: Colors.black54,
                            //                       duration: const Duration(seconds: 1),
                            //
                            //                     ));
                            //                   }
                            //                   else{
                            //                     shopCartBloc.addProductsToCart(items[index],addRemoveBloc.state).then((value) {
                            //                       addRemoveBloc.clear();
                            //                     });
                            //                   }
                            //
                            //                 }else{
                            //                   loginCheakAlertWidget(context);
                            //                 }
                            //               });
                            //
                            //             },
                            //             label: Text(
                            //               S.of(context)!.added,
                            //               style: TextStyle(
                            //                   color: Colors
                            //                       .white,
                            //                   fontSize: 13,
                            //                   fontWeight:
                            //                   FontWeight
                            //                       .w900),
                            //             ),
                            //             icon: Icon(
                            //               Icons
                            //                   .shopping_cart_outlined,
                            //               size:16,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 4,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
    }
  }
}