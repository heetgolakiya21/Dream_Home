import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginOption extends StatefulWidget {
  const LoginOption({super.key});

  @override
  State<LoginOption> createState() => _LoginOptionState();
}

class _LoginOptionState extends State<LoginOption> {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      easyLoading(context);

      final AuthController authCon = Get.find<AuthController>();

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleUser == null && googleAuth == null) {
        Get.back();
        return;
      }

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      authCon.setUID(userCredential.user!.uid);

      await Utils.userPref!
          .setString("login_email", userCredential.user!.email!);

      authCon.loginEmail = Utils.userPref!.getString("login_email");

      Get.back();

      firstTimeUserProfile();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> firstTimeUserProfile() async {
    bool check = Utils.userPref!.getBool("check3") ?? false;

    if (check) {
      Get.offNamed("/bottom_navigation");
    } else {
      await Utils.userPref!.setBool("check3", true);

      Get.offNamed("/add_profile");
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _requestPermissions();
  }

  List<String> imgLst = [
    "assets/images/login_img/Rectangle1.png",
    "assets/images/login_img/Rectangle2.png",
    "assets/images/login_img/Rectangle3.png",
    "assets/images/login_img/Rectangle4.png",
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: width,
              child: Column(
                children: [
                  Expanded(child: photo(imgLst[0], imgLst[1])),
                  const SizedBox(height: 7.5),
                  Expanded(child: photo(imgLst[2], imgLst[3])),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Log in",
                        children: [
                          TextSpan(
                            text: " or ",
                            style: TextStyle(
                              color: MyColors.black0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(text: "Sign up"),
                        ],
                        style: TextStyle(
                          color: MyColors.green3,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Get.toNamed("/login_form"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.green0,
                            foregroundColor: MyColors.white0,
                            fixedSize: const Size(280.0, 56.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call, size: 18.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Continue with Phone",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: MyColors.black0, fontSize: 15.0),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async =>
                              await signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.white0,
                            foregroundColor: MyColors.white0,
                            fixedSize: const Size(90.0, 70.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/common_img/google-layout.png",
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "By continuing, you agree to our ",
                        style: TextStyle(
                          color: MyColors.black0,
                          fontSize: 15.5,
                          fontFamily: "nunito",
                        ),
                      ),
                      TextButton(
                        onPressed: () async => await privacyPolicy(context),
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        ),
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.bold,
                            fontFamily: "nunito",
                            letterSpacing: 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget photo(String url1, String url2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(url1), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          const SizedBox(width: 7.5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(url2), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        ],
      ),
    );
  }
}
