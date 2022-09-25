// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
// import 'package:my_kom/module_home/screen/navigator_screen.dart';
// import 'package:my_kom/module_shoping/screen/shop_screen.dart';
// import 'package:my_kom/utils/size_configration/size_config.dart';
//
// class ShopNavigatorScreen extends StatefulWidget {
//   final NavigatorScreen navigatorScreen;
//   final ShopScreen shopScreen;
//    ShopNavigatorScreen({required this.navigatorScreen,required  this.shopScreen,Key? key}) : super(key: key);
//
//   @override
//   State<ShopNavigatorScreen> createState() => _ShopNavigatorScreenState();
// }
//
// class _ShopNavigatorScreenState extends State<ShopNavigatorScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _shopeScaleAnimation;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 200));
//     _animation = Tween<double>(begin: 1.0, end: 0.4).animate(_controller);
//     _slideAnimation = Tween<Offset>(begin: Offset(-10, 0), end: Offset(0, 0))
//         .animate(_controller);
//     _shopeScaleAnimation =
//         Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         _buildMenuScreen(),
//         _buildNavigatorScreen(),
//       ]),
//     );
//   }
//
//   _buildNavigatorScreen() {
//     return BlocConsumer<OpenCloseMenuBloc, bool>(
//         bloc: openCloseMenuBloc,
//         listener: ((context, state) {
//           if (!state) {
//             _controller.reverse();
//           } else {
//             _controller.forward();
//           }
//         }),
//         builder: (context, state) {
//           return AnimatedPositioned(
//               duration: Duration(milliseconds: 200),
//               bottom: 0,
//               top: 0,
//               left: state ? 0 : SizeConfig.screenWidth * 0.8,
//               right: state ? 0 : -0.2 * SizeConfig.screenHeight,
//               child: ScaleTransition(
//                 scale: _animation,
//                 child: Material(
//                     borderRadius:  BorderRadius.circular(state ?0:30) ,
//                     clipBehavior: Clip.antiAlias,
//                     child: widget.navigatorScreen),
//               ));
//         });
//   }
//
//   _buildMenuScreen() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: ScaleTransition(
//         scale: _shopeScaleAnimation,
//         child: Column(children: [
//           Text('Profile'),
//           SizedBox(height: 20,),
//           Text('Notificatios'),
//           SizedBox(height: 20,),
//           Text('Setting'),
//           SizedBox(height: 20,),
//           Text('Log Out'),
//           SizedBox(height: 20,)
//         ],),
//       ),
//     );
//   }
//
//   // _willPop() {
//   //  // openCloseShopBloc.closeShop();
//   // }
// }
