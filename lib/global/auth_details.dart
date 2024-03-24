import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/user.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthController extends GetxController {
  // USER ID --------------------------------------------------------------------

  String? userid;

  Future<void> setUID(String uid) async {
    await Utils.userPref!.setString("uid", uid);
  }

  Future<void> getUID() async {
    userid = Utils.userPref!.getString("uid");

    if (kDebugMode) print("User ID ..... $userid");
  }

  // EMAIL AUTHENTICATION --------------------------------------------------------------------

  String? loginEmail;

  // PHONE AUTHENTICATION --------------------------------------------------------------------

  String? loginPhone;

  String loginCountryCode = "";

  String loginIsoCode = "";

  PhoneNumber number =
      PhoneNumber(isoCode: "IN", dialCode: "+91", phoneNumber: "");

  // PHOTO ---------------------------------------------------------------------------------------

  String? imagePath;
  String profileImage = "";

  Function? reference;

  void allUpdate(Function ref) {
    reference = ref;
  }

  Future<void> pickImage(ImageSource imageSource, BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
      if (pickedFile != null) {
        imagePath = pickedFile.path;

        uploadImage(context);

        reference!();
      } else {
        if (kDebugMode) print("Image not selected .....");
      }
    } on PlatformException catch (e) {
      if (kDebugMode) print("Failed to pick image ..... $e");
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (imagePath != null) {
      try {
        easyLoading(context);

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        Reference imageDir =
            FirebaseStorage.instance.ref().child("profile_images");
        Reference upload = imageDir.child(fileName);

        await upload.putFile(File(imagePath!));

        profileImage = await upload.getDownloadURL();

        reference!();

        Get.back();
      } catch (e) {
        Get.back();
      }
    }
  }

  // ADD USER DATA INTO DATABASE --------------------------------------------------------------------

  var txtName = TextEditingController();
  var txtPhoneNo = TextEditingController();
  var txtEmail = TextEditingController();
  var txtAddress = TextEditingController();

  Future<void> addUserDetails(UserModel user, BuildContext context) async {
    try {
      easyLoading(context);
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userid)
          .set(user.toJson());

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  // RETRIEVE DATA FROM DATABASE --------------------------------------------------------------------

  Future<void> profileData() async {
    if (userid != null) {
      try {
        CollectionReference collection =
            FirebaseFirestore.instance.collection("user");

        QuerySnapshot querySnapshot =
            await collection.where("UID", isEqualTo: userid).get();

        for (var doc in querySnapshot.docs) {
          profileImage = doc["ProfileImage"];
          txtName.text = doc["ProfileName"];
          txtPhoneNo.text = doc["PhoneNo"];
          txtEmail.text = doc["Email"];
          txtAddress.text = doc["Address"];
          loginCountryCode = doc["DC"];
          loginIsoCode = doc["ISO"];
        }
      } catch (e) {
        if (kDebugMode) print("Error ..... $e");
      }
    }
  }

  // RETRIEVE DATA FROM DATABASE AND ADD IT INTO SHARED PREFERENCE --------------------------------------------------------------------

  Future<void> saveModel(UserModel user) async {
    if (userid != null) {
      String jsonEncoded = jsonEncode(user.toJson());
      await Utils.userPref!.setString("save_data", jsonEncoded);
    }
  }

  // GET DATA FROM SHARED PREFERENCE --------------------------------------------------------------------

  Future<UserModel?> getModel() async {
    if (userid != null) {
      Map<String, dynamic> jsonDecoded =
          jsonDecode(Utils.userPref!.getString("save_data")!);
      if (kDebugMode) print("jsonDecoded ..... $jsonDecoded");

      UserModel user = UserModel.fromJson(jsonDecoded);

      if (jsonDecoded.isNotEmpty) {
        profileImage = user.profileImage;
        txtName.text = user.profileName;
        txtPhoneNo.text = user.phoneNo;
        txtEmail.text = user.email;
        txtAddress.text = user.address;
        loginCountryCode = user.dialCode;
        loginIsoCode = user.isoCode;
      }
    }

    return null;
  }

  // LOGOUT --------------------------------------------------------------------

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();

    userid = null;
    txtName.text = "";
    txtEmail.text = "";
    txtPhoneNo.text = "";
    txtAddress.text = "";
    loginCountryCode = "";
    loginIsoCode = "";
    profileImage = "";
    loginEmail = null;
    loginPhone = null;

    await Utils.userPref!.remove("check2");
    await Utils.userPref!.remove("check3");
    await Utils.userPref!.remove("check4");
    await Utils.userPref!.remove("uid");
    await Utils.userPref!.remove("save_data");
    await Utils.userPref!.remove("login_phone");
    await Utils.userPref!.remove("login_email");
    await Utils.userPref!.remove("profile_info_status");
    // Utils.userPref!.clear();
  }
}
