// import 'package:bloc_skeleton/utils/size_configration/size_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class Background extends StatelessWidget {
//  final  Widget child;
// Background({this.child});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         bottom: false,
//         child: Stack(
//           children: [
//             Container(
//               margin: EdgeInsets.all(20),
//               padding: EdgeInsets.all(20),
//               height: SizeConfig.screenHeight,
//               width: SizeConfig.screenWidth,
//               decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/nody.jpg'),fit: BoxFit.cover,)),
//             ),
//             Center(child: child)
//           ],
//         ),
//       ),
//     );
//   }
// }