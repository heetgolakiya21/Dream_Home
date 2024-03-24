import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/pages/login_pages/login_form.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class LoginOTP extends StatefulWidget {
  const LoginOTP({super.key});

  @override
  State<LoginOTP> createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  final AuthController authCon = Get.find<AuthController>();
  final TextEditingController txtOtp = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtOtp.dispose();
    super.dispose();
  }

  String? smsCode;

  Future<void> phoneOTP() async {
    try {
      easyLoading(context);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: LoginForm.verifyPhoneOTP,
        smsCode: smsCode!,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      authCon.setUID(FirebaseAuth.instance.currentUser!.uid);

      Get.back();

      firstTimeUserProfile();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> firstTimeUserProfile() async {
    bool check = Utils.userPref!.getBool("check4") ?? false;

    if (check) {
      // for admin
      if (authCon.loginPhone == Utils.adminPhone) {
        Get.offAllNamed("/home_a");
      } else {
        Get.offAllNamed("/bottom_navigation");
      }
    } else {
      await Utils.userPref!.setBool("check4", true);

      Get.offAllNamed("/add_profile");
    }
  }

  String? dc;
  String? iso;
  String? phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dc = Get.arguments["DC"];
    iso = Get.arguments["ISO"];
    phone = Get.arguments["Phone"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: MyColors.white1,
                        ),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                ),
                Lottie.asset("assets/lottie/entercode_anim.json", width: 250.0),
                Text(
                  "Phone Verification",
                  style: TextStyle(
                    color: MyColors.green3,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: "nunito",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Text(
                        "We have sent a verification code to",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "nunito",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "$dc $phone",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Pinput(
                    length: 6,
                    controller: txtOtp,
                    onCompleted: (value) {
                      smsCode = value;
                    },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    enableSuggestions: false,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsRetrieverApi,
                    defaultPinTheme: PinTheme(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 0.5, color: MyColors.black0),
                      ),
                      height: 65.0,
                      width: 65.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.5),
                      textStyle: const TextStyle(fontSize: 20.0),
                    ),
                    textInputAction: TextInputAction.done,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (txtOtp.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar("Enter OTP"));
                    } else {
                      FocusScope.of(context).unfocus();

                      await phoneOTP();
                      authCon.loginPhone = phone;
                      await Utils.userPref!
                          .setString("login_phone", authCon.loginPhone!);
                      authCon.loginPhone =
                          Utils.userPref!.getString("login_phone");
                      authCon.loginCountryCode = dc!;
                      authCon.loginIsoCode = iso!;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.green0,
                    foregroundColor: MyColors.white0,
                    minimumSize: const Size(double.infinity, 50.0),
                    fixedSize: const Size(double.infinity, 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    "Verify phone number",
                    style: TextStyle(
                      fontFamily: "nunito",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
