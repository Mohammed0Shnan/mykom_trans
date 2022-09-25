import 'package:flutter/material.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class ExpadedTextWidget extends StatefulWidget {
  final String text;
   ExpadedTextWidget({required this.text,Key? key}) : super(key: key);

  @override
  State<ExpadedTextWidget> createState() => _ExpadedTextWidgetState();
}

class _ExpadedTextWidgetState extends State<ExpadedTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = SizeConfig.screenHeight / 6;
  @override
  void initState() {
    if(widget.text.length > textHeight ){
      firstHalf = widget.text.substring(0,textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1 , widget.text.length);
    }
    else{
      firstHalf = widget.text;
      secondHalf ='';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty? Text(firstHalf):Column(
        children: [
          Text(hiddenText? firstHalf + '...':firstHalf + secondHalf,
            style: TextStyle(
              height: 1.2,
              fontSize: SizeConfig.titleSize * 2.6,
              fontWeight: FontWeight.w800,
              color: Colors.black45
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText = ! hiddenText;
              });

            },
            child: Row(
              children: [
                Text(hiddenText ?'show more': 'close',style: TextStyle(color: Colors.blue),),
                Icon(hiddenText ? Icons.arrow_drop_down:Icons.arrow_drop_up,color: Colors.blue,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
