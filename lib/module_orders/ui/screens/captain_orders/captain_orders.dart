import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/bloc/is_loggedin_cubit.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/ui/widgets/no_data_for_display_widget.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class CaptainOrdersScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CaptainOrdersScreenState();
}

class CaptainOrdersScreenState extends State<CaptainOrdersScreen> {
  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();
   final NewOrderBloc _orderBloc = NewOrderBloc();
   late final IsLogginCubit isLogginCubit;
  final String CURRENT_ORDER = 'current';
  final String PREVIOUS_ORDER = 'previous';
  late String current_tap ;
  late String _storeID;
  @override
  void initState() {
    current_tap = CURRENT_ORDER;

    isLogginCubit = IsLogginCubit();
    super.initState();
  }
  @override
  void dispose() {
    isLogginCubit.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  return BlocConsumer<IsLogginCubit,IsLogginCubitState>(
    bloc: isLogginCubit,
      listener: (context,state){
      if(state ==IsLogginCubitState.LoggedIn)
        _ordersListBloc.getMyOrders();
      if(state == IsLogginCubitState.NotLoggedIn)
        loginCheakAlertWidget(context);
      },
      builder: (context,state){
        if(state == IsLogginCubitState.LoggedIn){
          return  BlocProvider.value(
            value: _ordersListBloc,
            child: Scaffold(
              backgroundColor: Colors.grey.shade50,
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      child: Text(S.of(context)!.orders,style: GoogleFonts.lato(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),),
                    ),
                    SizedBox(height: 8,),
                    getAccountSwitcher(),
                    SizedBox(height: 8,),

                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: current_tap == CURRENT_ORDER
                            ? getCurrentOrders()
                            : getPreviousOrders(),
                      ),
                    ),
                  ],
                ),
              ),

            ),
          );
        }else{
          return Scaffold(
            backgroundColor: Colors.white,
          );
        }
      });


  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
      child: BlocBuilder<CaptainOrdersListBloc ,CaptainOrdersListStates >(
        bloc: _ordersListBloc,
        builder: (context, state) {
          int curNumber =0;
          int preNumber =0;
          if(state is CaptainOrdersListSuccessState){
            curNumber = state.currentOrders.length;
            preNumber = state.previousOrders.length;
          }
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    current_tap = CURRENT_ORDER;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: current_tap == CURRENT_ORDER
                            ? ColorsConst.mainColor
                            : Colors.transparent,
                      ),
                      child: Center(child: Text('${S.of(context)!.currentOrders} (${curNumber})',style: TextStyle(
                        color: current_tap == CURRENT_ORDER ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),))),
                ),
              ),
              Expanded(
                child:GestureDetector(
                  onTap: () {
                    current_tap = PREVIOUS_ORDER;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(vertical:6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      color:    current_tap == PREVIOUS_ORDER
                          ? ColorsConst.mainColor
                          : Colors.transparent,
                    ),
                    child:Center(child: Text('${S.of(context)!.previousOrders} (${preNumber})',style: TextStyle(
                        color: current_tap == PREVIOUS_ORDER ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ))),
                  ),
                ),
              )

            ],
          );
        }
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
    _ordersListBloc.getMyOrders();
  }
 Widget getCurrentOrders(){
    return BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
      bloc: _ordersListBloc,
      listener: (context ,state){
      },
      builder: (maincontext,state) {

         if(state is CaptainOrdersListErrorState)
          return Center(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                color: ColorsConst.mainColor,
                padding: EdgeInsets.symmetric(),
                child: Text(state.message,style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
              ),
            ),
          );

        else if(state is CaptainOrdersListSuccessState) {
           List<OrderModel> orders = state.currentOrders;

           if(orders.isEmpty)
             return Center(
               child:   NoDataForDisplayWidget()
             );
           else
          return RefreshIndicator(
          onRefresh: ()=>onRefreshMyOrder(),
          child: ListView.separated(
            itemCount:orders.length,
            separatorBuilder: (context,index){
              return SizedBox(height: 8,);
            },
            itemBuilder: (context,index){
              return Container(
                height: 150,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius:1,
                      spreadRadius: 1
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 50,height: 50,
                        child: Image.asset('assets/order_icon.png'),),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: ColorsConst.mainColor.withOpacity(0.1)
                                    ),
                                    child: Text('${S.of(context)!.orderNumber} : '+orders[index].customerOrderID.toString() ,style: GoogleFonts.lato(
                                        color: ColorsConst.mainColor,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  )
                                ],
                              ),
                              SizedBox(height: 8,),
                               Text(orders[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                    fontSize: 12,

                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800
                                ),
                              ),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on_outlined , color: Colors.black45,size: 12,),
                                  Expanded(
                                    child: Text(orders[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w800,

                                    )),
                                  )

                                ],),
                              SizedBox(height: 4,),
                              Text(orders[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: ColorsConst.mainColor,
                                  fontWeight: FontWeight.bold
                              )),
                              SizedBox(height: 4,),

                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 4,),
                    Container(
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white
                                  ,
                                  border: Border.all(
                                      color: ColorsConst.mainColor,
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(maincontext, OrdersRoutes.ORDER_DETAIL_SCREEN,arguments: orders[index].id);
                                },
                                child: Text(S.of(context)!.orderDetail, style: TextStyle(
                                    color: ColorsConst.mainColor,
                                    fontSize: SizeConfig.titleSize * 1.7),),

                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.widhtMulti * 3,),
                          Expanded(child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: MaterialButton(
                              onPressed: () {

                              Navigator.pushNamed(maincontext, OrdersRoutes.ORDER_STATUS_SCREEN,arguments:  orders[index].id);
                              },
                              child: Text(S.of(context)!.trackShipment, style: TextStyle(color: Colors.white,
                                  fontSize: SizeConfig.titleSize * 1.7),),

                            ),
                          ))
                          ,
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );}
        else  return Center(
             child: Container(
               width: 30,
               height: 30,
               child: CircularProgressIndicator(color: ColorsConst.mainColor,),
             ),
           );

      }
    );
  }

  Widget getPreviousOrders(){
    return BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
        bloc: _ordersListBloc,
        listener: (context ,state){
        },
        builder: (maincontext,state) {

          if(state is CaptainOrdersListErrorState)
            return Center(
              child: GestureDetector(
                onTap: (){

                },
                child: Container(
                  color: ColorsConst.mainColor,
                  padding: EdgeInsets.symmetric(),
                  child: Text(state.message,style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                ),
              ),
            );

          else if(state is CaptainOrdersListSuccessState) {
            List<OrderModel> orders = state.previousOrders;

            if(orders.isEmpty)
              return Center(
                child:  NoDataForDisplayWidget(),
              );
            else
              return RefreshIndicator(
                onRefresh: ()=>onRefreshMyOrder(),
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount:orders.length,
                      separatorBuilder: (context,index){
                        return SizedBox(height: 8,);
                      },
                      itemBuilder: (context,index){
                        return Container(
                          height: 150,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius:1,
                                  spreadRadius: 1
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorsConst.mainColor.withOpacity(0.1)
                                    ),
                                    child: Text('${S.of(context)!.orderNumber} : '+orders[index].customerOrderID.toString() ,style: GoogleFonts.lato(
                                        color: ColorsConst.mainColor,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  )
                                ],
                              ),
                              SizedBox(height: 8,),
                              Expanded(
                                child: Text(orders[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800
                                )),
                              ),
                              SizedBox(height: 4,),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on_outlined , color: Colors.black45,),
                                  Expanded(
                                    child: Text(orders[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w800,

                                    )),
                                  )

                                ],),
                              SizedBox(height: 4,),
                              Text(orders[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: ColorsConst.mainColor,
                                  fontWeight: FontWeight.bold
                              )),
                              SizedBox(height: 4,),
                              Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            color: Colors.white
                                            ,
                                            border: Border.all(
                                                color: ColorsConst.mainColor,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, OrdersRoutes.ORDER_DETAIL_SCREEN,arguments: orders[index].id);
                                          },
                                          child: Text(S.of(context)!.orderDetail, style: TextStyle(
                                              color: ColorsConst.mainColor,
                                              fontSize: SizeConfig.titleSize * 1.7),),

                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.widhtMulti * 3,),
                                    Expanded(child:
                                    Container(
                                      height: 30,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: ColorsConst.mainColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {
                                          _orderBloc.reorder(orders[index].id);
                                        },
                                        child: Text(S.of(context)!.reOrder, style: TextStyle(color: Colors.white,
                                            fontSize: SizeConfig.titleSize * 1.7),),

                                      ),
                                    )
                                 )
                                    ,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    BlocConsumer<NewOrderBloc,CreateOrderStates>(
                        bloc: _orderBloc,
                        listener: (context,state)async{
                          if(state is CreateOrderSuccessState)
                          {
                            snackBarSuccessWidget(context, 'Order Created Successfully!!');
                          }
                          else if(state is CreateOrderErrorState)
                          {
                            snackBarSuccessWidget(context, 'The Order Was Not Created!!');
                          }
                        },
                        builder: (context,state) {
                          bool isLoading = state is CreateOrderLoadingState?true:false;

                          return isLoading? Center(child: Container(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          ),):SizedBox.shrink();

                        }
                    ),

                  ],
                ),
              );}
          else  return Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(color: ColorsConst.mainColor,),
              ),
            );

        }
    );
  }

}
