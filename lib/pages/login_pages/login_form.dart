import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final AuthController authCon = Get.find<AuthController>();
  final TextEditingController txtPhone = TextEditingController();

  static String verifyPhoneOTP = "";

  Future<void> phoneAuthentication(BuildContext context) async {
    try {
      easyLoading(context);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: (authCon.loginCountryCode + txtPhone.text),
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(snackBar(error.message!));
        },
        codeSent: (verificationId, forceResendingToken) {
          LoginForm.verifyPhoneOTP = verificationId;

          Get.back();

          Get.toNamed(
            "/login_otp",
            arguments: {
              "ISO": authCon.loginIsoCode,
              "DC": authCon.loginCountryCode,
              "Phone": txtPhone.text.trim(),
            },
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar("OTP Send"));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          Get.back();
        },
      );
    } catch (e) {
      Get.back();
    }
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
                Lottie.asset("assets/lottie/enterphone_anim.json",
                    width: 250.0),
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
                  child: Text(
                    "We need to register your phone before getting started !",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "nunito",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 5.0),
                  child: Container(
                    height: 60.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MyColors.black0,
                        width: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          textFieldController: txtPhone,
                          initialValue: authCon.number,
                          onInputChanged: (value) {
                            authCon.loginCountryCode =
                                value.dialCode.toString();
                            authCon.loginIsoCode = value.isoCode.toString();
                            authCon.number = PhoneNumber(
                              isoCode: value.isoCode.toString(),
                              dialCode: value.dialCode.toString(),
                              phoneNumber: txtPhone.text,
                            );
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            useBottomSheetSafeArea: true,
                          ),
                          inputDecoration: const InputDecoration(
                            hintText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "nunito",
                            ),
                            border: InputBorder.none,
                          ),
                          textStyle: TextStyle(
                            color: MyColors.black0,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "nunito",
                          ),
                          selectorTextStyle: TextStyle(
                            color: MyColors.black0,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "nunito",
                          ),
                          searchBoxDecoration: const InputDecoration(
                            hintText: "Search Your Country",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: "nunito",
                            ),
                            border: UnderlineInputBorder(),
                          ),
                          textAlignVertical: TextAlignVertical.top,
                          cursorColor: MyColors.green1,
                          keyboardAction: TextInputAction.send,
                          keyboardType: TextInputType.phone,
                          onSubmit: () async {
                            if (txtPhone.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Enter Phone No."));
                            } else {
                              FocusScope.of(context).unfocus();

                              await phoneAuthentication(context);
                            }
                          },
                        ),
                        Positioned(
                          left: 100.0,
                          top: 8.0,
                          bottom: 8.0,
                          child: Container(
                            height: 40.0,
                            width: 1.0,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (txtPhone.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar("Enter Phone No."));
                      } else {
                        FocusScope.of(context).unfocus();

                        await phoneAuthentication(context);
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
                      "Send the code",
                      style: TextStyle(
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                      ),
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
