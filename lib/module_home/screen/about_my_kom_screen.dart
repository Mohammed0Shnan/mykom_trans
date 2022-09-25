
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class AboutMyKomScreen extends StatefulWidget {
  const AboutMyKomScreen({Key? key}) : super(key: key);

  @override
  State<AboutMyKomScreen> createState() => _AboutMyKomScreenState();
}

class _AboutMyKomScreenState extends State<AboutMyKomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text(S.of(context)!.aboutApp),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(S.of(context)!.aboutAppDescription,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
                ))
          ],
        ),
      ),
    );
  }
}
