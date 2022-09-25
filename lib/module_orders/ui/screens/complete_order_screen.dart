import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class CompleteOrderScreen extends StatefulWidget {
  final String orderId;
   CompleteOrderScreen({required this.orderId,Key? key}) : super(key: key);

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.15,),
            Center(
              child: Container(
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.screenWidth * 0.6,
                child: Image.asset('assets/complete_order.png',fit: BoxFit.contain,),
              ),
            ),
            Text(S.of(context)!.thankYou,style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w800,color: Colors.black54),),
            SizedBox(height: 8,),
            Text(S.of(context)!.orderReceived,style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w800,color: Colors.black45)),
            Spacer(),
            Container(
              height: 35.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.circular(10)
              ),
              width: SizeConfig.screenWidth,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, OrdersRoutes.ORDER_STATUS_SCREEN ,arguments:  widget.orderId);
                },
                child: Center(child: Text(S.of(context)!.trackingOrder,style: TextStyle(color: Colors.white,fontSize: 16.0),),),
              ),
            ),SizedBox(height:10,),
            Container(
              height: 35.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorsConst.mainColor,
                  width: 3
                )
              ),
              width: SizeConfig.screenWidth,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=>false);
                },
                child: Center(child: Text(S.of(context)!.goToHome,style: TextStyle(color: ColorsConst.mainColor,fontSize:16.0),),),
              ),
            ),SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
