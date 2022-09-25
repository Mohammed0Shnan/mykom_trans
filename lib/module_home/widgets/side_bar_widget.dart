// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
//
// class SideBarWidget extends StatefulWidget {
//   const SideBarWidget({Key? key}) : super(key: key);
//
//   @override
//   State<SideBarWidget> createState() => _SideBarWidgetState();
// }
//
// class _SideBarWidgetState extends State<SideBarWidget>  with SingleTickerProviderStateMixin{
// late  AnimationController _animationController;
// late OpenCloseMenuBloc _bloc ;
//   final bool isSideBarOpen = false;
//   final _duration = const Duration(milliseconds: 500);
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc = OpenCloseMenuBloc();
//     _animationController = AnimationController(vsync: this , duration: _duration );
//   }
//   onPress(){
//     final animationStaus = _animationController.status;
//     final isCAnimationComplete = animationStaus == AnimationStatus.completed;
//     if(!isCAnimationComplete){
//       _bloc.closeMenu();
//       _animationController.reverse();
//     }else{
//       _bloc.openMenu();
//       _animationController.forward();
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return BlocBuilder<OpenCloseMenuBloc,bool>(
//       bloc:_bloc,
//       builder: (context,state) {
//         return AnimatedPositioned(
//           duration: _duration,
//           top: 0,
//           bottom: 0,
//           left:state?0:-screenWidth ,
//             right: state?0: screenWidth - 45,
//           child: Row(
//             children: [
//               Expanded(child: Container(
//                 color: Colors.blue,
//                 padding:const EdgeInsets.symmetric(horizontal: 20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(height: 100,),
//                       ListTile(title: Text(''),
//                       subtitle:Text('') ,
//                         leading: CircleAvatar(
//                           child: Icon(Icons.perm_identity , color: Colors.white,),
//                           radius: 40,
//                         ),
//                       ),
//                       Divider(height:65 ,thickness: 0.5,color: Colors.white.withOpacity(0.3),indent: 32,endIndent: 32,),
//                       menuItem(
//                         icon: Icons.home,
//                         title: 'Home'
//                       ),
//                       menuItem(
//                           icon: Icons.person,
//                           title: 'Profile'
//                       ),
//                       menuItem(
//                           icon: Icons.shopping_basket,
//                           title: 'Home'
//                       ),
//                       Divider(height:65 ,thickness: 0.5,color: Colors.white.withOpacity(0.3),indent: 32,endIndent: 32,),
//                       menuItem(
//                           icon: Icons.shopping_basket,
//                           title: 'Setting'
//                       ),
//                       menuItem(
//                           icon: Icons.shopping_basket,
//                           title: 'Logout'
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//               Align(
//                 alignment: Alignment(0,-0.9),
//                 child: GestureDetector(
//                   onTap: (){
//                     onPress();
//                   },
//                   child: ClipPath(
//                     clipper: CustomClipperWidget(),
//                     child: Container(width: 35,
//                     height: 110,
//                       alignment: Alignment.centerLeft,
//                       color: Colors.blue,
//                       child: AnimatedIcon(
//                         progress: _animationController.view,
//                         icon: AnimatedIcons.menu_close,
//                         size: 25,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }
//     );
//   }
//
// }
// class CustomClipperWidget extends CustomClipper<Path>{
//   @override
//   Path getClip(Size size) {
//    Paint paint = Paint();
//    paint.color = Colors.white;
//    final width = size.width ;
//    final height = size.height;
//    Path path = Path();
//    path.moveTo(0,0);
//    path.quadraticBezierTo(0,8,10,16);
//    path.quadraticBezierTo(width-1, height/2-20, width, height/2);
//    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
//    path.quadraticBezierTo(0, height-8, 0, height);
//    path.close();
//    return path;
//
//
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
//
// }
