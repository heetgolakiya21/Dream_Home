import 'dart:async';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/user.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthController authCon = Get.find<AuthController>();
  String? status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authCon.getUID();
    status = Utils.userPref!.getString("profile_info_status");
    // for admin
    authCon.loginEmail = Utils.userPref!.getString("login_email");
    authCon.loginPhone = Utils.userPref!.getString("login_phone");
  }

  Future<void> checkedFirstTime() async {
    bool check = Utils.userPref!.getBool("check2") ?? false;

    if (check) {
      if (authCon.userid == null) {
        await Utils.userPref!.setBool("check2", true);

        Timer(
          const Duration(milliseconds: 1000),
          () => Get.offNamed("/login_option"),
        );
      } else if (authCon.userid != null && status == null) {
        Timer(
          const Duration(milliseconds: 1000),
          () => Get.offNamed("/add_profile"),
        );
      } else {
        //  for admin
        if (authCon.loginEmail == Utils.adminEmail || authCon.loginPhone == Utils.adminPhone) {
          Timer(
            const Duration(milliseconds: 1000),
                () => Get.offNamed("/home_a"),
          );
        } else {
          Timer(
            const Duration(milliseconds: 1000),
                () => Get.offNamed("/bottom_navigation"),
          );
        }
      }
    } else {
      await Utils.userPref!.setBool("check2", true);

      Timer(
        const Duration(milliseconds: 1000),
        () => Get.offNamed("/login_option"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: authCon.profileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            authCon
                .saveModel(
                  UserModel(
                    userid: authCon.userid,
                    profileImage: authCon.profileImage,
                    profileName: authCon.txtName.text.trim(),
                    phoneNo: authCon.txtPhoneNo.text.trim(),
                    email: authCon.txtEmail.text.trim(),
                    address: authCon.txtAddress.text.trim(),
                    dialCode: authCon.loginCountryCode,
                    isoCode: authCon.loginIsoCode,
                  ),
                )
                .then(
                  (value) => authCon.getModel(),
                );

            checkedFirstTime();
          } else if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar("Retry"));
          }

          return Container(
            height: double.infinity,
            color: MyColors.green1,
            alignment: Alignment.center,
            child: Lottie.asset(
              "assets/lottie/home_anim.json",
              width: 250.0,
              repeat: false,
            ),
          );
        },
      ),
    );
  }
}
