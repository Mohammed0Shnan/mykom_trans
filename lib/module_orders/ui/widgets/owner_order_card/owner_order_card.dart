import 'package:flutter/material.dart';

class OwnerOrderCard extends StatelessWidget {
late  final String from;
 late final String to;
 late final String time;
 late final int index;

  OwnerOrderCard({
   required this.time,
   required this.from,
  required  this.to,
  required  this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Card(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(0),
    //   ),
    //   elevation: 0,
    //   color: index == 0
    //       ? AppThemeDataService.PrimaryColor
    //       : Theme.of(context).brightness == Brightness.light
    //           ? Colors.white
    //           : Colors.black,
    //   child: Container(
    //     padding: EdgeInsets.all(10),
    //     height: 115,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'to $to',
    //               style: TextStyle(
    //                   color: index == 0
    //                       ? Colors.white
    //                       : AppThemeDataService.PrimaryColor,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 10),
    //             ),
    //             Text(
    //               '$from',
    //               style: TextStyle(
    //                   color: index == 0
    //                       ? Colors.white
    //                       : AppThemeDataService.PrimaryColor,
    //                   fontSize: 10),
    //             ),
    //             Text(
    //               'time: $time',
    //               style: TextStyle(
    //                   color: index == 0
    //                       ? Colors.white
    //                       : AppThemeDataService.PrimaryColor,
    //                   fontSize: 10),
    //             ),
    //           ],
    //         ),
    //         Center(
    //           child: CircleAvatar(
    //             backgroundColor: index == 0
    //                 ? Colors.white
    //                 : AppThemeDataService.PrimaryColor,
    //             child: Icon(
    //               Icons.arrow_forward,
    //               color: index == 0
    //                   ? AppThemeDataService.PrimaryColor
    //                   : Colors.white,
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
