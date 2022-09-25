import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

Widget menuItem({required IconData icon , required String title,required Function onTap}){
  return GestureDetector(
    onTap:()=>onTap() ,
    child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(  children: [
          Icon(icon,color: ColorsConst.mainColor,size: 4 * SizeConfig.heightMulti,),
          SizedBox(width: 20,),
          Text(title,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.9 * SizeConfig.heightMulti,color: Colors.black45),             )           ],         )),
  );    }