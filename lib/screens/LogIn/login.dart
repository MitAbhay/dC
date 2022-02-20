import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:dear_canary/models/user_details.dart';
import 'package:dear_canary/screens/UserDetailsEntry/user_basic_details_enrty.dart';

// import 'package:tele_doc/widget/otp_verify.dart';

// Enum created for switching between login and otp verify screen
enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class MobileAuth extends StatefulWidget {
  const MobileAuth({Key? key}) : super(key: key);

  @override
  State<MobileAuth> createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {

  // It will help to switch between login and otp page
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final _otpController = TextEditingController();
  final _mobileController = TextEditingController();

  String verificationId = "";

  // For activating loading screen
  bool showLoading = false;

  int? otp;

  TwilioFlutter? twilioFlutter;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC64eee2ed517fe7b2f43921d88a2b61a4',
        authToken: '7f8c449df436f058fd3b323d9fcbde0d',
        twilioNumber: '+19034184045'
    );
    super.initState();
  }

  void sendOTP (mobileNumber, otp) {
    twilioFlutter!.sendSMS(
        toNumber: mobileNumber,
        messageBody: "Welcome to dear Canary.\nYour One-Time-Password (OTP) is: ${otp}"
    );
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    Future<void> _showMyDialog(errorText) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            content: Text(
              errorText,
              style: const TextStyle(
                fontFamily: "Poppins",

              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    // Login Page
    getMobileFormWidget(context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: mediaQuery.size.height * 0.04,
              ),

              //App Name Text
              const Text(
                "dear\nCanary",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lemon Milk",
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff084d52)
                  // fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(
                height: mediaQueryHeight * 0.1,
              ),

              Container(
                margin:
                EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.075),
                child: Column(
                  children: <Widget>[

                    const SizedBox(
                      height: 10,
                    ),

                    // For taking mobile number from the user
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _mobileController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            // fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            labelText: "Enter your Mobile Number",
                            labelStyle: const TextStyle(
                              fontFamily: "Bebas Neue",
                          // color: Colors.white
                              ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xff084d52),
                                width: 5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 5
                            )
                          )
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mediaQueryHeight * 0.02,
                    ),

                    // OTP button
                    Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          alignment: Alignment.topRight,
                          height: 41,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // color: const Color(0XFF258BD1)
                          ),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xff084d52)),
                              onPressed: () async {
                                if (_mobileController.text.isEmpty){
                                  _showMyDialog("Enter your mobile number");
                                } else {
                                  int randomNumber = Random().nextInt(9000) + 1000 ;
                                  setState(() {
                                    otp = randomNumber;
                                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                                  });
                                  sendOTP(_mobileController.text, otp);
                                }
                              },
                              child: const Center(
                                child: Text(
                                  "OTP",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              )),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // OTP Page
    getOtpFormWidget(context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: mediaQuery.size.height * 0.04,
              ),

              //App Name Text
              const Text(
                "dear\nCanary",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lemon Milk",
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff084d52)
                  // fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(
                height: mediaQueryHeight * 0.1,
              ),

              Container(
                margin:
                EdgeInsets.symmetric(horizontal: mediaQueryWidth * 0.075),
                child: Column(
                  children: <Widget>[

                    const SizedBox(
                      height: 10,
                    ),

                    // For taking OTP from the user
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _otpController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                            labelText: "OTP",
                            labelStyle: const TextStyle(
                              fontFamily: "Bebas Neue",
                              // color: Colors.white
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Color(0xff084d52),
                                    width: 5
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 5
                                )
                            )
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mediaQueryHeight * 0.02,
                    ),

                    // Resend and Verify Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                            onPressed: () async {
                              int randomNumber = Random().nextInt(9000) + 1000 ;
                              setState(() {
                                otp = randomNumber;
                              });
                              sendOTP(_mobileController.text, otp);
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xfffe5a60)
                              ),
                            )
                        ),
                        Container(
                              alignment: Alignment.topRight,
                              height: 41,
                              width: 63,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                // color: const Color(0XFF258BD1)
                              ),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xff084d52)),
                                  onPressed: () async {
                                    if(_otpController.text.isEmpty) {
                                      _showMyDialog("Enter OTP");
                                    } else if (_otpController.text != otp.toString()){
                                      _showMyDialog("Wrong OTP");
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BasicDataEntry()));
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Verify",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  )),
                            ),

                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color(0xffe9e8e8),
            body: Stack(
              children: <Widget>[
                if(!showLoading)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                        "assets/gif/girl_14.gif"
                    ),
                  ),

                Container(
                  child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                      ? getMobileFormWidget(context)
                      : getOtpFormWidget(context),
                )
              ],
            )
        ),
      ),
    );
  }
}
