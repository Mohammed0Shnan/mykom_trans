import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_about/bloc/page_view_animation_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:my_kom/generated/l10n.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final _pageController ;
  late PageViewAnimationBloc bloc;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    bloc = PageViewAnimationBloc(_pageController);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    bloc.close();
    super.dispose();
  }

  final List<String> LottieUrls = [
    'assets/choices.jpg',
    'assets/page2.jpg',
  'assets/Delivery-Cristina.jpg'

  ];


  int currentIndex =0;
  @override
  Widget build(BuildContext context) {

    final List<String> pageTitleInformations = [
      S.of(context)!.titlePageOne,
      S.of(context)!.titlePageTow,
      S.of(context)!.titlePageThree,

    ];
    final List<String> pageSubTitleInformations = [
      S.of(context)!.subTitlePageOne,
       S.of(context)!.subTitlePageTow,
      S.of(context)!.subTitlePageThree,
    ];

    return Scaffold(

      body: Stack(

        alignment: Alignment.center,
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            color: Colors.white,
          ),
          Positioned(
            top: SizeConfig.screenHeight * 0.13,
            child: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: PageView.builder(
                onPageChanged: (index){
                  currentIndex = index;
                  setState(() {

                  });
                },
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return BlocBuilder<PageViewAnimationBloc, double>(
                    bloc: bloc,
                    builder: (context, state) {
                      return Opacity(
                        opacity: max(1 - (state - index).abs(), 0),
                        child: Container(
                            height: SizeConfig.screenHeight,
                            width: SizeConfig.screenWidth,
                            child: Page(

                              title: Text(pageTitleInformations[index]),
                              lottieUrl: LottieUrls[index],
                              color: Colors.transparent,
                              infoTitle: pageTitleInformations[index],
                              infoSubTitle: pageSubTitleInformations[index],
                            ),
                           // child: Image.asset(LottieUrls[index],fit: BoxFit.fill,)

                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),


          Positioned(
            bottom: SizeConfig.screenHeight * 0.19,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: JumpingDotEffect(
                  dotColor: Colors.grey.shade400,
                  dotHeight:7,
                  dotWidth: 25,
                  spacing: 2,
                  jumpScale: 2,
                  activeDotColor:ColorsConst.mainColor),
            ),
          ),
          Positioned(
            top: 20,
            right: 16,
            left: 16,
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                onTap: (){
                  AboutService().setInited();
                  Navigator.pushNamedAndRemoveUntil(
                      context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=> false);
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: SizeConfig.screenWidth * 0.2,

                    child: Text( S.of(context)!.skip,style: GoogleFonts.lato(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),)
                ),
          ),
              ],
            ),),
          Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child:   GestureDetector(
                onTap: (){
                  if (_pageController.page == 2) {
                    AboutService().setInited();
                    Navigator.pushNamedAndRemoveUntil(
                        context, NavigatorRoutes.NAVIGATOR_SCREEN,(route)=> false);
                  } else {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.ease);
                  }

                },
                child: Container(
                    alignment: Alignment.center,

                    height: 50,
                    width: SizeConfig.screenWidth * 0.2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsConst.mainColor
                    ),
                    child: Icon(Icons.arrow_forward,color: Colors.white,)
                ),
              ),),

        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final Color color;
  final Widget title;
  final String infoTitle;
  final String infoSubTitle;
  final String lottieUrl;

  const Page(
      {required this.title,
      required this.infoTitle,
      required this.infoSubTitle,
      required this.lottieUrl,
      required this.color,

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight ,
      child:Column(
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.4,
            child: Image.asset(lottieUrl,fit: BoxFit.cover),
          ),
          SizedBox(height: 40,),
                    Text(
                      infoTitle,
                      style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 3.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87

                      )
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.heightMulti * 6),
                      child: Text(
                        infoSubTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(

                          fontSize: SizeConfig.titleSize * 2.1,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54


                        ),
                      ),
                    ),
        ],
      )
    );
  }
}
