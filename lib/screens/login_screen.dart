import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String smsCode = '';
  String verificationCode = '';
  int? _resendToken;
  String phone = '';
  final _formState = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> authenticateUser(String phoneNumber) async {
    var phone = phoneNumber.substring(1);
    await _auth.verifyPhoneNumber(
      phoneNumber: '+972$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        throw FirebaseAuthException(code: 'Message : ${e.message}');
      },
      codeSent: (verificationId, int? resendToken) {
        verificationCode = verificationId;
        _resendToken = resendToken;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
                verificationId: verificationId,
                smsCode: smsCode,
                phoneNumber: phoneNumber,
                resendToken: _resendToken!),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationCode;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(84, 154, 82, 1);
    const greyShade400 = Color.fromRGBO(122, 121, 121, 1);
    const greyShade700 = Color.fromRGBO(60, 58, 59, 1);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: RadialGradient(
                radius: 1, colors: [greyShade400, greyShade700])),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'חרמ"ש מסייעת',
                style: GoogleFonts.rubikDirt(fontSize: 32, color: primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formState,
                      child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: null,
                          onChanged: (value) {
                            phone = value;
                          }),
                    ),
                    MaterialButton(
                      color: primaryColor,
                      minWidth: 380,
                      onPressed: () async {
                        if (_formState.currentState!.validate()) {
                          await authenticateUser(phone);
                        }
                      },
                      child: const Text("לקבלת קוד חד פעמי"),
                    ),
                  ],
                ),
              ),
              Container(padding: const EdgeInsets.only(top: 24))
            ],
          ),
        ),
      ),
    );
  }
}
