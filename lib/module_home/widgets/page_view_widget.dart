import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewWidget extends StatefulWidget {
  final Function(int) pageBuilder;
  final int itemCount;
  final double hieght;
  const PageViewWidget(
      {required this.pageBuilder,required this.itemCount, required this.hieght, Key? key})
      : super(key: key);

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  double currentPage = 0.0;
  double scaleFactor = 0.8;
  late final double containerHieght;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    containerHieght = widget.hieght;
    _pageController
      ..addListener(() {
        currentPage = _pageController.page!;
        setState(() {});
      });
    _autoMove();
  }

  _autoMove() async {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
   if(currentPage.round() < widget.itemCount-1){
     currentPage ++;
     _pageController.animateToPage(currentPage.round(), duration:  Duration(milliseconds: 500), curve: Curves.easeInOut);

   }else {
     currentPage = 0;
     _pageController.animateToPage(0, duration:  Duration(milliseconds: 500), curve: Curves.easeInOut);

   }


    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.hieght,
          child: PageView.builder(
            itemCount: widget.itemCount,
            controller: _pageController,
            itemBuilder: (context, int index) {
              Matrix4 matrix = Matrix4.identity();

              if (index == currentPage.floor()) {
                double scale = 1 - (currentPage - index) * (1 - scaleFactor);
                double trans = containerHieght * (1 - scale) / 2;
                matrix = Matrix4.diagonal3Values(1, scale, 1)
                  ..setTranslationRaw(0, trans, 0);
              } else if (index == currentPage.floor() + 1) {
                double scale =
                    scaleFactor + (currentPage - index + 1) * (1 - scaleFactor);
                double trans = containerHieght * (1 - scale) / 2;

                matrix = Matrix4.diagonal3Values(1, scale, 1)
                  ..setTranslationRaw(0, trans, 0);
              } else if (index == currentPage.floor() - 1) {
                double scale = 1 - (currentPage - index) * (1 - scaleFactor);
                double trans = containerHieght * (1 - scale) / 2;

                matrix = Matrix4.diagonal3Values(1, scale, 1)
                  ..setTranslationRaw(0, trans, 0);
              } else {
                double scale = 0.8;
                matrix = Matrix4.diagonal3Values(1, scale, 1)
                  ..setTranslationRaw(
                      0, containerHieght * (1 - scaleFactor) / 2, 1);
              }

              return CustomAnimation(
                child: widget.pageBuilder(index),
                duration: const Duration(seconds: 1),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, child, double value) {
                  return Transform(
                    transform: matrix,
                    child: widget.pageBuilder(index),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 6,),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.itemCount,
          effect:  JumpingDotEffect(
              dotColor: Colors.black12,
              dotHeight:  4,
              dotWidth: 20,
              spacing: 2,
              jumpScale: 2,
              activeDotColor: ColorsConst.mainColor),
        ),
      ],
    );
  }
}
