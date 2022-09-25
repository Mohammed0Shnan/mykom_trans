import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  AuthBackground({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white ,
      body: SafeArea(
        bottom: false,
        top: true,
        child: Stack(

          children: [
            Positioned(
              bottom:- SizeConfig.screenHeight * 0.32,
              left: 0,
              right: 0,
              child: Container(
                height: SizeConfig.screenWidth + (5* SizeConfig.heightMulti)  ,
                width:  SizeConfig.screenWidth + (5 * SizeConfig.heightMulti),
                // decoration: BoxDecoration(
                //     color: Colors.green.withOpacity(0.1),
                //     shape: BoxShape.circle),
               // child: SvgPicture.asset('assets/CIRCLE.svg',fit: BoxFit.cover,),
              ),
            ),
            // BottomCustomClipperWidget(),
            child
          ],
        ),
      ),
    );
  }
}
