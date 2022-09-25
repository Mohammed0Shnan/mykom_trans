import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/products_detail_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/screen/widgets/app_icon.dart';
import 'package:my_kom/module_company/screen/widgets/expanded_text_widget.dart';
import 'package:my_kom/module_orders/ui/widgets/no_data_for_display_widget.dart';
import 'package:my_kom/module_shoping/bloc/add_remove_product_quantity_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';


class PriductDetailScreen extends StatefulWidget {


  @override
  State<PriductDetailScreen> createState() => _PriductDetailScreenState();
}

class _PriductDetailScreenState extends State<PriductDetailScreen> {
  late final AddRemoveProductQuantityBloc addRemoveBloc;
  late final ProductDetailBloc _detailBloc = ProductDetailBloc();
  late ProductModel productModel;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String productId = ModalRoute.of(context)!.settings.arguments as String;
        _detailBloc.getProductDetail(productId);

    });
    addRemoveBloc = AddRemoveProductQuantityBloc();
    super.initState();
    
  }
  @override
  void dispose() {
addRemoveBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   // ShopCartBloc shopCartBlocProvided = context.read<ShopCartBloc>();
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: BlocBuilder<ProductDetailBloc,DetailStates>(
          bloc: _detailBloc,
          builder: (context,state) {
            if(state is DetailSuccessState){
              productModel = state.data;
              return Scaffold(
                body: Material(

                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 11.9 * SizeConfig.heightMulti,
                        pinned: true,
                        backgroundColor: ColorsConst.mainColor,
                        expandedHeight: SizeConfig.screenHeight * 0.35,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconWidget(icon:Platform.isIOS? Icons.arrow_back_ios: Icons.arrow_back, onPress: (){
                              Navigator.pop(context);
                            }),
                            BlocBuilder<ShopCartBloc,CartState>(
                                bloc: shopCartBloc,
                                builder: (context,state) {

                                  return Container(
                                    alignment: Alignment.center,
                                    width:40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.8)
                                    ),
                                    child:Badge(
                                      // position: BadgePosition.topEnd(top: 0, end: 3),
                                      animationDuration: Duration(milliseconds: 300),
                                      animationType: BadgeAnimationType.slide,
                                      badgeContent: Text(
                                        (state is CartLoaded)?  state.cart.products.length.toString():'0',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      child: IconButton(
                                          icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
                                          onPressed: () {
                                            _authService.isLoggedIn.then((value) {
                                              if(value){
                                                Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);

                                              }else{
                                                loginCheakAlertWidget(context);
                                              }
                                            });
                                           // Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);
                                          }),
                                    ),
                                  );
                                }
                            ),


                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background:     Container(
                            margin: EdgeInsets.only(bottom: 30),
                            width: double.infinity,
                            //child: Image.network(productModel.imageUrl,fit: BoxFit.fill,),
                            child:CachedNetworkImage(

                              imageUrl:productModel.imageUrl,
                              progressIndicatorBuilder: (context, l, ll) =>
                                  Center(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        value: ll.progress,
                                        color: Colors.black45
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, s, l) => Icon(Icons.error),
                              fit: BoxFit.fill,
                            ),

                          ),



                        ),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(20),
                          child: Container(
                              padding: EdgeInsets.only(bottom: 10,top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white
                                  ,borderRadius: BorderRadius.only(

                                  topLeft:Radius.circular(20),
                                  topRight: Radius.circular(20)
                              ))
                              ,child: Center(child: Text(
                          UtilsConst.lang == 'en'?productModel.title:productModel.title2
                          ,style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87

                          )
                          ))) ,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20,),
                              Text(S.of(context)!.description,style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),),
                              SizedBox(height: 10,),
                              ExpadedTextWidget(text:UtilsConst.lang == 'en'? productModel.description:productModel.description2),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.all(8),
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200
                      ,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                  child:               Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween
                            ,
                            children: [

                              Container(
                                  width: SizeConfig.widhtMulti * 25
                                  ,height:30
                                  ,  child: LayoutBuilder(
                                builder:
                                    (BuildContext context, BoxConstraints constraints) {
                                  double w = constraints.maxWidth;

                                  return Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      boxShadow: [BoxShadow(color: Colors.black12)],
                                      borderRadius: BorderRadius.circular(10)
                                      ,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(

                                              decoration: BoxDecoration(
                                                  color: ColorsConst.mainColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              width: w / 3,
                                              child: IconButton(
                                                  onPressed: () {
                                                    addRemoveBloc.removeOne();
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            BlocBuilder<AddRemoveProductQuantityBloc , int>(
                                                bloc:addRemoveBloc ,
                                                builder: (context,state){
                                                  return  Container(
                                                    child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                                                  );
                                                })
                                            ,
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: ColorsConst.mainColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              width: w / 3,
                                              child: Center(
                                                child: IconButton(
                                                    onPressed: () {
                                                      addRemoveBloc.addOne();
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                              Text('${productModel.price}  AED',
                                style: GoogleFonts.lato(
                                    color: ColorsConst.mainColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),

                          Builder(
                            builder:(context)=> Container(
                              clipBehavior: Clip.antiAlias,
                              height:40,
                              decoration: BoxDecoration(
                                  color: ColorsConst.mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: MaterialButton(
                                onPressed: () {

                                  _authService.isLoggedIn.then((value) {
                                    if(value){
                                      if(addRemoveBloc.state == 0){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content:  Text(S.of(context)!.selectTheNumberOfItemsRequired,style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                                          backgroundColor: Colors.black54,
                                          duration: const Duration(seconds: 1),

                                        ));
                                      }
                                      else{

                                        shopCartBloc.addProductsToCart(productModel,addRemoveBloc.state).then((value) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content:  Text('${addRemoveBloc.state} ${S.of(context)!.itemsHaveBeenAdded}',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                                            backgroundColor: Colors.black54,
                                            duration: const Duration(seconds: 1),

                                          ));
                                          addRemoveBloc.clear();
                                        });
                                      }

                                    }else{
                                      loginCheakAlertWidget(context);
                                    }
                                  });



                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context)!.addToCart,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.shopping_cart_outlined,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ]),
                  ),
                ),

              );
            }else if(state is DetailErrorState){
              return Scaffold(body: NoDataForDisplayWidget());
            }else{
            return  Scaffold(
              body: Center(child: Container(height: 35,width: 35,
                child:Platform.isIOS? CupertinoActivityIndicator(): CircularProgressIndicator(color: ColorsConst.mainColor,),
                ),),
            );
            }

          }
        ),
      ),

    );
  }
}



