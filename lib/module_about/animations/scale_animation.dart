import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_about/bloc/splash_animation_bloc.dart';
import 'package:simple_animations/simple_animations.dart';

class ScaleAnimation extends StatelessWidget {

  final Widget child;
  final int duration;
  const ScaleAnimation(
      {Key? key, required this.child , required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpalshAnimationBloC,bool>(
      bloc: spalshAnimationBloC,
      builder: (context, state) {
        var controller = state?CustomAnimationControl.playReverse: CustomAnimationControl.play;
        return CustomAnimation(
          control:controller ,

          builder: (context, child, double value) {
            return Transform.scale(
              scale:value ,
              child: Opacity(opacity: value,
              child: child,
              ),
            );
          },
          duration: Duration(milliseconds: duration),
          tween: Tween<double>(begin: 1, end: 0),
          child: child,
        );
      },
    );
  }
}