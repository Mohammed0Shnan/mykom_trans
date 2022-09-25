
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_orders/util/whatsapp_link_helper.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_kom/generated/l10n.dart';

class ConnectUsScreen extends StatefulWidget {
  const ConnectUsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectUsScreen> createState() => _ConnectUsScreenState();
}
class _ConnectUsScreenState extends State<ConnectUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text(S.of(context)!.contactUs),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.03,),
          Center(
            child: Container(
              width: SizeConfig.screenWidth * 0.5,
              child: Image.asset('assets/new_logo.png'),
            ),

          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1,),
          Center(
            child: Container(
              height: SizeConfig.heightMulti * 8,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      primary:Colors.white,
                    ),
                    onPressed: () {
                      launchUrl( Uri.parse('https://mykom.app/') );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail,color: Colors.blue,),
                        SizedBox(width: 10,),
                        Text('info@mykom.app',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize:
                                SizeConfig.titleSize * 2,
                                fontWeight: FontWeight.w700)),
                      ],
                    )),
              ),
            ),
          ),
          Center(
            child: Container(
              height: SizeConfig.heightMulti * 8,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      primary:Colors.white,
                    ),
                    onPressed: () {
                      double late =  25.1288099;
                      double lon = 56.3264849;
                      var url = WhatsAppLinkHelper.getMapsLink(late,lon);
                      launchUrl(Uri.parse(url));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on,color: Colors.blue,),
                        SizedBox(width: 10,),
                        Text('Fujairah, United Arab Emrates',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize:
                                SizeConfig.titleSize * 2,
                                fontWeight: FontWeight.w700)),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
