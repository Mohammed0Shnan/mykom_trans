
import 'package:flutter/material.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class NoDataForDisplayWidget extends StatelessWidget {
  const NoDataForDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: SizeConfig.screenHeight * 0.3,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Image.asset('assets/empity.png',fit: BoxFit.fill,)),
            SizedBox(height: 10,),
            Text(S.of(context)!.noDataToDisplay,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45),)
          ],
        ));
  }
}
