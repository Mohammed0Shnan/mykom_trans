import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_about/bloc/splash_animation_bloc.dart';
import 'package:simple_animations/simple_animations.dart';

class CustomFadeAnimation extends StatelessWidget {
  final Widget child;
  const CustomFadeAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpalshAnimationBloC, bool>(
      bloc: spalshAnimationBloC,
      builder: (context, state) {
        var controller = state
            ? CustomAnimationControl.play
            : CustomAnimationControl.playReverse;
        return CustomAnimation(
          control: controller,
          builder: (context, child, double value) {
            return Opacity(opacity: value,child: child,);
          },
          duration: Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          child: child,
        );
      },
    );
  }
}
