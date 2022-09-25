import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_profile/bloc/profile_bloc.dart';
import 'package:my_kom/generated/l10n.dart';

deleteAccountAlertWidget(context,ProfileBloc bloc){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    content: Container(
      height:200,
      width: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 25,),

          Center(child: Text(S.of(context)!.titleDeleteAccountAlert,textAlign: TextAlign.center,style: GoogleFonts.lato(
              fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black87
          ),)),
          SizedBox(height: 8,),
          Center(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(S.of(context)!.subTitleDeleteAccountAlert,textAlign: TextAlign.center,style: GoogleFonts.lato(
                fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54
            ),),
          )),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(

                onPressed: (){
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child:Container(
                    height: 30,
                    width: 80,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black87,
                        width: 2
                      )
                    ),
                    child: Center(child: Text(S.of(context)!.cancelAccountDeleteAlertButton,style: TextStyle(color: Colors.black87,fontSize:14.0,fontWeight: FontWeight.bold),))),

              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                onPressed: () async{
                  EasyLoading.show();
                  bloc.deleteMyAccount().then((value) {
                    if(value){
                      EasyLoading.showSuccess(S.of(context)!.successDeleteAccount);
                      Navigator.pushNamedAndRemoveUntil(context, AuthorizationRoutes.LOGIN_SCREEN, (route) => false);
                    }else{
                      EasyLoading.showError(S.of(context)!.errorDeleteAccount);

                    }
                  });


                },

                child:Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red,
                        width: 2
                      ),
                      color: Colors.white,

                    ),
                    child: Center(child: Text(S.of(context)!.deleteAccountAlertButton,style: TextStyle(color: Colors.red,fontSize:14.0,fontWeight: FontWeight.bold),))),

              ),
            ],
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

