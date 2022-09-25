
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/state_manager/order_status/order_status.state_manager.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:timelines/timelines.dart';
import 'package:my_kom/generated/l10n.dart';

class OrderStatusScreen extends StatefulWidget {

  @override
  OrderStatusScreenState createState() => OrderStatusScreenState();
}

class OrderStatusScreenState extends State<OrderStatusScreen> {
  final OrderStatusBloc _bloc = OrderStatusBloc();
 late String orderId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      orderId = ModalRoute.of(context)!.settings.arguments.toString() ;
      _bloc.getOrderDetails(orderId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: SizeConfig.heightMulti * 5,height: SizeConfig.heightMulti * 3,
              child: Image.asset('assets/map.png',color: Colors.white.withOpacity(0.9),),
            ),
            SizedBox(width: 10,),
            Text(
            S.of(context)!.trackingOrder,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white..withOpacity(0.8)
            ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            _bloc.getOrderDetails(orderId);
          }, icon: Icon(Icons.refresh))
        ],

      ),
      body: BlocBuilder<OrderStatusBloc,OrderStatusStates>(
        bloc: _bloc,
        builder: (context,state) {

          if(state is OrderStatusSuccessState){
            String icons_dir = 'assets/icons/';
            OrderModel currentOrder = state.data;
           int currentIndex = currentOrder.status.index;
           print(currentIndex);
           int stepNumber =  currentOrder.payment == PaymentMethodConst.CASH_MONEY?5:4;
           List<DeliveryInfo> items =<DeliveryInfo>[];

           if(stepNumber == 4){
             items =[
               DeliveryInfo(subTitle:  S.of(context)!.gotCaptionDes,
                   title: S.of(context)!.gotCaption,
                   isNext: (currentIndex == 0)? true:false,
                   image: 'got_captain.svg', isComplete: (currentIndex > 0)? true:false),
               DeliveryInfo(subTitle: S.of(context)!.inStoreDes,
                   isNext: (currentIndex == 1)? true:false,
                   title:  S.of(context)!.inStore,
                   image: 'in_store.svg', isComplete: (currentIndex > 1)? true:false),
               DeliveryInfo(subTitle:  S.of(context)!.deliveryDes,
                   isNext: (currentIndex == 2)? true:false,
                   title:  S.of(context)!.delivery,
                   image: 'delivery.png', isComplete: (currentIndex > 2)? true:false),
               DeliveryInfo(title:  S.of(context)!.finishedDes,
                   isNext: (currentIndex == 3)? true:false,
                   subTitle: S.of(context)!.finished,
                   image: 'finished.svg', isComplete: (currentIndex >3)? true:false),
             ];
           }else{
             items =[
               DeliveryInfo(subTitle:   S.of(context)!.gotCaptionDes,
                   isNext: (currentIndex == 0)? true:false,
                   title:  S.of(context)!.gotCaption,
                   image: 'got_captain.svg', isComplete: (currentIndex > 0)? true:false),
               DeliveryInfo(subTitle:   S.of(context)!.inStoreDes,
                   isNext: (currentIndex == 1)? true:false,
                   title:  S.of(context)!.inStore,
                   image: 'in_store.svg', isComplete: (currentIndex > 1)? true:false),
               DeliveryInfo(subTitle: S.of(context)!.deliveryDes,
                   isNext: (currentIndex == 2)? true:false,
                   title:S.of(context)!.delivery,
                   image: 'delivery.png', isComplete: (currentIndex > 2)? true:false),
               DeliveryInfo(subTitle: S.of(context)!.gotCashDes,
                   isNext: (currentIndex == 3)? true:false,
                   title:S.of(context)!.gotCash,
                   image: 'got_cash.svg', isComplete: (currentIndex > 3)? true:false),
               DeliveryInfo(subTitle: S.of(context)!.finishedDes,
                   isNext: (currentIndex == 4)? true:false,
                   title: S.of(context)!.finished,
                   image: 'finished.svg', isComplete: (currentIndex > 4)? true:false),
             ];
           }
           //return PackageDeliveryTrackingPage();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black12.withOpacity(0.1),
                    height: SizeConfig.titleSize * 6,
                    child: Center(child: Text(S.of(context)!.orderTrackingNumber+'  # '+currentOrder.customerOrderID.toString(),
                    style: GoogleFonts.lato(
                      fontSize: SizeConfig.titleSize  * 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                    ),
                    ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    //  child: StepperDemo(),
                    child:  Container(
                      width: SizeConfig.screenWidth * 0.9,
                      child: FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          color: Color(0xff989898),
                          indicatorTheme: IndicatorThemeData(
                            position: 0,
                            size: 19.0,
                          ),
                          connectorTheme: ConnectorThemeData(
                            thickness: 2.5,
                          ),
                        ),
                        builder: TimelineTileBuilder.connected(
                          indicatorBuilder: (_, index) {
                            if (items[index].isComplete) {
                              return DotIndicator(
                                size: 19,
                                color: Color(0xff66c97f),
                              );
                            } else if(items[index].isNext){
                              return DotIndicator(
                                size: 19,
                                color: Colors.indigoAccent,
                              );
                            } else{
                              return OutlinedDotIndicator(
                                size: 19,
                                borderWidth: 2.5,
                              );
                            }
                          },
                          contentsBuilder: (context,index)=>
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
                                width: SizeConfig.screenWidth * 0.8,
                                height: SizeConfig.screenHeight * 0.12,
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if(stepNumber == 5)
                                    Container(
                                      width: SizeConfig.heightMulti * 7,
                                      height:  SizeConfig.heightMulti *7,
                                      child:
                                      (index == 2)?Image.asset(icons_dir+items[index].image): SvgPicture.asset(icons_dir+items[index].image)
                                    ),
                                    if(stepNumber == 4)
                                    Container(
                                      width: SizeConfig.heightMulti * 5,
                                      height:  SizeConfig.heightMulti *5,
                                      child:
                                      (index == 2)?
                                      Image.asset(icons_dir+items[index].image):
                                      SvgPicture.asset(icons_dir+items[index].image),
                                    ),

                                    SizedBox(width: 10,),
                                    Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index].title,
                                        style: GoogleFonts.lato(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                         fontSize: SizeConfig.titleSize * 2
                                        ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(items[index].subTitle,

                                          style: GoogleFonts.lato(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizeConfig.titleSize * 1.7
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                          connectionDirection: ConnectionDirection.before,
                          connectorBuilder: (_, index, ___) {

                            return SolidLineConnector(
                              thickness: 4,
                              color: items[index-1].isComplete ? Colors.green : null,
                            );
                          },

                          itemCount: stepNumber,
                        ),


                      ),
                    ),),
                ],
              ),
            );
          }
          else if (state is OrderStatusErrorState)
            {
              return Center(child: Container(
                width: 50,
                height: 30,
                child: Text('Error'),
              ),);
            }
          else {
            return Center(child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(color: ColorsConst.mainColor,),
            ),);
          }

        }
      )
    );
  }

  _stepProgressBarIcon({required bool isActive,required bool isEnd}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.blue:Colors.grey
          ),
        ),
        SizedBox(height: 10,),
          Container(
            height: SizeConfig.heightMulti * 8,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isActive ? Colors.blue:Colors.grey
            ),
          ),
        SizedBox(height: 20,),
        if(isEnd)
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.blue:Colors.grey
            ),
          ),
      ],
    );
  }

}

