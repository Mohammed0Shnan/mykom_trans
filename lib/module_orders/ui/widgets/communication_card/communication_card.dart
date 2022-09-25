import 'package:flutter/material.dart';

class CommunicationCard extends StatelessWidget {
 late final String text;
 late final Widget image;
 late final Color textColor;
 late final Color color;

  CommunicationCard({
   required this.text,
   required this.image,
   required this.textColor,
   required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: getBGColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(8),
        child: ListTile(
          title: Text(text, style: TextStyle(color: getTextColor(context)),),
          leading: image,
        )
      ),
    );
  }

  Color getBGColor(BuildContext context) {
    if (color != null) {
      return color;
    }
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;
  }

  Color getTextColor(BuildContext context) {
    if (textColor != null) {
      return textColor;
    }
    return Theme.of(context).brightness != Brightness.light
        ? Colors.white
        : Colors.black;
  }
}

