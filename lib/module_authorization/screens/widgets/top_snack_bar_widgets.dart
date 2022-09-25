
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

snackBarSuccessWidget(BuildContext context ,String message ){
showTopSnackBar(
context,
CustomSnackBar.info(
backgroundColor: ColorsConst.mainColor,
icon: Icon(Icons.location_on),
message: message,
),
displayDuration: Duration(seconds: 2),

);}

snackBarErrorWidget(BuildContext context ,String message ){
  showTopSnackBar(
    context,
    CustomSnackBar.error(
      icon: Icon(Icons.location_on),
      message: message,
    ),
    displayDuration: Duration(seconds: 2),

  );}

snackBarInfoWidget(BuildContext context ,String message ){
  showTopSnackBar(
    context,
    CustomSnackBar.info(
      backgroundColor: ColorsConst.mainColor,
      icon: Icon(Icons.location_on),
      message: message,
    ),
    displayDuration: Duration(seconds: 2),

  );}