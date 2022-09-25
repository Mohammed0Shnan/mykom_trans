
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/about_routes.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_about/bloc/splash_animation_bloc.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class SplashScreen extends StatefulWidget {
  //final AuthService _authService;
   final AboutService _aboutService;
  LocalizationService localizationService =LocalizationService();
  // final ProfileService _profileService;

  SplashScreen(
   // this._authService,
     this._aboutService,
    // this._profileService,
  );
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    spalshAnimationBloC.playAnimation();
       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getNextRoute().then((route) async{
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
      });
    });
  }

  @override
  void dispose() {
    spalshAnimationBloC.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight,
            ),
            Center(
              child: Container(
                child: BlocConsumer<SpalshAnimationBloC, bool>(
                  bloc: spalshAnimationBloC,
                  listener: (context, state) {

                  },
                  builder: (context, state) {
                    double current_width = 0;
                    if (state) {
                      current_width = SizeConfig.screenWidth * 0.5;
                    } else
                      current_width = 0;
                    return CustomFadeAnimation(
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorsConst.mainColor
                          ),
                          child: Image.asset('assets/new_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 10 * SizeConfig.heightMulti,
                        width: current_width,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getNextRoute() async {
    try {
      var isInited = await widget._aboutService.isInited();
     if (!isInited) {
        return AboutRoutes.ROUTE_ABOUT;
        }

      return NavigatorRoutes.NAVIGATOR_SCREEN;

     //  // Is LoggedIn
     //  UserRole? role = await widget._authService.userRole;
     //  if(role != null){
     //    return NavigatorRoutes.NAVIGATOR_SCREEN;
     //  }
     //
     //  // Is Not LoggedInt
     // else {
     //     return NavigatorRoutes.NAVIGATOR_SCREEN;
     //  //  return AuthorizationRoutes.LOGIN_SCREEN;
     //  }
    } catch (e) {
      return AboutRoutes.ROUTE_ABOUT;  // about screen
    }
  }
}


