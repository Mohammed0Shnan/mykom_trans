import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';


loginCheakAlertWidget(context){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20)
    ),
    content: Container(
      height: 210,
      width: SizeConfig.screenWidth * 0.6,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey.shade100
          //   ),
          //   child: IconButton(onPressed: (){
          //     Navigator.pop(context);
          //   }, icon: Icon(Icons.clear,color: Colors.black,)),
          // ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height:100,
            width: double.infinity,

            child: Image.asset('assets/not_login.png',fit: BoxFit.fill,),
          ),
          Center(child: Text(S.of(context)!.notLoggedIN,textAlign: TextAlign.center,style: GoogleFonts.lato(
              fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black54
          ),)),
          Spacer(),
          Container(
            width: double.infinity,
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);

              },
              child:Text(S.of(context)!.login,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),

            ),
          ),
        ],
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

