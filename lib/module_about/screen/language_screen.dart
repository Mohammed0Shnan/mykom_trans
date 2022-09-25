import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/module_about/screen/about_screen.dart';
import 'package:my_kom/module_about/widgets/language_drop_down.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class LanguageScreen extends StatefulWidget {
 final  LocalizationService localizationService ;
 final MapBloc mapBloc ;
 const LanguageScreen({ required this.mapBloc,required this.localizationService, Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    widget.mapBloc.getSubArea();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          child: Container(
            width: SizeConfig.screenWidth,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 120,),
                Hero(
                  tag: 'logo',
                  child: Center(
                    child: Container(
                           height:200,
                           width:200,
                      child: Image.asset('assets/new_oval_logo.png',fit: BoxFit.contain,),
                    ),
                  ),
                ),
                Spacer(),
                ListTile(
                    title: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(S.of(context)!.language,
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                                fontWeight: FontWeight.w600
                            ),

                        )
                    ),
                    subtitle: LangugeDropDownWidget(localizationService: widget.localizationService,)),

                ListTile(
                  title: Container(
                    height:35 ,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),

                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color.fromARGB(255, 28, 174, 147),
                        ),
                        onPressed: () {
                              Navigator.of(context)
                            .push(MaterialPageRoute(builder: (conterxt) {
                          return AboutScreen();
                        }));

                        },
                        child: Text(S.of(context)!.next,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700))),
                  ),
                ),
                SizedBox(height: 80,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
