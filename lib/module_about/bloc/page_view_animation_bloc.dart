import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';


class PageViewAnimationBloc extends Cubit<double>{
  double crrnetPage =0;
  final PageController pageController ;
  PageViewAnimationBloc(this.pageController) : super(0.0){
    pageController.addListener(() {
      crrnetPage = pageController.page!;
     // ignore: void_checks
      onScroll(crrnetPage);
      
    });
  }
  onScroll(double s)=> emit(s);
}
