import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class PropertyDetails {
  static Future<void> sendPropertyData(String userID,String propertyID,Property proDetails,BuildContext context) async {
    try {
      easyLoading(context);

      await FirebaseFirestore.instance
          .collection("property")
          .doc(userID)
          .collection("user_properties")
          .doc(propertyID)
          .set(proDetails.toJson());

      await FirebaseFirestore.instance
          .collection("all_property")
          .doc(propertyID)
          .set(proDetails.toJson());

      Get.back();
    } catch (e) {
      Get.back();

      if (kDebugMode) {
        print("Error ..... $e");
      }
    }
  }

  static Future<void> deleteData(String propertyId, String userId, BuildContext context) async {
    DocumentReference doc1 = FirebaseFirestore.instance
        .collection("property")
        .doc(userId)
        .collection("user_properties")
        .doc(propertyId);

    DocumentReference doc2 =
    FirebaseFirestore.instance.collection("all_property").doc(propertyId);

    try {
      easyLoading(context);
      await doc1.delete();
      await doc2.delete();
      Get.back();
    } catch (e) {
      Get.back();

      if (kDebugMode) {
        print("Error ..... $e");
      }
    }
  }

}