import 'package:flutter/cupertino.dart';

class SizeConfig {
  static late double screenWidth,
      screenHeight,
      titleSize,
      imageSize,
      heightMulti,
      widhtMulti,
      _blockSizeVertical,
      _blockSizeHorisotal;

  void init(Size size) {
    screenHeight = size.height;
    screenWidth = size.width;
    _blockSizeHorisotal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;
    titleSize = _blockSizeVertical;
    imageSize = _blockSizeHorisotal;
    heightMulti = _blockSizeVertical;
    widhtMulti = _blockSizeHorisotal;
    print('hori : $_blockSizeHorisotal');
    print('vir  : $_blockSizeVertical');
  }
}
