import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/setting_screen.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/generated/l10n.dart';

class NavigatorScreen extends StatefulWidget {
  final HomeScreen homeScreen;
  final CaptainOrdersScreen orderScreen;
  final ProfileScreen profileScreen ;
  final ShopScreen shopScreen ;
  final SettingScreen settingScreen ;

  NavigatorScreen(
      {required this.homeScreen,required this.orderScreen,required this.profileScreen,
        required this.settingScreen,required this.shopScreen,
        Key? key})
      : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int current_index = 0;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(

          body: _getActiveScreen(),


          bottomNavigationBar: Container(
            height: 65,
            margin: EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.all(Radius.circular(10)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,

                  blurRadius: 1,
                  spreadRadius: 1
                )
              ]
            ),
            child: BottomNavigationBar(
              selectedItemColor: ColorsConst.mainColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
                unselectedItemColor: ColorsConst.mainColor,
                selectedIconTheme:IconThemeData(
                  size: 28
                ) ,
                unselectedIconTheme:IconThemeData(
                    size: 18,
                  color: ColorsConst.mainColor.withOpacity(0.5)
                ) ,
                showSelectedLabels: true,
                showUnselectedLabels: true,

                currentIndex: current_index,
              onTap: (index){
                    current_index = index;
                    setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: S.of(context)!.home,
                  icon: Icon(Icons.home_outlined)),
                BottomNavigationBarItem(label:  S.of(context)!.orders,icon: Icon(Icons.description_outlined),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(label:  S.of(context)!.profile,icon: Icon(Icons.perm_identity),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(label:  S.of(context)!.ship,icon: Icon(Icons.shopping_cart_outlined),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(label:  S.of(context)!.more,icon: Icon(Icons.widgets_outlined),
                  backgroundColor: Colors.white,),
              ],
            ),
          ),

      ),
    );
  }
 Color _getNavItemColor(){
   if(current_index ==0)
     return Colors.blue;

   else if(current_index == 1)
     return Colors.red;

   else if(current_index == 2)
     return Colors.amberAccent;


   else
     return Colors.purpleAccent;
 }
 _getActiveScreen(){
    switch(current_index){
      case 0 : {
        return widget.homeScreen;
      }
       case 1 : {
           return widget.orderScreen;
      }
      case 2 : {
          return widget.profileScreen;
      }
      case 3 : {
        return widget.shopScreen;
      }
      case 4:{
        return widget.settingScreen;
      }
    }
  }
}
