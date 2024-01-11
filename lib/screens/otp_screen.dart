import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {required this.smsCode,
      required this.verificationId,
      required this.phoneNumber,
      required this.resendToken,
      super.key});

  final int resendToken;
  final String smsCode;
  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String smsCode = '';
  String verificationId = '';

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "This is main screen",
            style: TextStyle(fontSize: 24),
          )
        ],
      ),
    );
  }
}
