
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/setting_screen.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

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
  int current_index = 2;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true, /// For IOS
      child: Scaffold(

          body: _getActiveScreen(),

          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 8.0 , right:  8.0 , bottom:  8.0 , top: 16.0),
            child: ConvexAppBar(
              style: TabStyle.fixedCircle,
              curve:Curves.easeInOut ,
              cornerRadius: 8.0,
              backgroundColor: Colors.white,
              activeColor: ColorsConst.mainColor,
              color: Colors.black54,

              height: 56.0,
              items: [
                TabItem(

                  isIconBlend: true,
                activeIcon: Icon(Icons.description),
                icon: Icons.description_outlined, title: S.of(context)!.orders,

                ),
                TabItem(
                    isIconBlend: true,
                    activeIcon: Icon(Icons.person),
                    icon:Icons.perm_identity, title: S.of(context)!.profile),
                TabItem(icon:current_index == 2? Icons.home: Icons.home_outlined, title: S.of(context)!.home,

                ),
                TabItem(
                    isIconBlend: true,
                    activeIcon: Icon(Icons.shopping_cart),
                    icon: Icons.shopping_cart_outlined, title: S.of(context)!.ship),
                TabItem(
                    isIconBlend: true,
                    activeIcon: Icon(Icons.widgets),
                    icon: Icons.widgets_outlined, title: S.of(context)!.more),
              ],
              initialActiveIndex: current_index,//optional, default as 0
              onTap: (int index){
                          current_index = index;
                          setState(() {});
              },
            ),
          )
          // bottomNavigationBar: Container(
          //   margin: EdgeInsets.only(bottom:12,right: 12,left: 12),
          //   clipBehavior: Clip.antiAlias,
          //   decoration: BoxDecoration(
          //
          //     borderRadius: BorderRadius.all(Radius.circular(10)),
          //
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //
          //         blurRadius: 3,
          //         spreadRadius: 1
          //       )
          //     ]
          //   ),
          //   child: BottomNavigationBar(
          //     selectedItemColor: ColorsConst.mainColor,
          //       selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          //       unselectedItemColor: ColorsConst.mainColor,
          //       selectedIconTheme:IconThemeData(
          //         size: 26
          //       ) ,
          //       unselectedIconTheme:IconThemeData(
          //           size: 18,
          //         color: ColorsConst.mainColor
          //       ) ,
          //       showSelectedLabels: true,
          //       showUnselectedLabels: true,
          //
          //       currentIndex: current_index,
          //     onTap: (index){
          //           current_index = index;
          //           setState(() {});
          //     },
          //     items: [
          //       BottomNavigationBarItem(
          //         backgroundColor: Colors.white,
          //         label: S.of(context)!.home,
          //         icon: Icon(Icons.home_outlined)),
          //       BottomNavigationBarItem(label:  S.of(context)!.orders,icon: Icon(Icons.description_outlined),
          //         backgroundColor: Colors.white,
          //       ),
          //       BottomNavigationBarItem(label:  S.of(context)!.profile,icon: Icon(Icons.perm_identity),
          //         backgroundColor: Colors.white,
          //       ),
          //       BottomNavigationBarItem(label:  S.of(context)!.ship,icon: Icon(Icons.shopping_cart_outlined),
          //         backgroundColor: Colors.white,
          //       ),
          //       BottomNavigationBarItem(label:  S.of(context)!.more,icon: Icon(Icons.widgets_outlined),
          //         backgroundColor: Colors.white,),
          //     ],
          //   ),
          //),

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

        return  widget.orderScreen;
      }
       case 1 : {

           return widget.profileScreen;
      }
      case 2 : {

          return widget.homeScreen;
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

// class NavigatorScreen extends StatelessWidget {
//   final HomeScreen homeScreen;
//   final CaptainOrdersScreen orderScreen;
//   final ProfileScreen profileScreen ;
//   final ShopScreen shopScreen ;
//   final SettingScreen settingScreen ;
//
//   NavigatorScreen(
//       {required this.homeScreen,required this.orderScreen,required this.profileScreen,
//         required this.settingScreen,required this.shopScreen,
//         Key? key})
//       : super(key: key);
//   PersistentTabController _controller = PersistentTabController(initialIndex: 2);
//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(context),
//       confineInSafeArea: true,
//       backgroundColor: Colors.white, // Default is Colors.white.
//       handleAndroidBackButtonPress: true, // Default is true.
//       resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//       stateManagement: true, // Default is true.
//       hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
//       decoration: NavBarDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         colorBehindNavBar: Colors.white,
//       ),
//       popAllScreensOnTapOfSelectedTab: true,
//       popActionScreens: PopActionScreensType.all,
//       itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
//         duration: Duration(milliseconds: 200),
//         curve: Curves.bounceInOut,
//
//       ),
//
//       screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
//         animateTabTransition: true,
//         curve: Curves.ease,
//         duration: Duration(milliseconds: 200),
//       ),
//       navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
//     );
//   }
//   List<Widget> _buildScreens() {
//     return [
//       orderScreen,
//       profileScreen,
//       homeScreen,
//       shopScreen,
//       settingScreen
//     ];
//   }
//   List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
//     return [
//
//       PersistentBottomNavBarItem(
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             routes: Routes.routes
//         ),
//         icon: Icon(CupertinoIcons.list_number_rtl),
//         title: (S.of(context)!.orders),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             routes: Routes.routes
//         ),
//         icon: Icon(CupertinoIcons.person),
//         title: (S.of(context)!.profile),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             routes: Routes.routes
//         ),
//
//         icon: Icon(Icons.home,color: Colors.white,),
//         title: ( S.of(context)!.home),
//         activeColorPrimary: ColorsConst.mainColor,
//         inactiveColorPrimary: CupertinoColors.white,
//         inactiveIcon: Icon(Icons.home_outlined,color: Colors.white,),
//
//       ),
//       PersistentBottomNavBarItem(
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             routes: Routes.routes
//         ),
//         icon: Icon(CupertinoIcons.cart),
//         title: (S.of(context)!.cart),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             routes: Routes.routes
//         ),
//         icon: Icon(CupertinoIcons.settings),
//         title: (S.of(context)!.settings),
//         activeColorPrimary: CupertinoColors.activeBlue,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//     ];
//   }
// }



