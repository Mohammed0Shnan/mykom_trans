
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class PrivacyMyKomScreen extends StatefulWidget {
  const PrivacyMyKomScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyMyKomScreen> createState() => _PrivacyMyKomScreenState();
}

class _PrivacyMyKomScreenState extends State<PrivacyMyKomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text(S.of(context)!.privacyPolicy),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.03,),
              Center(
                child: Container(
                  width: SizeConfig.screenWidth * 0.5,
                  child: Image.asset('assets/new_logo.png'),
                ),

              ),
              SizedBox(height: SizeConfig.screenHeight * 0.05,),
              Text(S.of(context)!.privacyAppSubTitle,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
              ),
              SizedBox(height: 10,),
              Text(S.of(context)!.privacyAppSubTitle,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
