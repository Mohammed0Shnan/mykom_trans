import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/delivery_times.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/consts/utils_const.dart';
import 'package:my_kom/module_authorization/bloc/is_loggedin_cubit.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/ui/screens/complete_order_screen.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/module_profile/model/quick_location_model.dart';
import 'package:my_kom/module_shoping/bloc/check_address_bloc.dart';
import 'package:my_kom/module_shoping/bloc/my_addresses_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';

import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class ShopScreen extends StatefulWidget {
  ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  /// this controller for purchasing protocol (steps)
  late final _pageController;

  /// new order state management
  final NewOrderBloc _orderBloc = NewOrderBloc();

  /// controller to change the delivery address
  final TextEditingController _newAddressController =
      TextEditingController(text: '');

  /// check address state management
  /// In order to check the specified address if it is within the serviced areas
  final CheckAddressBloc _checkAddressBloc = CheckAddressBloc();

  // final PaymentMethodeNumberBloc paymentMethodeNumberBloc =
  //     PaymentMethodeNumberBloc();

  /// local storage in order to take the current storage and add it to the request
  /// sort orders
  final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();

  ///Map services in order to determine the area for the user's address
  /// if it is available within the areas served by the specified store
  final MapService _mapService = MapService();

  /// my addresses state management (add , remove)
  /// Pre-saved express delivery addresses
  final MyAddressesBloc _myAddressesBloc = MyAddressesBloc();

  /// this controller is in order to capture the name of the address that we want to save for quick access
  final TextEditingController _savedNameLocationController =
      TextEditingController();

  /// this controller is for write note
  final TextEditingController _noteController = TextEditingController();

  /// Customer phone number
  /// We get it from local storage
  /// Application registration process
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  /// To check permission to open the cart page (guests cannot view cart page)
  late final IsLogginCubit isLogginCubit;
  late String storeId;

  ///To save the source of the request (Dubai ..., etc)
  ///If an error occurred, we could not get the value stored in the device (Null)

 late String orderSource ;

  AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();

  @override
  void initState() {
    isLogginCubit = IsLogginCubit();
    _authPrefsHelper.getAddress().then((value)  {
      if (value != null) {
        addressModel = value;
        _newAddressController.text = value.description;

      }
    });
    _preferencesHelper.getCurrentStore().then((store) {
      if (store != null) {
        storeId = store;
        _authPrefsHelper.getAddress().then((address)  async{
          if (address != null) {
            LatLng latLng = LatLng(address.latitude, address.longitude);
           await _getSubAreaForAddress(latLng);
          }
        });
      }
    });

    _authPrefsHelper.getPhone().then((value) {
      _phoneController.text = value!;
    });

    ///To get the source of the request (sub area)

    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    isLogginCubit.close();
    super.dispose();
  }

  int currentIndex = 0;
  double stateAngle = 0;
  double endAngle = 0;

  /// request parameters

  /// Products we want to buy
  /// We get it from ShopCartBloc when the case is success we do attribution
  late List<ProductModel> requestProduct;

  /// This is for the subscription process
  /// Once, daily, monthly.... In our case, all requests are only once
  String deliveryTimesGroupValue = DeliveryTimesConst.ONE;

  /// Repeat order
  int numberOfMonth = 0;

  /// Delivery Address
  late AddressModel addressModel;


  /// Home Number
  final TextEditingController _buildingAndHomeNumberController =
  TextEditingController(text: '');

  ///Payment method
  late String paymentGroupValue = '';

  /// Order price
  ///  We get it from ShopCartBloc when the case is success we do attribution (total methode in block)
  late double orderValue = 0.0;

  /// card id (if payment method was credit card)
  late String cardId = '';

  /// Speed Order feature (true or false)
  late bool vipOrder = false;

  ///Added value when activating speed order
  double vipOrderValue = 0.0;

  /// Validation
  ///
  /// The delivery address is acceptable or not
  bool addressIsAccept = false;

  /// For Validation (The order completable or not)
  bool orderNotComplete = false;

  /// Snack Messages
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _destinationFormKey = GlobalKey<FormState>();

  _getSubAreaForAddress(LatLng? latLng) {
    _mapService.getSubAreaPosition(latLng).then((subArea) {
      if (subArea != null) {
        _checkAddressBloc.checkAddress(storeId, subArea);
      }
    });
  }

 Future<String> _getOrderSourceFromDeliveryLocation(LatLng latLng)async{
   return await _mapService.getOrderSource(latLng);
  }

  @override
  Widget build(BuildContext maincontext) {

    List<String> nowTitle = [
      S.of(context)!.stepOneTitle,
      S.of(context)!.stepTowTitle,
      S.of(context)!.stepThreeTitle,
    ];

    List<String> nextTitle = [
      S.of(context)!.stepOneSubTitle,
      S.of(context)!.stepTowSubTitle,
      S.of(context)!.stepThreeSubTitle,
    ];
    switch (currentIndex) {
      case 0:
        {
          stateAngle = 0;
          endAngle = pi / 2;
        }
        break;
      case 1:
        {
          stateAngle = pi / 2;
          endAngle = pi;
        }
        break;
      case 2:
        {
          stateAngle = pi;
          endAngle = 3 * pi / 2;
        }
        break;
      case 3:
        {
          stateAngle = 3 * pi / 2;
          endAngle = 2 * pi;
        }
        break;
    }
    return BlocConsumer<IsLogginCubit, IsLogginCubitState>(
        bloc: isLogginCubit,
        listener: (context, state) {
          if (state == IsLogginCubitState.NotLoggedIn)
            loginCheakAlertWidget(context);
        },
        builder: (context, state) {
          if (state == IsLogginCubitState.LoggedIn) {
            return Stack(
              children: [
                Container(
                  color: Colors.grey.shade50,
                ),
                Scaffold(
                  key: _scaffoldState,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                      Platform.isIOS? Icons.arrow_back_ios: Icons.arrow_back ,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                    elevation: 0,
                    title: Text(S.of(context)!.shoppingCart,
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  body: SafeArea(
                      child: Container(
                    child: Column(
                      children: [
                        Container(
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black12,
                                  style: BorderStyle.solid)),
                          child: Row(
                            children: [
                              TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  duration: Duration(seconds: 1),
                                  builder: (context, double value, child) {
                                    return Container(
                                        width: 72,
                                        height: 72,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Stack(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (rect) {
                                                return SweepGradient(
                                                    startAngle: stateAngle,
                                                    endAngle: endAngle,
                                                    center: Alignment.center,
                                                    stops: [
                                                      value,
                                                      value
                                                    ],
                                                    colors: [
                                                      ColorsConst.mainColor,
                                                      Colors.grey
                                                          .withOpacity(0.2)
                                                    ]).createShader(rect);
                                              },
                                              child: Container(
                                                width:
                                                    80,
                                                height:
                                                    80,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height:
                                                   45,
                                                width:
                                                   45,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Center(
                                                    child: Text(
                                                  '${currentIndex + 1} ${S.of(context)!.ofStepper} 4',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          ColorsConst.mainColor,
                                                      fontSize:12.5),
                                                )),
                                              ),
                                            )
                                          ],
                                        ));
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(nowTitle[currentIndex],
                                        style: TextStyle(
                                            color: ColorsConst.mainColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize:14)),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text('  ' + nextTitle[currentIndex],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            fontSize:11))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            controller: _pageController,
                            children: [
                              firstPage(),
                              secondPage(),
                              thirdPage(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                )
              ],
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
            );
          }
        });

  }

  Widget _buildShoppingCard(
      {required ProductModel productModel, required int quantity}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 95,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: UtilsConst.lang == 'en'
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 2))
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double h = constraints.maxHeight;
                    double w = constraints.maxWidth;

                    return Row(
                      children: [
                        Container(
                          width: w / 4,
                          //   child: Image.network(productModel.imageUrl,fit: BoxFit.contain,),
                          child: CachedNetworkImage(
                            imageUrl: productModel.imageUrl,
                            progressIndicatorBuilder: (context, l, ll) =>
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
                            errorWidget: (context, s, l) => Icon(Icons.error),
                            fit: BoxFit.fill,
                          ), // Image.asset(productModel.imageUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: w / 2.3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  UtilsConst.lang == 'en'
                                      ? productModel.title
                                      : productModel.title2,
                                  style: TextStyle(
                                      fontSize:13.5,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text('${productModel.quantity}'+' '+  UtilsConst.lang == 'en'?'pcs':'حبة', style: TextStyle(
                                    fontSize:13.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600)),
                                Text(
                                  '${productModel.price}'+'  ${ UtilsConst.lang == 'en'?'AED':'د.إ'}',
                                  style:
                                      TextStyle(color: ColorsConst.mainColor ,
                                        fontSize: 14
                                        ),
                                )
                              ]),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: h / 3,
                              width: w / 4,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black12)],
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: ColorsConst.mainColor,
                                        width: SizeConfig.widhtMulti * 8,
                                        child: IconButton(
                                            onPressed: () {
                                              shopCartBloc
                                                  .removeProductFromCart(
                                                      productModel);
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: SizeConfig.imageSize * 5,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Container(
                                        child: Text(quantity.toString()),
                                      ),
                                      Container(
                                        width: SizeConfig.widhtMulti * 8,
                                        alignment: Alignment.center,
                                        color: ColorsConst.mainColor,
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                shopCartBloc.addProductToCart(
                                                    productModel);
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: SizeConfig.imageSize * 5,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget firstPage() {

    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: BlocBuilder<ShopCartBloc, CartState>(
              bloc: shopCartBloc,
              builder: (context, state) {
                if (state is CartLoading) {
                  return CircularProgressIndicator();
                } else if (state is CartLoaded) {
                  requestProduct = state.cart.products;
                  if (requestProduct.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        Container(
                          height: SizeConfig.screenHeight * 0.3,
                          width: SizeConfig.screenWidth * 0.4,
                          child: Image.asset('assets/empty_cart.jpg'),
                        ),

                        Text(
                          S.of(context)!.emptyShip,
                          style: GoogleFonts.lato(
                              color: Colors.black45,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ));
                  } else
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.cart
                            .productQuantity(state.cart.products)
                            .keys
                            .length,
                        itemBuilder: (context, index) {
                          return _buildShoppingCard(
                              productModel: state.cart
                                  .productQuantity(state.cart.products)
                                  .keys
                                  .elementAt(index),
                              quantity: state.cart
                                  .productQuantity(state.cart.products)
                                  .values
                                  .elementAt(index));
                        });
                } else {
                  return Container(
                      child: Center(
                    child: Text('Error in Load Items'),
                  ));
                }
              }),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, color: Colors.black38, thickness: 1),
              SizedBox(
                height: 8,
              ),
              Text(S.of(context)!.paymentSummary,
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87)),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context)!.total,
                    style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54),
                  ),
                  BlocBuilder<ShopCartBloc, CartState>(
                      bloc: shopCartBloc,
                      builder: (context, state) {
                        if (state is CartLoaded) {
                          return Text(state.cart.totalString,
                              style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54));
                        } else {
                          return Text('',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14));
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ShopCartBloc, CartState>(
                  bloc: shopCartBloc,
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      if (!state.cart.minimum()) {
                        return Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.widhtMulti * 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.shade50,
                            ),
                            child: Center(
                                child: Text(
                                    '${S.of(context)!.minimumAlert}  ${state.cart.minimum_pursh}  AED ',
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.red))));
                      } else
                        return Container();
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
        Container(
          height: 35,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: ColorsConst.mainColor, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            NavigatorRoutes.NAVIGATOR_SCREEN, (route) => false);
                      },
                      child: Text(
                        S.of(context)!.addMore,
                        style: TextStyle(
                            color: ColorsConst.mainColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.widhtMulti * 3,
              ),
              Expanded(
                  child: Material(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: ColorsConst.mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease);
                    },
                    child: Text(
                      S.of(context)!.next,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget secondPage() {
    final node = FocusScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),

              ///  Address
              ///

              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(8),
                height: 160,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: Colors.black38
                    // ),
                    boxShadow: [
                      BoxShadow(offset: Offset(0, -1), color: Colors.black12),
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0, 1),
                          color: Colors.black26)
                    ]),
                child: Form(
                  key: _destinationFormKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 25.0,
                                width: 25.0,
                                padding: EdgeInsets.all(2),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(width: 2, color: Colors.blue)),
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/address_delivery_icon.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                S.of(context)!.destination,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    fontSize: 13),
                              ),
                              SizedBox(width: 20,),
                              Text(
                                '( ${S.of(context)!.required} )',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontSize:13),
                              )
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                _myAddressesBloc.getLocations();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          content: Container(
                                            height: 120.0,
                                            width: SizeConfig.screenWidth,
                                            child: Center(
                                                child: Column(
                                              children: [
                                                Expanded(
                                                  child:
                                                      BlocBuilder<MyAddressesBloc,
                                                              MyAddressesStates>(
                                                          bloc: _myAddressesBloc,
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                is MyAddressesSuccessState) {
                                                              List<QuickLocationModel>
                                                                  data =
                                                                  state.list;
                                                              if (data.isEmpty)
                                                                return Center(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .bookmark,
                                                                        color: Colors
                                                                            .blue,
                                                                        size: 22,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 8,
                                                                      ),
                                                                      Text(
                                                                        S
                                                                            .of(context)!
                                                                            .nextTimeBookMark,
                                                                        style: GoogleFonts.lato(
                                                                            color: Colors
                                                                                .black87,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:13),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              else
                                                                return ListView
                                                                    .separated(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            data
                                                                                .length,
                                                                        separatorBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return Divider(
                                                                            color:
                                                                                Colors.black87,
                                                                          );
                                                                        },
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              addressModel =
                                                                                  data[index].address;
                                                                              _newAddressController.text = S.of(context)!.to +
                                                                                  ' ' +
                                                                                  data[index].display;
                                                                              LatLng
                                                                                  latLang =
                                                                                  LatLng(addressModel.latitude, addressModel.longitude);
                                                                              _getSubAreaForAddress(latLang);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height:
                                                                                  35,
                                                                              child:
                                                                                  Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.bookmark_outline,
                                                                                    color: Colors.blue,
                                                                                    size: 16,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    data[index].display,
                                                                                    style: GoogleFonts.lato(fontSize: 15, color: Colors.black),
                                                                                  ),
                                                                                  Spacer(),
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        EasyLoading.show(status: S.of(context)!.pleaseWait);
                                                                                        _myAddressesBloc.removeLocation(data[index].id).then((value) {
                                                                                          EasyLoading.showError(S.of(context)!.removed);
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        S.of(context)!.remove,
                                                                                        style: TextStyle( color: Colors.blue, fontSize: 12),
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        });
                                                            } else if (state
                                                                is MyAddressesErrorState) {
                                                              return Center(
                                                                  child:
                                                                      Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(10),
                                                                child: Text(S
                                                                    .of(context)!
                                                                    .errorLoadLocation),
                                                              ));
                                                            } else
                                                              return Center(
                                                                child: Container(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              );
                                                          }),
                                                ),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                                context,
                                                                MapRoutes
                                                                    .MAP_SCREEN,
                                                                arguments: false)
                                                            .then((value) {
                                                          if (value != null) {
                                                            addressModel = (value
                                                                as AddressModel);
                                                            _newAddressController
                                                                    .text =
                                                                addressModel
                                                                    .description;
                                                            addressModel = value;

                                                            /// Check Address
                                                            ///

                                                            LatLng latlang = LatLng(
                                                                addressModel
                                                                    .latitude,
                                                                addressModel
                                                                    .longitude);
                                                            _getSubAreaForAddress(
                                                                latlang);
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                          S
                                                              .of(context)!
                                                              .anotherAddress,
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.blue,
                                                              fontSize: 13.0)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Text(S.of(context)!.change,style: TextStyle(fontSize: 11.0),))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${S.of(context)!.street} :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 11.0),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 15,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _newAddressController,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                                          border: InputBorder.none,
                                          //S.of(context).name,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        // Move focus to next
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: 25.0,
                                    width: 25.0,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: BlocBuilder<CheckAddressBloc,
                                            CheckAddressStates>(
                                        bloc: _checkAddressBloc,
                                        builder: (context, state) {
                                          if (state is CheckAddressLoadingState)
                                            return Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: CupertinoActivityIndicator()
                                            );
                                          else if (state
                                              is CheckAddressErrorState) {
                                            return Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                )));
                                          } else if (state
                                              is CheckAddressSuccessState) {
                                            return Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 15,
                                                ));
                                            return Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      /// Building And Home Number
                      SizedBox(
                        height: 15,
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_outlined,
                              color: Colors.blue,
                              size: 13.0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${S.of(context)!.buildingOrHomeNumber} :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 11.0),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _buildingAndHomeNumberController,
                                cursorHeight: 15,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                                onChanged: (v){setState((){});},
                                onEditingComplete: ()=>node.nextFocus(),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  suffixIcon: Icon(
                                    Icons.edit,
                                    color:_buildingAndHomeNumberController.text.isNotEmpty ? Colors.blue:Colors.red,
                                    size: 13.0,
                                  ),


                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:_buildingAndHomeNumberController.text.isNotEmpty ? Colors.blue:Colors.red,)
                                    ),

                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)
                                    ),

                                  hintText: S.of(context)!.buildingOrHomeNumberHint,
                                  hintStyle: TextStyle(color:Colors.black38)
                                  //S.of(context).name,
                                ),
                                // validator: (_h){
                                //   if(_h!.isEmpty)return '';
                                //   else return null;
                                // },
                                textInputAction: TextInputAction.done,
                                // Move focus to next
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      /// Phone Number Section
                      SizedBox(
                        height: 15,
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color:Colors.blue,
                              size: 13.0,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${S.of(context)!.phone} :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 11.0),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                cursorHeight: 15,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                                onChanged: (v){setState((){});},
                                onEditingComplete: ()=>node.unfocus(),
                                decoration: InputDecoration(
                                  isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                                  suffixIcon: Icon(
                                    Icons.edit,
                                    color: _phoneController.text.isNotEmpty ? Colors.blue:Colors.red,
                                    size: 13.0,
                                  ),

                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: _phoneController.text.isNotEmpty ? Colors.black12:Colors.red,)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)
                                    ),

                                    hintText: UtilsConst.lang == 'en' ? 'enter phone number':'أدخل رقم الهاتف'
                                    ,hintStyle: TextStyle(color:Colors.black38)
                                  //S.of(context).name,
                                ),
                                // validator: (_p){
                                //   if(_p!.isEmpty)return '';
                                //   else return null;
                                // },
                                textInputAction: TextInputAction.done,
                                // Move focus to next
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),


              ///  Address Worn
              BlocConsumer<CheckAddressBloc, CheckAddressStates>(
                  bloc: _checkAddressBloc,
                  listener: (context, listenerCheckAddState) {
                    if (listenerCheckAddState is CheckAddressSuccessState) {
                      if (listenerCheckAddState.saved) {
                        EasyLoading.showSuccess(
                            S.of(context)!.successSaveLocation);
                        _newAddressController.text = S.of(context)!.to +
                            ' ' +
                            _savedNameLocationController.text.trim();
                        _savedNameLocationController.clear();
                      }
                    } else if (listenerCheckAddState
                        is CheckAddressErrorState) {
                      EasyLoading.showError(S.of(context)!.errorSaveLocation);
                    }
                  },
                  builder: (context, state) {
                    if (state is CheckAddressErrorState) {
                      return Container(
                          height: 24.0,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(left:  SizeConfig.widhtMulti * 5 , right:   SizeConfig.widhtMulti * 5 , top: 8),

                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red.shade50,
                          ),
                          child: Center(
                              child: Text(S.of(context)!.destinationAlert,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.red))));
                    } else if (state is CheckAddressSuccessState) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: MaterialButton(
                          height: 20.0,
                            elevation: 1,
                            onPressed: () {
                              /// Save Location
                              if (!state.saved) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          content: Container(
                                            height:100,
                                            width: SizeConfig.screenWidth,
                                            child: Center(
                                                child: Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(

                                                    child: TextField(
                                                      controller:
                                                          _savedNameLocationController,
                                                      style: TextStyle(
                                                          fontSize: 14),

                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.all(12),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                          ),
                                                          hintText: S
                                                              .of(context)!
                                                              .hintTextBookMarkField,
                                                          hintStyle: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black38)),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (_savedNameLocationController
                                                            .text.isEmpty) {
                                                          Fluttertoast.showToast(
                                                              msg: S
                                                                  .of(context)!
                                                                  .nameBookMark,
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              textColor:
                                                                  Colors.black,
                                                              fontSize: 12.0);
                                                        } else {
                                                          AddressModel
                                                              _address =
                                                              addressModel;
                                                          String
                                                              location_display_name =
                                                              _savedNameLocationController
                                                                  .text
                                                                  .trim();
                                                          QuickLocationModel
                                                              quickLocationModel =
                                                              QuickLocationModel(
                                                                  id: '',
                                                                  address:
                                                                      _address,
                                                                  display:
                                                                      location_display_name);
                                                          Navigator.pop(
                                                              context);
                                                          EasyLoading.show(
                                                              status: S
                                                                  .of(context)!
                                                                  .pleaseWaitForSaveLocation);
                                                          _checkAddressBloc
                                                              .saveAddress(
                                                                  quickLocationModel);
                                                        }
                                                      },
                                                      child: Text(
                                                          S
                                                              .of(context)!
                                                              .mapSave,
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            },
                            color: Colors.green.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    state.saved
                                        ? S.of(context)!.afterSaveLocation
                                        : S.of(context)!.saveAnotherAddress,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.green)),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  state.saved
                                      ? Icons.check
                                      : Icons.bookmark_outline,
                                  color: Colors.green,
                                  size: 17,
                                ),
                              ],
                            ))),
                      );
                    } else {
                      return Container();
                    }
                  }),
              SizedBox(
                height: 10,
              ),

              /// Order Type
              FutureBuilder<bool>(
                  future: _preferencesHelper.getVipStore(),
                  builder: (context, AsyncSnapshot<bool> s) {
                    if (s.hasData) {
                      bool res = s.data!;
                      if (s.data == null) {
                        return SizedBox.shrink();
                      } else if (res) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.all(8),
                          height: 130.0,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              //  border: Border.all(
                              //   color: Colors.black38,
                              // ),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, -1),
                                    color: Colors.black12),
                                BoxShadow(
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                    color: Colors.black38)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 25.0,
                                    width: 25.0,
                                    padding: EdgeInsets.all(2),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/icons/order_type_icon.png',
                                            ),
                                            fit: BoxFit.contain),
                                        border: Border.all(
                                            width: 2, color: Colors.blue)),
                                    // child: Container(
                                    //     child: Image.asset('assets/summary_shopping.png')),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(S.of(context)!.myKomExpressService,
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87)),
                                  SizedBox(width: 20,),
                                  Text(
                                    '( ${S.of(context)!.optional} )',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize:13),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                S.of(context)!.myKomExpressServiceMessageEnable,
                                style: GoogleFonts.lato(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context)!.myKomExpress,
                                    style: GoogleFonts.lato(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    child: FlutterSwitch(
                                      activeColor: ColorsConst.mainColor,

                                      width: 60,
                                      height:20.0,
                                      valueFontSize: 12.0,
                                      toggleSize: 20.0,
                                      value: vipOrder,
                                      borderRadius: 30.0,
                                      padding: 1,
                                      showOnOff: true,
                                      onToggle: (val) {
                                              setState(() {
                                                vipOrder = val;
                                                if (vipOrder) {
                                                  vipOrderValue = 10.0;
                                                } else {
                                                  vipOrderValue = 0.0;
                                                }
                                              });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.all(8),
                          height: 100.0,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height:25.0,
                                    width: 25.0,
                                    clipBehavior: Clip.antiAlias,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/icons/order_type_icon.png',
                                            ),
                                            colorFilter: ColorFilter.mode(
                                                Colors.grey, BlendMode.color),
                                            fit: BoxFit.contain),
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),

                                    // child: Container(
                                    //     child: Image.asset('assets/summary_shopping.png')),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(S.of(context)!.myKomExpressService,
                                      style: GoogleFonts.lato(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54)),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                S
                                    .of(context)!
                                    .myKomExpressServiceMessageDisable,
                                style: GoogleFonts.lato(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context)!.myKomExpress,
                                    style: GoogleFonts.lato(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    child: FlutterSwitch(
                                      disabled: true,
                                      width: 60,
                                      height:20.0,
                                      valueFontSize: 12.0,
                                      toggleSize: 20.0,
                                      value: vipOrder,
                                      borderRadius: 30.0,
                                      padding: 1,
                                      showOnOff: true,

                                      onToggle: (val) {

                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Container(
                          height: 40,
                          width: double.infinity,
                          child: Text('Error in load data'));
                    }
                  }),
              SizedBox(
                height: 16,
              ),

              /// Note
              Container(

                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(8),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: Colors.black38
                    // ),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -1),
                          color: Colors.black12),
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0, 1),
                          color: Colors.black38)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 25.0,
                          width: 25.0,
                          padding: EdgeInsets.all(2),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: Colors.blue)),
                          child: Container(
                              padding: EdgeInsets.all(4),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.note_add,
                                color: Colors.blue,
                                size: 11.0,
                              ))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.of(context)!.note,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              fontSize:13),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          '( ${S.of(context)!.optional} )',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize:13),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _noteController,
                      minLines: 2,
                      maxLines: 4,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: S.of(context)!.noteMessage,

                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black26,fontSize: 11)
                          //S.of(context).name,
                          ),

                      textInputAction: TextInputAction.done,
                      // Move focus to next
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        )),
        Container(
          height: 35,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: ColorsConst.mainColor, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      currentIndex--;
                      _pageController.animateToPage(
                        currentIndex,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      S.of(context)!.back,
                      style: TextStyle(
                          color: ColorsConst.mainColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.widhtMulti * 3,
              ),
              Expanded(
                  child: Material(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: ColorsConst.mainColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      // if (_pageController.page == 3) {
                      //   _pageController.nextPage(
                      //       duration: Duration(milliseconds: 200),
                      //       curve: Curves.ease);
                      // }
                      //   else {
                      if(_buildingAndHomeNumberController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty){
                        node.unfocus();
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease);
                      }



                      else
                        _scaffoldState.currentState!
                            .showSnackBar(SnackBar(
                            content: Text(S
                                .of(context)!
                                .requiredCartFieldMessage)));
                      // }
                    },
                    child: Text(
                      S.of(context)!.next,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ],
    );
  }

  Widget thirdPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),

              /// Payment Summary
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(8),
                height: 130.0,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    //  border: Border.all(
                    //   color: Colors.black38,
                    // ),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -1),
                          color: Colors.black12),
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0, 1),
                          color: Colors.black38)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2)),
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            margin: EdgeInsets.all(2),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/summary_Icon.png'),
                                  fit: BoxFit.contain),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(S.of(context)!.paymentSummary,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87)),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context)!.total,
                          style: GoogleFonts.lato(
                              fontSize:11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),
                        ),
                        BlocBuilder<ShopCartBloc, CartState>(
                            bloc: shopCartBloc,
                            builder: (context, state) {
                              if (state is CartLoaded) {
                                return Text('${state.cart.totalString}  ${UtilsConst.lang == 'en'? 'AED':'د.إ'}' ,
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54));
                              } else {
                                return Text('',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize:11));
                              }
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context)!.extraCharge,
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),
                        ),
                        BlocBuilder<ShopCartBloc, CartState>(
                            bloc: shopCartBloc,
                            builder: (context, state) {
                              if (state is CartLoaded) {
                                return Text('${vipOrderValue.toString()}  ${UtilsConst.lang == 'en'? 'AED':'د.إ'}',
                                    style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54));
                              } else {
                                return Text('',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 11));
                              }
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context)!.orderValue,
                          style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),
                        ),
                        BlocBuilder<ShopCartBloc, CartState>(
                            bloc: shopCartBloc,
                            builder: (context, state) {
                              if (state is CartLoaded) {
                                //double total = state.cart.deliveryFee(state.cart.subTotal)+ state.cart.subTotal;
                                double total =
                                    vipOrderValue + state.cart.subTotal;

                                orderValue = total;
                                return Text('${total.toString()}  ${ UtilsConst.lang == 'en'?'AED':'د.إ'}',
                                    style: GoogleFonts.lato(
                                        fontSize:11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54));
                              } else {
                                return Text('',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 11));
                              }
                            }),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 8,
              ),

              /// Payment Summary Worn
              ///
              BlocBuilder<ShopCartBloc, CartState>(
                  bloc: shopCartBloc,
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      if (!state.cart.minimum()) {
                        orderNotComplete = true;
                        return Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.widhtMulti * 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.shade50,
                            ),
                            child: Center(
                                child: Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.widhtMulti * 5),
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red.shade50,
                                    ),
                                    child: Center(
                                        child: Text(
                                            '${S.of(context)!.minimumAlert}  ${state.cart.minimum_pursh} ${ UtilsConst.lang == 'en'?'AED':'د.إ'} ',
                                            style: GoogleFonts.lato(
                                                fontSize:11.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.red))))));
                      } else
                        return Container();
                    } else {
                      return Container();
                    }
                  }),

              SizedBox(
                height: 8,
              ),

              /// Payment Method
              ///
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(8),
                height: 140.0,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(
                    //     color: Colors.black38
                    // ),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -1),
                          color: Colors.black12),
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0,1),
                          color: Colors.black38)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 25.0,
                          width: 25.0,
                          padding: EdgeInsets.all(2),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/payment_methods_icon.png')),
                              border: Border.all(width: 2, color: Colors.blue)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(S.of(context)!.paymentMethods,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentGroupValue = PaymentMethodConst.CASH_MONEY;
                            });
                          },
                          child: Material(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: paymentGroupValue ==
                                    PaymentMethodConst.CASH_MONEY
                                ? 5
                                : 0,
                            child: Container(
                              width: SizeConfig.screenWidth * 0.24,
                              height:80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: paymentGroupValue ==
                                          PaymentMethodConst.CASH_MONEY
                                      ? Colors.blue.shade200
                                      : Colors.white,
                                  border: Border.all(color: Colors.black12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                   width: SizeConfig.screenWidth * 0.24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: paymentGroupValue ==
                                                PaymentMethodConst.CREDIT_CARD
                                            ? DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/money_icon.png',
                                                ),
                                                colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.color))
                                            : DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/money_icon.png',
                                                ),
                                              )),
                                  ),
                                  Center(
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 4.0,vertical: 8.0),
                                        child: Text(
                                         S.of(context)!.cashMoney,
                                          style: GoogleFonts.lato(

                                              color: paymentGroupValue ==
                                                      PaymentMethodConst
                                                          .CASH_MONEY
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize:10,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.1,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentGroupValue =
                                  PaymentMethodConst.CREDIT_CARD;
                            });
                          },
                          child: Material(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: paymentGroupValue ==
                                    PaymentMethodConst.CREDIT_CARD
                                ? 5
                                : 0,
                            child: Container(
                              width: SizeConfig.screenWidth * 0.24,
                              height:80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: paymentGroupValue ==
                                          PaymentMethodConst.CREDIT_CARD
                                      ? Colors.blue.shade200
                                      : Colors.white,
                                  border: Border.all(color: Colors.black12)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                    width: SizeConfig.screenWidth * 0.24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: paymentGroupValue ==
                                                PaymentMethodConst.CASH_MONEY
                                            ? DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/card_icon.png',
                                                ),
                                                colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.color))
                                            : DecorationImage(
                                                image: AssetImage(
                                                  'assets/icons/card_icon.png',
                                                ),
                                              )),
                                  ),
                                  Center(
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 4.0,vertical: 8.0),
                                        child: Text(
                                          S.of(context)!.creditCard,
                                          style: GoogleFonts.lato(
                                              color: paymentGroupValue ==
                                                      PaymentMethodConst
                                                          .CREDIT_CARD
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize:
                                                 10,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),
            ],
          ),
        )),
        Container(
          height:35,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: ColorsConst.mainColor, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      currentIndex--;
                      _pageController.animateToPage(
                        currentIndex,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      S.of(context)!.back,
                      style: TextStyle(
                          color: ColorsConst.mainColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.widhtMulti * 3,
              ),
              Expanded(
                  child: Container(
                    height: 35.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: ColorsConst.mainColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: BlocConsumer<NewOrderBloc, CreateOrderStates>(
                          bloc: _orderBloc,
                          listener: (context, state) async {
                            if (state is CreateOrderSuccessState) {
                              snackBarSuccessWidget(context,
                                  S.of(context)!.orderAddedSuccessfully);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompleteOrderScreen(
                                          orderId: state.data.id)),
                                  (route) => false);
                              Future.delayed(Duration(milliseconds: 500), () {
                                shopCartBloc.startedShop();
                              });
                            } else if (state is CreateOrderErrorState) {
                              snackBarSuccessWidget(
                                  context, S.of(context)!.orderWasNotAdded);
                            }
                          },
                          builder: (context, state) {
                            bool isLoading =
                                state is CreateOrderLoadingState ? true : false;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              clipBehavior: Clip.antiAlias,
                              height: 35,
                              width:
                                  isLoading ? 60 : SizeConfig.screenWidth * 0.8,
                              padding: EdgeInsets.all(isLoading ? 8 : 0),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: ColorsConst.mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: isLoading
                                  ? Center(
                                      child: Container(
                                      height:20,
                                      width: 20,
                                      child:Platform.isIOS? CupertinoActivityIndicator(): CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ))
                                  : MaterialButton(
                                      onPressed: () async {
                                        if (orderNotComplete) {
                                          _scaffoldState.currentState!
                                              .showSnackBar(SnackBar(
                                                  content: Text(S
                                                      .of(context)!
                                                      .completeTheOrder)));
                                        } else if (!(_checkAddressBloc.state
                                            is CheckAddressSuccessState)) {
                                          _scaffoldState.currentState!
                                              .showSnackBar(SnackBar(
                                                  content: Text(S
                                                      .of(context)!
                                                      .destinationAlert)));
                                        } else if (paymentGroupValue == '') {
                                          _scaffoldState.currentState!
                                              .showSnackBar(SnackBar(
                                                  content: Text(S
                                                      .of(context)!
                                                      .paymentMethodAlert)));
                                        } else if (paymentGroupValue ==
                                            PaymentMethodConst.CREDIT_CARD) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  child: AlertDialog(
                                                    backgroundColor: Colors
                                                        .white
                                                        .withOpacity(0.8),
                                                    clipBehavior:
                                                    Clip.antiAlias,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                    ),
                                                    content: Container(
                                                      height: 70,
                                                      width: 90,
                                                      child: Center(
                                                        child: Text(
                                                          S
                                                              .of(context)!
                                                              .creditComingSoon,
                                                          style:
                                                          GoogleFonts.acme(
                                                              color: Colors
                                                                  .green,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                          //       /// For Credits Cards
        //
        // showMaterialModalBottomSheet(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
        //         topRight: Radius.circular(30)
        //     ),
        //   ),
        //   context: context,
        //   builder: (context) => SingleChildScrollView(
        //     controller: ModalScrollController.of(context),
        //     child: BlocBuilder<PaymentMethodeNumberBloc,PaymentState>(
        //         bloc: paymentMethodeNumberBloc,
        //         builder: (context,state) {
        //           return Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10),
        //             height: SizeConfig.screenHeight * 0.8 ,
        //             clipBehavior: Clip.antiAlias,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
        //                   topRight: Radius.circular(30)
        //               ),
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 IconButton(onPressed: (){
        //                   Navigator.of(context).pop();
        //                 }, icon:Icon(Icons.clear) ),
        //                 Text(S.of(context)!.payByCard , style:TextStyle(
        //
        //                     color: Colors.black54,
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: SizeConfig.titleSize*2.9
        //
        //                 ),),
        //                 SizedBox(height: 15,),
        //                 Container(
        //                   margin: EdgeInsets.symmetric(horizontal: 20),
        //
        //                   child: ListView.separated(
        //                     separatorBuilder: (context,index){
        //                       return  SizedBox(height: 8,);
        //                     },
        //                     shrinkWrap:true ,
        //                     itemCount: state.cards.length,
        //                     itemBuilder: (context,index){
        //                       CardModel  card =   state.cards[index];
        //                       return   Center(
        //                         child: Container(
        //                           width: double.infinity,
        //                           height: 6.8 * SizeConfig.heightMulti,
        //                           decoration: BoxDecoration(
        //                               borderRadius: BorderRadius.circular(10),
        //                               color: Colors.grey.shade50,
        //                               border: Border.all(
        //                                   color: Colors.black26,
        //                                   width: 2
        //                               )
        //                           ),
        //                           child: Row(
        //                             mainAxisSize: MainAxisSize.min,
        //
        //                             children: [
        //                               Radio<String>(
        //                                 value: card.id,
        //                                 groupValue: paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue,
        //                                 onChanged: (value) {
        //                                   paymentMethodeNumberBloc.changeSelect(value!);
        //                                 },
        //                                 activeColor: Colors.green,
        //                               ),
        //                               Icon(Icons.payment),
        //                               SizedBox(width: 10,),
        //
        //                               Text(card.cardNumber , style: GoogleFonts.lato(
        //                                   color: Colors.black54,
        //                                   fontSize: SizeConfig.titleSize * 2.1,
        //                                   fontWeight: FontWeight.bold
        //                               ),),
        //                               Spacer(),
        //                               IconButton(onPressed: (){
        //                                 paymentMethodeNumberBloc.removeOne(state.cards[index]);
        //                               }, icon: Icon(Icons.delete,color: Colors.red,)),
        //
        //                             ],
        //                           ),
        //                         ),
        //                       );
        //
        //                     },
        //
        //                   ),
        //                 ),
        //                 SizedBox(height:25,),
        //                 Center(
        //                   child: GestureDetector(
        //                     onTap: ()async{
        //                     // await PaymentService().createPaymentMethod();
        //                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>
        //                       //     BlocProvider.value(
        //                       //         value: paymentMethodeNumberBloc,
        //                       //         child: AddCardScreen())
        //                       // ));
        //                       //  paymentMethodeNumberBloc.addOne();
        //                     },
        //                     child: Container(
        //                       margin: EdgeInsets.symmetric(horizontal: 20),
        //
        //                       width: SizeConfig.screenWidth ,
        //                       height: 35,
        //                       decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.circular(10),
        //                           color: Colors.grey.shade50,
        //                           border: Border.all(
        //                               color: Colors.black26,
        //                               width: 2
        //                           )
        //                       ),
        //                       child: Row(
        //                         mainAxisSize: MainAxisSize.min,
        //
        //                         children: [
        //
        //                           Icon(Icons.add),
        //                           SizedBox(width: 10,),
        //
        //                           Text(S.of(context)!.addCard, style: GoogleFonts.lato(
        //                               color: Colors.black54,
        //                               fontSize: SizeConfig.titleSize * 2.6,
        //                               fontWeight: FontWeight.bold
        //                           )
        //                             ,)
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Spacer(),
        //                 Center(
        //                   child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
        //                       bloc: _orderBloc,
        //                       listener: (context,state)async{
        //                         if(state is CreateOrderSuccessState)
        //                         {
        //                           snackBarSuccessWidget(context, S.of(context)!.orderAddedSuccessfully);
        //                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CompleteOrderScreen(orderId: state.data.id)),(route)=>false);
        //                           shopCartBloc.startedShop();
        //                         }
        //                         else if(state is CreateOrderErrorState)
        //                         {
        //                           snackBarSuccessWidget(context, S.of(context)!.orderWasNotAdded);
        //                         }
        //                       },
        //                       builder: (context,state) {
        //                         bool isLoading = state is CreateOrderLoadingState?true:false;
        //                         return AnimatedContainer(
        //                           duration: Duration(milliseconds: 200),
        //                           clipBehavior: Clip.antiAlias,
        //                           height: 8.44 * SizeConfig.heightMulti,
        //                           width:isLoading?60: SizeConfig.screenWidth * 0.8,
        //                           padding: EdgeInsets.all(isLoading?8:0 ),
        //                           margin: EdgeInsets.symmetric(horizontal: 20),
        //                           decoration: BoxDecoration(
        //                               color: ColorsConst.mainColor,
        //                               borderRadius: BorderRadius.circular(10)
        //                           ),
        //                           child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
        //                             onPressed: ()  {
        //                               cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
        //                               if(cardId ==''){
        //                                 Fluttertoast.showToast(
        //                                     msg: S.of(context)!.selectCardAlert,
        //                                     toastLength: Toast.LENGTH_LONG,
        //                                     gravity: ToastGravity.TOP,
        //                                     timeInSecForIosWeb: 1,
        //                                     backgroundColor: Colors.white,
        //                                     textColor: Colors.black,
        //                                     fontSize: 18.0
        //                                 );
        //                               }
        //                               else{
        //                                 GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
        //                                // _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
        //
        //                               }
        //
        //                             },
        //                             child: Text(S.of(context)!.orderConfirmation, style: TextStyle(color: Colors.white,
        //                                 fontSize: SizeConfig.titleSize * 2.7),),
        //
        //                           ),
        //                         );
        //                       }
        //                   ),
        //                 ),
        //                 SizedBox(height: SizeConfig.screenHeight * 0.05,)
        //               ],
        //             ),
        //           );
        //         }
        //     ),
        //   ),
        // );
      // }


                                          // // GeoJson geoJson = GeoJson(
                                          // //     lat: addressModel.latitude,
                                          // //     lon: addressModel.longitude);
                                          // // _orderBloc.addNewOrder(
                                          // //     product: requestProduct,
                                          // //     deliveryTimes:
                                          // //         deliveryTimesGroupValue,
                                          // //     orderType: vipOrder,
                                          // //     destination: geoJson,
                                          // //     addressName:
                                          // //         addressModel.description,
                                          // //     phoneNumber: phoneNumber,
                                          // //     paymentMethod: paymentGroupValue,
                                          // //     numberOfMonth: numberOfMonth,
                                          // //     orderValue: orderValue,
                                          // //     cardId: cardId,
                                          // // storeId: storeId);

                                         else {

                                          GeoJson geoJson = GeoJson(
                                              lat: addressModel.latitude,
                                              lon: addressModel.longitude);

                                          /// Here we fetch the current region of the specified address to find out the source of the request
                                        orderSource = await _getOrderSourceFromDeliveryLocation(LatLng(addressModel.latitude, addressModel.longitude));

                                        String _address_name = addressModel.description ;
                                          _orderBloc.addNewOrder(
                                              product: requestProduct,
                                              deliveryTimes:
                                                  deliveryTimesGroupValue,
                                              orderType: vipOrder,
                                              destination: geoJson,
                                              addressName:
                                              _address_name,
                                              phoneNumber:
                                                  _phoneController.text.trim(),
                                              paymentMethod: paymentGroupValue,
                                              numberOfMonth: numberOfMonth,
                                              orderValue: orderValue,
                                              cardId: cardId,
                                              storeId: storeId,
                                              note: _noteController.text.trim(),
                                              orderSource: orderSource,
                                              buildingHomeId : _buildingAndHomeNumberController.text.trim(),
                                          );
                                        }
                                      },
                                      child: Text(
                                        S.of(context)!.orderConfirmation,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize:16),
                                      ),
                                    ),
                            );
                          }))),
            ],
          ),
        ),
      ],
    );
  }

  String _getNameOfDay(int d) {
    int day = 0;
    if (d < 8) {
      day = d;
    } else {
      day = (d / 7).floor();
    }
    String name = '';
    switch (day) {
      case 1:
        {
          name = 'Sunday';
        }
        break;
      case 2:
        {
          name = 'Monday';
        }
        break;
      case 3:
        {
          name = 'Tuesday';
        }
        break;
      case 4:
        {
          name = 'Wednesday';
        }
        break;
      case 5:
        {
          name = 'Thursday';
        }
        break;
      case 6:
        {
          name = 'Friday';
        }
        break;
      case 7:
        {
          name = 'Saturday';
        }
    }
    return name;
  }
}

