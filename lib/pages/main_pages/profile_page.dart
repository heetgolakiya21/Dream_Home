import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Get.offAllNamed("/bottom_navigation", arguments: "profile");

        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 10.0, bottom: 13.0),
                    child: Row(
                      children: [
                        Text(
                          "Profiles",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: "nunito",
                              color: MyColors.green3),
                        ),
                      ],
                    ),
                  ),
                  authCon.profileImage == ""
                      ? Container(
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          margin: const EdgeInsets.only(bottom: 15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.white1,
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/common_img/profile1.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 13.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              imageUrl: authCon.profileImage,
                              fit: BoxFit.cover,
                              height: size.width * 0.5,
                              width: size.width * 0.5,
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outlined,
                                color: MyColors.red0,
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: MyColors.green3,
                                  backgroundColor: MyColors.white1,
                                );
                              },
                            ),
                          ),
                        ),
                  Text(
                    authCon.txtName.text.trim(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      fontFamily: "nunito",
                    ),
                  ),
                  Text(
                    authCon.loginEmail != null
                        ? authCon.txtEmail.text.trim()
                        : "${authCon.loginCountryCode} ${authCon.txtPhoneNo.text.trim()}",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey.shade600,
                      fontFamily: "nunito",
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  CustomElevatedButton(
                    onTap: () => Get.toNamed("/add_profile", arguments: "view"),
                    icon: Icons.arrow_forward_ios,
                    text: "Edit Profile",
                  ),
                  CustomElevatedButton(
                    onTap: () => Get.toNamed("/my_property",
                        arguments: "my_property_profile"),
                    icon: Icons.arrow_forward_ios,
                    text: "My Property",
                  ),
                  CustomElevatedButton(
                    onTap: () => Get.toNamed("/property_approve",arguments: "my_property_profile"),
                    icon: Icons.arrow_forward_ios,
                    text: "Property Status",
                  ),
                  CustomElevatedButton(
                    onTap: () => Get.toNamed("/feedback_1"),
                    icon: Icons.arrow_forward_ios,
                    text: "Feedback",
                  ),
                  CustomElevatedButton(
                    onTap: () async => await aboutUs(context),
                    icon: Icons.arrow_forward_ios,
                    text: "About us",
                  ),
                  CustomElevatedButton(
                    onTap: () async => await privacyPolicy(context),
                    icon: Icons.arrow_forward_ios,
                    text: "Privacy Policy",
                  ),
                  CustomElevatedButton(
                    onTap: () {
                      easyLoading(context);
                      authCon.logout().then((value) {
                        Get.back();
                        Get.offAllNamed("/splash");
                      });
                    },
                    icon: Icons.arrow_forward_ios,
                    text: "Logout",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
