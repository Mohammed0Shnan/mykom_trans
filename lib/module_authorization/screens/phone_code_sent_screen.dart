
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/bloc/phone_verification_bloc.dart';
import 'package:my_kom/module_authorization/screens/login_automatically.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class PhoneCodeSentScreen extends StatefulWidget {
  final String phoneNumber ;
  final String email;
  final String password;
   PhoneCodeSentScreen({required this.phoneNumber,required this.email,required this.password,Key? key}) : super(key: key);

  @override
  State<PhoneCodeSentScreen> createState() => _PhoneCodeSentScreenState();
}

class _PhoneCodeSentScreenState extends State<PhoneCodeSentScreen> {
   final _confirmationController = TextEditingController();
   final PhoneVerificationBloc _phoneVerificationBloc = PhoneVerificationBloc();

   bool retryEnabled = false;
   bool loading = false;

   @override
  void initState() {
     _phoneVerificationBloc.registerPhoneNumber(widget.phoneNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Form(
    child: Flex(
    direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(
                labelText: S.of(context)!.code,
                hintText: 'OTP',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v!.isEmpty) {
                  return  S.of(context)!.codeIsRequired;
                }
                return null;
              }),
        ),
        SizedBox(height: 10,),
        OutlinedButton(
          onPressed: (){
            _phoneVerificationBloc.registerPhoneNumber(widget.phoneNumber);
          },
          child: Text( S.of(context)!.resendCode),
        ),
       Spacer(),
        BlocConsumer<PhoneVerificationBloc, PhoneVerificationStates>(
          bloc: _phoneVerificationBloc,
          listener: (context,state){
           if(state is PhoneVerificationCurrentState )
             {
               if(state.message == 'CODE SENT'){
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text( S.of(context)!.codeSend),
                 ));
               }else if (state.message == 'CODE TIMEOUT'){
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text(S.of(context)!.codeTimeOut),
                 ));
               }else if(state.message == 'UNAUTHORIZED'){
                 Scaffold.of(context).showBottomSheet((context) => Container(
                   child: Text(S.of(context)!.errorInLogin),
                 ));
               }
             }
           else if(state is PhoneVerificationSuccessState){
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
             LoginAutomatically(email:widget.email, password:widget.password)
             ),(route)=>false);
           }

          }
          ,
            builder:(context,state){

            if(state is PhoneVerificationLoadingState)
              return Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              );
            else
            return Container(
              height: 40,
              width: SizeConfig.screenWidth * 0.4,
              decoration: BoxDecoration(color:ColorsConst.mainColor,
              borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  loading = true;
                  Future.delayed(Duration(seconds: 10), () {
                    loading = false;
                  });

                  setState((){});
                  _phoneVerificationBloc.confirmCaptainCode(_confirmationController.text);

                },
                child:  Center(child: Text(
                  S.of(context)!.confirmCode,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),)
              ),
            );
            }
        ),
        SizedBox(height: 30,),

      ],
    ),
    ),
    );
  }
}


