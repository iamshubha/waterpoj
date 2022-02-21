import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:waterpoj/view/ui/home_page.dart';

enum PhoneVerificationState { SHOW_PHONE_FORM_STATE, SHOW_OTP_FORM_STATE }

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKeyForSnackBar = GlobalKey();
  PhoneVerificationState currentState =
      PhoneVerificationState.SHOW_PHONE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String verificationIDFromFirebase;
  bool spinnerLoading = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _verifyPhoneButton() async {
    print('Phone Number: ${phoneController.text}');
    setState(() {
      spinnerLoading = true;
    });
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneController.text,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            spinnerLoading = false;
          });
          //TODO: Auto Complete Function
          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            spinnerLoading = false;
          });
          _scaffoldKeyForSnackBar.currentState.showSnackBar(SnackBar(
              content: Text(
                  "Verification Code Failed: ${verificationFailed.message}")));
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            spinnerLoading = false;
            currentState = PhoneVerificationState.SHOW_OTP_FORM_STATE;
            this.verificationIDFromFirebase = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  _verifyOTPButton() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIDFromFirebase,
        smsCode: otpController.text);
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      spinnerLoading = true;
    });
    try {
      final authCredential =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        spinnerLoading = false;
      });
      if (authCredential?.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        // Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        spinnerLoading = false;
      });
      _scaffoldKeyForSnackBar.currentState
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  getPhoneFormWidget(context) {
    return FadeAnimation(
      1.8,
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(51, 140, 146, 252),
                      blurRadius: 20.0,
                      offset: Offset(10, 0))
                ]),
            child: TextField(
              controller: phoneController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixText: "+91  ",
                  border: InputBorder.none,
                  hintText: "   Phone number",
                  suffixIcon: Icon(Icons.phone_android_rounded),
                  hintStyle: TextStyle(color: Colors.grey[400])),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: () => _verifyPhoneButton(),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade900, // background
                onPrimary: Colors.white, // foreground
              ),
              child: const Text("Verify Phone Number")),
        ],
      ),
    );
  }

  getOTPFormWidget(context) {
    return FadeAnimation(
      1.8,
      Column(
        children: [
          const Text(
            "Enter OTP Number",
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(51, 140, 146, 252),
                      blurRadius: 20.0,
                      offset: Offset(10, 0))
                ]),
            child: TextField(
              controller: otpController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                  hintText: "OTP Number",
                  prefixIcon: Icon(Icons.confirmation_number_rounded)),
            ),
            // TextField(
            //   controller: phoneController,
            //   maxLength: 10,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //       prefixText: "+91  ",
            //       border: InputBorder.none,
            //       hintText: "   Phone number",
            //       suffixIcon: Icon(Icons.phone_android_rounded),
            //       hintStyle: TextStyle(color: Colors.grey[400])),
            // ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () => _verifyOTPButton(),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey.shade900, // background
              onPrimary: Colors.white, // foreground
            ),
            child: const Text("Verify OTP Number"),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKeyForSnackBar,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: MediaQuery.of(context).size.height / 5,
                        width: 200,
                        height: 180,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/w.png'))),
                            )),
                      ),
                      // Positioned(
                      //   left: 140,
                      //   width: 80,
                      //   height: 150,
                      //   child: FadeAnimation(
                      //       1.3,
                      //       Container(
                      //         decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //                 image: AssetImage(
                      //                     'assets/images/light-2.png'))),
                      //       )),
                      // ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        // top: 10,
                        // bottom: 0,
                        bottom: 0,
                        right: MediaQuery.of(context).size.width / 2,
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // FadeAnimation(
                      //     1.8,
                      //     Container(
                      //       padding: EdgeInsets.all(5),
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: TextField(
                      //               keyboardType: TextInputType.number,
                      //               decoration: InputDecoration(
                      //                   prefixText: "+91  ",
                      //                   border: InputBorder.none,
                      //                   hintText: "   Phone number",
                      //                   hintStyle:
                      //                       TextStyle(color: Colors.grey[400])),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: EdgeInsets.all(8.0),
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                   border: InputBorder.none,
                      //                   hintText: "Password",
                      //                   hintStyle:
                      //                       TextStyle(color: Colors.grey[400])),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     )),

                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        2,
                        spinnerLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : currentState ==
                                    PhoneVerificationState.SHOW_PHONE_FORM_STATE
                                ? getPhoneFormWidget(context)
                                : getOTPFormWidget(context),

                        // InkWell(
                        //   onTap: () async {
                        //     await FirebaseAuth.instance.verifyPhoneNumber(
                        //       phoneNumber: '+918167777417',
                        //       // verificationCompleted:
                        //       //     (PhoneAuthCredential credential) async {
                        //       //   await FirebaseAuth.instance
                        //       //       .signInWithCredential(credential);
                        //       // },
                        //       // verificationFailed: (FirebaseAuthException e) {
                        //       //   if (e.code == 'invalid-phone-number') {
                        //       //     print(
                        //       //         'The provided phone number is not valid.');
                        //       //   }
                        //       // },
                        //       codeSent: (String verificationId,
                        //           int resendToken) async {
                        //         // Update the UI - wait for the user to enter the SMS code
                        //         String smsCode = '204660';
                        //         // Create a PhoneAuthCredential with the code
                        //         PhoneAuthCredential credential =
                        //             PhoneAuthProvider.credential(
                        //                 verificationId: verificationId,
                        //                 smsCode: smsCode);
                        //         // Sign the user in (or link) with the credential
                        //         await FirebaseAuth.instance
                        //             .signInWithCredential(credential)
                        //             .then((value) => {
                        //                   print(value),
                        //                   log(value
                        //                       .additionalUserInfo.providerId)
                        //                 });
                        //       },
                        //       codeAutoRetrievalTimeout:
                        //           (String verificationId) {},
                        //     );
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         gradient: LinearGradient(colors: [
                        //           Color.fromRGBO(143, 148, 251, 1),
                        //           Color.fromRGBO(143, 148, 251, .6),
                        //         ])),
                        //     child: Center(
                        //       child: Text(
                        //         "Login",
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