class DeliveryInfo  {
  bool isComplete =false;
  bool isNext =false;
  String image;
  String title;
  String subTitle;
   DeliveryInfo({required this.title ,required this.isNext ,required this.subTitle,required this.image,required this.isComplete ,Key? key});
}


class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;


  @override
  Widget build(BuildContext context) {
    return   Expanded(
      child: Stepper(
        type: StepperType.vertical,
        physics: ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (step) => tapped(step),
        onStepContinue:  continued,
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: new Text('Account'),
            content: Column(
              children: <Widget>[

               Text('')
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Address'),
            content: Column(
              children: <Widget>[
               Text('')
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Mobile Number'),
            content: Column(
              children: <Widget>[
               Text('')
              ],
            ),
            isActive:_currentStep >= 0,
            state: _currentStep >= 2 ?
            StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 2 ?
    setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }



}


///
///

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: SizeConfig.screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Order ID')
              ),
              Divider(height: 1.0),
              Expanded(
                child: _DeliveryProcesses(processes:[
                  _DeliveryProcess('Order Placed'),
                  _DeliveryProcess('Order Confirmed'),
                  _DeliveryProcess('Order Processed')

                ]),
              ),
              Divider(height: 1.0),

            ],
          ),
        ),
      )
    );
  }
}


class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 1.0,
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,
          ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
          !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
          isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}





class _DeliveryProcess {
  const _DeliveryProcess(
      this.name, {
        this.messages = const [],
      });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}