// class AddCardScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return AddCardScreenState();
//   }
// }
//
// class AddCardScreenState extends State<AddCardScreen> {
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   bool useGlassMorphism = false;
//   bool useBackgroundImage = false;
//   OutlineInputBorder? border;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final AuthService authService = AuthService();
//
//   @override
//   void initState() {
//     border = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(0.7),
//         width: 2.0,
//       ),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Credit Card View Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           decoration: BoxDecoration(
//             // image: !useBackgroundImage
//             //     ? const DecorationImage(
//             //   image: ExactAssetImage('assets/bg.png'),
//             //   fit: BoxFit.fill,
//             // )
//             //     : null,
//             color: Colors.white,
//           ),
//           child: SafeArea(
//             child: Column(
//               children: <Widget>[
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 // CreditCardWidget(
//                 //   glassmorphismConfig:
//                 //       useGlassMorphism ? Glassmorphism.defaultConfig() : null,
//                 //   cardNumber: cardNumber,
//                 //   expiryDate: expiryDate,
//                 //   cardHolderName: cardHolderName,
//                 //   cvvCode: cvvCode,
//                 //   showBackView: isCvvFocused,
//                 //   obscureCardNumber: true,
//                 //   obscureCardCvv: true,
//                 //   isHolderNameVisible: true,
//                 //   cardBgColor: Colors.red,
//                 //   // backgroundImage:
//                 //   // useBackgroundImage ? 'assets/card_bg.png' : null,
//                 //   isSwipeGestureEnabled: true,
//                 //   onCreditCardWidgetChange:
//                 //       (CreditCardBrand creditCardBrand) {},
//                 //   customCardTypeIcons: <CustomCardTypeIcon>[
//                 //     CustomCardTypeIcon(
//                 //       cardType: CardType.mastercard,
//                 //       cardImage: Image.asset(
//                 //         'assets/mastercard.png',
//                 //         height: 48,
//                 //         width: 48,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: <Widget>[
//                         // CreditCardForm(
//                         //   formKey: formKey,
//                         //   obscureCvv: true,
//                         //   obscureNumber: true,
//                         //   cardNumber: cardNumber,
//                         //   cvvCode: cvvCode,
//                         //   isHolderNameVisible: true,
//                         //   isCardNumberVisible: true,
//                         //   isExpiryDateVisible: true,
//                         //   cardHolderName: cardHolderName,
//                         //   expiryDate: expiryDate,
//                         //   themeColor: Colors.blue,
//                         //   textColor: Colors.black45,
//                         //   cardNumberDecoration: InputDecoration(
//                         //     border: OutlineInputBorder(
//                         //         borderRadius: BorderRadius.circular(10)),
//                         //     labelText: 'Number',
//                         //     hintText: 'XXXX XXXX XXXX XXXX',
//                         //     hintStyle: const TextStyle(color: Colors.black45),
//                         //     labelStyle: const TextStyle(color: Colors.black45),
//                         //     focusedBorder: border,
//                         //     enabledBorder: border,
//                         //   ),
//                         //   expiryDateDecoration: InputDecoration(
//                         //     hintStyle: const TextStyle(color: Colors.black45),
//                         //     labelStyle: const TextStyle(color: Colors.black45),
//                         //     focusedBorder: border,
//                         //     enabledBorder: border,
//                         //     labelText: 'Expired Date',
//                         //     hintText: 'XX/XX',
//                         //   ),
//                         //   cvvCodeDecoration: InputDecoration(
//                         //     hintStyle: const TextStyle(color: Colors.black45),
//                         //     labelStyle: const TextStyle(color: Colors.black45),
//                         //     focusedBorder: border,
//                         //     enabledBorder: border,
//                         //     labelText: 'CVV',
//                         //     hintText: 'XXX',
//                         //   ),
//                         //   cardHolderDecoration: InputDecoration(
//                         //     hintStyle: const TextStyle(color: Colors.black45),
//                         //     labelStyle: const TextStyle(color: Colors.black45),
//                         //     focusedBorder: border,
//                         //     enabledBorder: border,
//                         //     labelText: 'Card Holder',
//                         //   ),
//                         //   onCreditCardModelChange: onCreditCardModelChange,
//                         // ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             primary: const Color(0xff1b447b),
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(12),
//                             child: const Text(
//                               'Validate',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: 'halter',
//                                 fontSize: 14,
//                                 package: 'flutter_credit_card',
//                               ),
//                             ),
//                           ),
//                           onPressed: () async {
//                             int? cvc = int.tryParse(cvvCode);
//                             int? carNo = int.tryParse(cardNumber.replaceAll(
//                                 RegExp(r"\s+\b|\b\s"), ""));
//                             int? exp_year =
//                                 int.tryParse(expiryDate.substring(3, 5));
//                             int? exp_month =
//                                 int.tryParse(expiryDate.substring(0, 2));
//                             print("cvc num: ${cvc.toString()}");
//                             print("card num: ${carNo.toString()}");
//                             print("exp year: ${exp_year.toString()}");
//                             print("exp month: ${exp_month.toString()}");
//                             print(cardNumber.replaceAll(
//                                 RegExp(r"\s+\b|\b\s"), ""));
//
//                             //StripeServices stripeServices = StripeServices();
//
//                             AppUser user = await authService.getCurrentUser();
//                             // CardModel card ;
//                             // if(user.stripeId == null){
//                             //   String stripeID = await stripeServices.createStripeCustomer(uid: user.id,email: user.email);
//                             //   print('start print strip id ================================');
//                             //   print("stripe id: $stripeID");
//                             //   print('end print strip id ================================');
//                             //   card = await stripeServices.addCard(stripeId: stripeID, month: exp_month!, year: exp_year!, cvc: cvc!, cardNumber: carNo!, userId: user.id);
//                             // }else{
//                             //   card = await   stripeServices.addCard(stripeId: user.stripeId!, month: exp_month!, year: exp_year!, cvc: cvc!, cardNumber: carNo!, userId: user.id);
//                             // }
//                             // PaymentMethodeNumberBloc bloc =  context.read<PaymentMethodeNumberBloc>();
//                             //  bloc.getCards();
//                             String card_number_in_firebase =
//                                 carNo.toString().substring(0, 4) +
//                                     ' **** **** ' +
//                                     carNo
//                                         .toString()
//                                         .substring(12, carNo.toString().length);
//                             print(card_number_in_firebase);
//                             CardModel card = CardModel(
//                                 id: DateTime.now().toString(),
//                                 cardNumber: card_number_in_firebase,
//                                 userID: user.id,
//                                 month: exp_month!,
//                                 year: exp_year!,
//                                 last4:
//                                     int.parse(carNo.toString().substring(11)));
//
//                             PaymentMethodeNumberBloc bloc =
//                                 context.read<PaymentMethodeNumberBloc>();
//                             await bloc.addOne(card);
//                             Navigator.of(context).pop();
//                             //   user.hasCard();
//                             // user.loadCardsAndPurchase(userId: user.user.uid);
//                             // if (formKey.currentState!.validate()) {
//                             //    PaymentMethodeNumberBloc bloc =  context.read<PaymentMethodeNumberBloc>();
//                             //      CardModel card = CardModel(
//                             //          id: bloc.state.cards.length+1, cardHolderName: cardHolderName, cardNumber: cardNumber, cvvCode: cvvCode, expiryDate: expiryDate);
//                             //      bloc.addOne(card);
//                             //     // Navigator.pop(context);
//                             //  PaymentMethod  paymentMethod = await paymentService.createPaymentMethod();
//                             //  print('ssssssssssssssssssssss');
//                             //  print(paymentMethod.id);
//                             // //   } else {
//                             //      print('invalid!');
//                             //  //  }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void onCreditCardModelChange(CreditCardModel? creditCardModel) {
//   //   setState(() {
//   //     cardNumber = creditCardModel!.cardNumber;
//   //     expiryDate = creditCardModel.expiryDate;
//   //     cardHolderName = creditCardModel.cardHolderName;
//   //     cvvCode = creditCardModel.cvvCode;
//   //     isCvvFocused = creditCardModel.isCvvFocused;
//   //   });
//   // }
//
//   showPaymentCards()async{
//       //     // showDialog(
//       // //     context: context,
//       // //     builder: (context) {
//       // //       return ClipRRect(
//       // //         borderRadius: BorderRadius.circular(20),
//       // //         child: AlertDialog(
//       // //           backgroundColor:
//       // //               Colors.white.withOpacity(0.8),
//       // //           clipBehavior: Clip.antiAlias,
//       // //           shape: RoundedRectangleBorder(
//       // //             borderRadius: BorderRadius.circular(20),
//       // //           ),
//       // //           content: Container(
//       // //             height: 70,
//       // //             width: 90,
//       // //             child: Center(
//       // //               child: Text(
//       // //                 S.of(context)!.creditComingSoon,
//       // //                 style: GoogleFonts.acme(
//       // //                     color: Colors.green,
//       // //                     fontWeight: FontWeight.bold),
//       // //               ),
//       // //             ),
//       // //           ),
//       // //         ),
//       // //       );
//       // //     });
//       // if(paymentGroupValue ==''){
//       //   _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.paymentMethodAlert)));
//       // }
//       // else if(!(_checkAddressBloc.state is CheckAddressSuccessState)){
//       //   _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.destinationAlert)));
//       // }
//       // else if(orderNotComplete){
//       //   _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.completeTheOrder)));
//       // }
//       // // else if(paymentGroupValue == PaymentMethodConst.CASH_MONEY){
//       // //   GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
//       // //   _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
//       // // }
//       // else{
//       //     GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
//       //     _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
//       //
//       // }
//       //
//       //
//       //
//       // /// For Credits Cards
//       // // else
//       // //   showMaterialModalBottomSheet(
//       // //     shape: RoundedRectangleBorder(
//       // //       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
//       // //           topRight: Radius.circular(30)
//       // //       ),
//       // //     ),
//       // //     context: context,
//       // //     builder: (context) => SingleChildScrollView(
//       // //       controller: ModalScrollController.of(context),
//       // //       child: BlocBuilder<PaymentMethodeNumberBloc,PaymentState>(
//       // //           bloc: paymentMethodeNumberBloc,
//       // //           builder: (context,state) {
//       // //             return Container(
//       // //               padding: EdgeInsets.symmetric(horizontal: 10),
//       // //               height: SizeConfig.screenHeight * 0.8 ,
//       // //               clipBehavior: Clip.antiAlias,
//       // //               decoration: BoxDecoration(
//       // //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
//       // //                     topRight: Radius.circular(30)
//       // //                 ),
//       // //               ),
//       // //               child: Column(
//       // //                 crossAxisAlignment: CrossAxisAlignment.start,
//       // //                 children: [
//       // //                   IconButton(onPressed: (){
//       // //                     Navigator.of(context).pop();
//       // //                   }, icon:Icon(Icons.clear) ),
//       // //                   Text(S.of(context)!.payByCard , style:TextStyle(
//       // //
//       // //                       color: Colors.black54,
//       // //                       fontWeight: FontWeight.bold,
//       // //                       fontSize: SizeConfig.titleSize*2.9
//       // //
//       // //                   ),),
//       // //                   SizedBox(height: 15,),
//       // //                   Container(
//       // //                     margin: EdgeInsets.symmetric(horizontal: 20),
//       // //
//       // //                     child: ListView.separated(
//       // //                       separatorBuilder: (context,index){
//       // //                         return  SizedBox(height: 8,);
//       // //                       },
//       // //                       shrinkWrap:true ,
//       // //                       itemCount: state.cards.length,
//       // //                       itemBuilder: (context,index){
//       // //                         CardModel  card =   state.cards[index];
//       // //                         return   Center(
//       // //                           child: Container(
//       // //                             width: double.infinity,
//       // //                             height: 6.8 * SizeConfig.heightMulti,
//       // //                             decoration: BoxDecoration(
//       // //                                 borderRadius: BorderRadius.circular(10),
//       // //                                 color: Colors.grey.shade50,
//       // //                                 border: Border.all(
//       // //                                     color: Colors.black26,
//       // //                                     width: 2
//       // //                                 )
//       // //                             ),
//       // //                             child: Row(
//       // //                               mainAxisSize: MainAxisSize.min,
//       // //
//       // //                               children: [
//       // //                                 Radio<String>(
//       // //                                   value: card.id,
//       // //                                   groupValue: paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue,
//       // //                                   onChanged: (value) {
//       // //                                     paymentMethodeNumberBloc.changeSelect(value!);
//       // //                                   },
//       // //                                   activeColor: Colors.green,
//       // //                                 ),
//       // //                                 Icon(Icons.payment),
//       // //                                 SizedBox(width: 10,),
//       // //
//       // //                                 Text(card.cardNumber , style: GoogleFonts.lato(
//       // //                                     color: Colors.black54,
//       // //                                     fontSize: SizeConfig.titleSize * 2.1,
//       // //                                     fontWeight: FontWeight.bold
//       // //                                 ),),
//       // //                                 Spacer(),
//       // //                                 IconButton(onPressed: (){
//       // //                                   paymentMethodeNumberBloc.removeOne(state.cards[index]);
//       // //                                 }, icon: Icon(Icons.delete,color: Colors.red,)),
//       // //
//       // //                               ],
//       // //                             ),
//       // //                           ),
//       // //                         );
//       // //
//       // //                       },
//       // //
//       // //                     ),
//       // //                   ),
//       // //                   SizedBox(height:25,),
//       // //                   Center(
//       // //                     child: GestureDetector(
//       // //                       onTap: (){
//       // //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>
//       // //                             BlocProvider.value(
//       // //                                 value: paymentMethodeNumberBloc,
//       // //                                 child: AddCardScreen())
//       // //                         ));
//       // //                         //  paymentMethodeNumberBloc.addOne();
//       // //                       },
//       // //                       child: Container(
//       // //                         margin: EdgeInsets.symmetric(horizontal: 20),
//       // //
//       // //                         width: SizeConfig.screenWidth ,
//       // //                         height: 6.8 * SizeConfig.heightMulti,
//       // //                         decoration: BoxDecoration(
//       // //                             borderRadius: BorderRadius.circular(10),
//       // //                             color: Colors.grey.shade50,
//       // //                             border: Border.all(
//       // //                                 color: Colors.black26,
//       // //                                 width: 2
//       // //                             )
//       // //                         ),
//       // //                         child: Row(
//       // //                           mainAxisSize: MainAxisSize.min,
//       // //
//       // //                           children: [
//       // //
//       // //                             Icon(Icons.add),
//       // //                             SizedBox(width: 10,),
//       // //
//       // //                             Text(S.of(context)!.addCard, style: GoogleFonts.lato(
//       // //                                 color: Colors.black54,
//       // //                                 fontSize: SizeConfig.titleSize * 2.6,
//       // //                                 fontWeight: FontWeight.bold
//       // //                             )
//       // //                               ,)
//       // //                           ],
//       // //                         ),
//       // //                       ),
//       // //                     ),
//       // //                   ),
//       // //                   Spacer(),
//       // //                   Center(
//       // //                     child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
//       // //                         bloc: _orderBloc,
//       // //                         listener: (context,state)async{
//       // //                           if(state is CreateOrderSuccessState)
//       // //                           {
//       // //                             snackBarSuccessWidget(context, S.of(context)!.orderAddedSuccessfully);
//       // //                             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CompleteOrderScreen(orderId: state.data.id)),(route)=>false);
//       // //                             shopCartBloc.startedShop();
//       // //                           }
//       // //                           else if(state is CreateOrderErrorState)
//       // //                           {
//       // //                             snackBarSuccessWidget(context, S.of(context)!.orderWasNotAdded);
//       // //                           }
//       // //                         },
//       // //                         builder: (context,state) {
//       // //                           bool isLoading = state is CreateOrderLoadingState?true:false;
//       // //                           return AnimatedContainer(
//       // //                             duration: Duration(milliseconds: 200),
//       // //                             clipBehavior: Clip.antiAlias,
//       // //                             height: 8.44 * SizeConfig.heightMulti,
//       // //                             width:isLoading?60: SizeConfig.screenWidth * 0.8,
//       // //                             padding: EdgeInsets.all(isLoading?8:0 ),
//       // //                             margin: EdgeInsets.symmetric(horizontal: 20),
//       // //                             decoration: BoxDecoration(
//       // //                                 color: ColorsConst.mainColor,
//       // //                                 borderRadius: BorderRadius.circular(10)
//       // //                             ),
//       // //                             child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
//       // //                               onPressed: () {
//       // //                                 cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
//       // //                                 if(cardId ==''){
//       // //                                   Fluttertoast.showToast(
//       // //                                       msg: S.of(context)!.selectCardAlert,
//       // //                                       toastLength: Toast.LENGTH_LONG,
//       // //                                       gravity: ToastGravity.TOP,
//       // //                                       timeInSecForIosWeb: 1,
//       // //                                       backgroundColor: Colors.white,
//       // //                                       textColor: Colors.black,
//       // //                                       fontSize: 18.0
//       // //                                   );
//       // //                                 }
//       // //                                 else{
//       // //                                   GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
//       // //                                   _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
//       // //
//       // //                                 }
//       // //
//       // //                               },
//       // //                               child: Text(S.of(context)!.orderConfirmation, style: TextStyle(color: Colors.white,
//       // //                                   fontSize: SizeConfig.titleSize * 2.7),),
//       // //
//       // //                             ),
//       // //                           );
//       // //                         }
//       // //                     ),
//       // //                   ),
//       // //                   SizedBox(height: SizeConfig.screenHeight * 0.05,)
//       // //                 ],
//       // //               ),
//       // //             );
//       // //           }
//       // //       ),
//       // //     ),
//       // //   );
//       // //  }
//   }
// }
//
// ///  The Code For Credit Cards
// // ? MaterialButton(
// //     onPressed: () {
// //       // showDialog(
// //       //     context: context,
// //       //     builder: (context) {
// //       //       return ClipRRect(
// //       //         borderRadius: BorderRadius.circular(20),
// //       //         child: AlertDialog(
// //       //           backgroundColor:
// //       //               Colors.white.withOpacity(0.8),
// //       //           clipBehavior: Clip.antiAlias,
// //       //           shape: RoundedRectangleBorder(
// //       //             borderRadius: BorderRadius.circular(20),
// //       //           ),
// //       //           content: Container(
// //       //             height: 70,
// //       //             width: 90,
// //       //             child: Center(
// //       //               child: Text(
// //       //                 S.of(context)!.creditComingSoon,
// //       //                 style: GoogleFonts.acme(
// //       //                     color: Colors.green,
// //       //                     fontWeight: FontWeight.bold),
// //       //               ),
// //       //             ),
// //       //           ),
// //       //         ),
// //       //       );
// //       //     });
// //       if(paymentGroupValue ==''){
// //         _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.paymentMethodAlert)));
// //       }
// //       else if(!(_checkAddressBloc.state is CheckAddressSuccessState)){
// //         _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.destinationAlert)));
// //       }
// //       else if(orderNotComplete){
// //         _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text(S.of(context)!.completeTheOrder)));
// //       }
// //       // else if(paymentGroupValue == PaymentMethodConst.CASH_MONEY){
// //       //   GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
// //       //   _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
// //       // }
// //       else{
// //           GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
// //           _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
// //
// //       }
// //
// //
// //
// //       /// For Credits Cards
// //       // else
// //       //   showMaterialModalBottomSheet(
// //       //     shape: RoundedRectangleBorder(
// //       //       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
// //       //           topRight: Radius.circular(30)
// //       //       ),
// //       //     ),
// //       //     context: context,
// //       //     builder: (context) => SingleChildScrollView(
// //       //       controller: ModalScrollController.of(context),
// //       //       child: BlocBuilder<PaymentMethodeNumberBloc,PaymentState>(
// //       //           bloc: paymentMethodeNumberBloc,
// //       //           builder: (context,state) {
// //       //             return Container(
// //       //               padding: EdgeInsets.symmetric(horizontal: 10),
// //       //               height: SizeConfig.screenHeight * 0.8 ,
// //       //               clipBehavior: Clip.antiAlias,
// //       //               decoration: BoxDecoration(
// //       //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
// //       //                     topRight: Radius.circular(30)
// //       //                 ),
// //       //               ),
// //       //               child: Column(
// //       //                 crossAxisAlignment: CrossAxisAlignment.start,
// //       //                 children: [
// //       //                   IconButton(onPressed: (){
// //       //                     Navigator.of(context).pop();
// //       //                   }, icon:Icon(Icons.clear) ),
// //       //                   Text(S.of(context)!.payByCard , style:TextStyle(
// //       //
// //       //                       color: Colors.black54,
// //       //                       fontWeight: FontWeight.bold,
// //       //                       fontSize: SizeConfig.titleSize*2.9
// //       //
// //       //                   ),),
// //       //                   SizedBox(height: 15,),
// //       //                   Container(
// //       //                     margin: EdgeInsets.symmetric(horizontal: 20),
// //       //
// //       //                     child: ListView.separated(
// //       //                       separatorBuilder: (context,index){
// //       //                         return  SizedBox(height: 8,);
// //       //                       },
// //       //                       shrinkWrap:true ,
// //       //                       itemCount: state.cards.length,
// //       //                       itemBuilder: (context,index){
// //       //                         CardModel  card =   state.cards[index];
// //       //                         return   Center(
// //       //                           child: Container(
// //       //                             width: double.infinity,
// //       //                             height: 6.8 * SizeConfig.heightMulti,
// //       //                             decoration: BoxDecoration(
// //       //                                 borderRadius: BorderRadius.circular(10),
// //       //                                 color: Colors.grey.shade50,
// //       //                                 border: Border.all(
// //       //                                     color: Colors.black26,
// //       //                                     width: 2
// //       //                                 )
// //       //                             ),
// //       //                             child: Row(
// //       //                               mainAxisSize: MainAxisSize.min,
// //       //
// //       //                               children: [
// //       //                                 Radio<String>(
// //       //                                   value: card.id,
// //       //                                   groupValue: paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue,
// //       //                                   onChanged: (value) {
// //       //                                     paymentMethodeNumberBloc.changeSelect(value!);
// //       //                                   },
// //       //                                   activeColor: Colors.green,
// //       //                                 ),
// //       //                                 Icon(Icons.payment),
// //       //                                 SizedBox(width: 10,),
// //       //
// //       //                                 Text(card.cardNumber , style: GoogleFonts.lato(
// //       //                                     color: Colors.black54,
// //       //                                     fontSize: SizeConfig.titleSize * 2.1,
// //       //                                     fontWeight: FontWeight.bold
// //       //                                 ),),
// //       //                                 Spacer(),
// //       //                                 IconButton(onPressed: (){
// //       //                                   paymentMethodeNumberBloc.removeOne(state.cards[index]);
// //       //                                 }, icon: Icon(Icons.delete,color: Colors.red,)),
// //       //
// //       //                               ],
// //       //                             ),
// //       //                           ),
// //       //                         );
// //       //
// //       //                       },
// //       //
// //       //                     ),
// //       //                   ),
// //       //                   SizedBox(height:25,),
// //       //                   Center(
// //       //                     child: GestureDetector(
// //       //                       onTap: (){
// //       //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>
// //       //                             BlocProvider.value(
// //       //                                 value: paymentMethodeNumberBloc,
// //       //                                 child: AddCardScreen())
// //       //                         ));
// //       //                         //  paymentMethodeNumberBloc.addOne();
// //       //                       },
// //       //                       child: Container(
// //       //                         margin: EdgeInsets.symmetric(horizontal: 20),
// //       //
// //       //                         width: SizeConfig.screenWidth ,
// //       //                         height: 6.8 * SizeConfig.heightMulti,
// //       //                         decoration: BoxDecoration(
// //       //                             borderRadius: BorderRadius.circular(10),
// //       //                             color: Colors.grey.shade50,
// //       //                             border: Border.all(
// //       //                                 color: Colors.black26,
// //       //                                 width: 2
// //       //                             )
// //       //                         ),
// //       //                         child: Row(
// //       //                           mainAxisSize: MainAxisSize.min,
// //       //
// //       //                           children: [
// //       //
// //       //                             Icon(Icons.add),
// //       //                             SizedBox(width: 10,),
// //       //
// //       //                             Text(S.of(context)!.addCard, style: GoogleFonts.lato(
// //       //                                 color: Colors.black54,
// //       //                                 fontSize: SizeConfig.titleSize * 2.6,
// //       //                                 fontWeight: FontWeight.bold
// //       //                             )
// //       //                               ,)
// //       //                           ],
// //       //                         ),
// //       //                       ),
// //       //                     ),
// //       //                   ),
// //       //                   Spacer(),
// //       //                   Center(
// //       //                     child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
// //       //                         bloc: _orderBloc,
// //       //                         listener: (context,state)async{
// //       //                           if(state is CreateOrderSuccessState)
// //       //                           {
// //       //                             snackBarSuccessWidget(context, S.of(context)!.orderAddedSuccessfully);
// //       //                             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> CompleteOrderScreen(orderId: state.data.id)),(route)=>false);
// //       //                             shopCartBloc.startedShop();
// //       //                           }
// //       //                           else if(state is CreateOrderErrorState)
// //       //                           {
// //       //                             snackBarSuccessWidget(context, S.of(context)!.orderWasNotAdded);
// //       //                           }
// //       //                         },
// //       //                         builder: (context,state) {
// //       //                           bool isLoading = state is CreateOrderLoadingState?true:false;
// //       //                           return AnimatedContainer(
// //       //                             duration: Duration(milliseconds: 200),
// //       //                             clipBehavior: Clip.antiAlias,
// //       //                             height: 8.44 * SizeConfig.heightMulti,
// //       //                             width:isLoading?60: SizeConfig.screenWidth * 0.8,
// //       //                             padding: EdgeInsets.all(isLoading?8:0 ),
// //       //                             margin: EdgeInsets.symmetric(horizontal: 20),
// //       //                             decoration: BoxDecoration(
// //       //                                 color: ColorsConst.mainColor,
// //       //                                 borderRadius: BorderRadius.circular(10)
// //       //                             ),
// //       //                             child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
// //       //                               onPressed: () {
// //       //                                 cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
// //       //                                 if(cardId ==''){
// //       //                                   Fluttertoast.showToast(
// //       //                                       msg: S.of(context)!.selectCardAlert,
// //       //                                       toastLength: Toast.LENGTH_LONG,
// //       //                                       gravity: ToastGravity.TOP,
// //       //                                       timeInSecForIosWeb: 1,
// //       //                                       backgroundColor: Colors.white,
// //       //                                       textColor: Colors.black,
// //       //                                       fontSize: 18.0
// //       //                                   );
// //       //                                 }
// //       //                                 else{
// //       //                                   GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
// //       //                                   _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, orderType:vipOrder , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId,storeId:storeId);
// //       //
// //       //                                 }
// //       //
// //       //                               },
// //       //                               child: Text(S.of(context)!.orderConfirmation, style: TextStyle(color: Colors.white,
// //       //                                   fontSize: SizeConfig.titleSize * 2.7),),
// //       //
// //       //                             ),
// //       //                           );
// //       //                         }
// //       //                     ),
// //       //                   ),
// //       //                   SizedBox(height: SizeConfig.screenHeight * 0.05,)
// //       //                 ],
// //       //               ),
// //       //             );
// //       //           }
// //       //       ),
// //       //     ),
// //       //   );
// //       //  }
// //     },
// //     child: Text(
// //       S.of(context)!.next,
// //       style: TextStyle(
// //           color: Colors.white,
// //           fontSize: SizeConfig.titleSize * 2.5),
// //     ))
