
import 'package:flutter/material.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

loadingAlertWidget(context){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    content: Center(
      child: Container(
        height: 50,
        width: SizeConfig.screenWidth * 0.2,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: CircularProgressIndicator(),
        )
      ),
    ),

  );

// show the dialog
  showDialog(

    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}