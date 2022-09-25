
// import 'package:flutter/material.dart';

// class Responsive extends StatelessWidget {
//   final Widget mobile, desktop;
//   Responsive({@required this.mobile, @required this.desktop});

//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 850;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 850;

//   @override
//   Widget build(BuildContext context) {
//     // width <850 is mobile
//     // width >= 850 && width < 1100 is Tablet
//     // width > 1100 is desktop
//     double _width = MediaQuery.of(context).size.width;
//     if (_width < 850)
//       return mobile;
//     else
//       return desktop;
//   }
// }
