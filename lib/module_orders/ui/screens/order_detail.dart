
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/state_manager/order_detail_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class OrderDetailScreen extends StatefulWidget {

  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderDetailBloc _detailBloc = OrderDetailBloc();
  late String orderID;
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    orderID = ModalRoute.of(context)!.settings.arguments.toString();
    _detailBloc.getOrderDetail(orderId:orderID);
  });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:   Text(S.of(context)!.orderDetail,style: GoogleFonts.lato(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),),
          elevation: 0,
        backgroundColor: ColorsConst.mainColor,
      ),
      body:  BlocBuilder<OrderDetailBloc , OrderDetailStates>(
        bloc: _detailBloc,
        builder: (context,state) {
          if(state is OrderDetailErrorState)
            return Center(
              child: Container(
                child: Text(state.message),
              ),
            );
          else if(state is OrderDetailSuccessState){
            OrderModel order = state.data;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.destination,style: GoogleFonts.lato(
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),),


                            ],
                          ),
                          SizedBox(height: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child:Text(order.addressName,style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.w800
                            )),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.quickOrder,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:Text(order.vipOrder?S.of(context)!.yes :S.of(context)!.no,style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            )),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.price_change_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.price,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:    Text(order.orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            )),
                          )

                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.phone,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:    Text(order.phone.toString(),style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            )),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.payments_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.paymentMethods,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10,),
                            child:    Text(order.payment == 'Cash Money'?S.of(context)!.cashMoney:S.of(context)!.creditCard,style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            )),
                          )

                        ],
                      ),
                    ),

                    SizedBox(height:15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.history_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.orderDate,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                            child:    Text(DateFormat('yyyy-MM-dd : HH-mm').format(order.startDate!),style: GoogleFonts.lato(
                                fontSize:SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold
                            )),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0,1)
                          )]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.description_outlined,color: Colors.blue,),
                              SizedBox(width: 5,),
                              Text(S.of(context)!.description,style: GoogleFonts.lato(
                                  letterSpacing: 1,
                                  fontSize:SizeConfig.titleSize * 1.8,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child:     Text(order.description,style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 1.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.w800
                            )),
                          )

                        ],
                      ),
                    ),

                    SizedBox(height: 15,),
                    GestureDetector(
                      onTap: (){
                        showMaterialModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)
                            ),
                          ),
                          context: context,
                          builder: (context) => Container(
                              height: SizeConfig.screenHeight* 0.9,
                              child: _buildProductListWidget(order.products,ModalScrollController.of(context)!))
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                offset: Offset(0,1)
                            )]
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart_outlined,color: Colors.blue,),
                                SizedBox(width: 5,),
                                Text(S.of(context)!.orderProducts,style: GoogleFonts.lato(
                                    letterSpacing: 1,
                                    fontSize:SizeConfig.titleSize * 1.8,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),),
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue
                              ),
                              child:  Icon(Icons.arrow_drop_up,color: Colors.white,size: 26,)
                            )
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          }

          else {
            return Center(
              child: Container(
                width: 30,
                height: 30,
                child:CircularProgressIndicator(color: ColorsConst.mainColor,) ,
              ),
            );
          }
        }
      ),
    );
  }



  Widget _buildProductListWidget(List<ProductModel> items,ScrollController controller) {

    if (items.length == 0) {
      return Center(
        child:  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: SizeConfig.screenHeight * 0.3,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image.asset('assets/empity.png',fit: BoxFit.fill,)),
                SizedBox(height: 10,),
                Text('No data to display',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45),)
              ],
            )),
      );
    } else {

      return AnimationLimiter(
        child: Column(
          children: [
            Center(
              child: Padding(padding: EdgeInsets.symmetric(vertical: 8),
              child: IconButton(icon: Icon(Platform.isIOS? Icons.keyboard_arrow_down: Icons.arrow_downward_rounded,),onPressed: (){
                Navigator.pop(context);
              }),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.7,
                    children: List.generate(
                        items.length,
                            (index){
                          return  AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount:3,
                            duration: Duration(milliseconds: 350),
                            child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:items[index].id );
                                    },
                                    child: Badge(
                                      badgeContent: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        height: SizeConfig.heightMulti * 1.8,
                                        width: SizeConfig.heightMulti * 1.8,
                                        child:
                                        Center(
                                          child: Text(items[index].orderQuantity.toString(),
                                          style: TextStyle(color: Colors.white,
                                          fontSize: SizeConfig.titleSize * 1.8,
                                            fontWeight: FontWeight.w600
                                          ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 1))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio:  1.5,
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
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
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          (items[index].old_price !=
                                                              null)
                                                              ? Text(
                                                            items[index]
                                                                .old_price
                                                                .toString(),
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
                                                                fontSize:
                                                                SizeConfig
                                                                    .titleSize *
                                                                    1.6),
                                                          )
                                                              : SizedBox.shrink(),
                                                          SizedBox(width: 8,),
                                                          Expanded(
                                                            child: Text(
                                                              items[index]
                                                                  .price
                                                                  .toString(),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight:
                                                                  FontWeight.w700,
                                                                  fontSize: SizeConfig
                                                                      .titleSize *
                                                                      1.8),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                                        child: Text(
                                                          UtilsConst.lang =='en'?
                                                          items[index].title:
                                                          items[index].title2
                                                          ,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors.black87,
                                                              fontSize: SizeConfig
                                                                  .titleSize *
                                                                  1.3,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),

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
                          );})),
              ),
            ),
          ],
        ),
      );



    }
  }
}
