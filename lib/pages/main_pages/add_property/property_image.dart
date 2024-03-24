import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/pages/main_pages/add_property/property_status.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class PropertyImage extends StatefulWidget {
  const PropertyImage({super.key});

  @override
  State<PropertyImage> createState() => _PropertyImageState();
}

class _PropertyImageState extends State<PropertyImage> {
  final AuthController authCon = Get.find<AuthController>();
  final ImageCon imgCon = Get.put(ImageCon());
  final TextEditingController txtDescription = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtDescription.dispose();
    super.dispose();
  }

  Property? prDetails;
  String? mainType;
  Property? typo;
  Property? location;
  Property? priceRent;
  String? subStatus;
  String? mainStatus;

  String? pageInfo;

  String? propertyID;
  String? userID;
  String? pst;

  Map<String, dynamic>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageInfo = Get.arguments["pageInfo"];

    if (Get.arguments["pageInfo"] != "property_residential" &&
        Get.arguments["pageInfo"] != "property_commercial") {
      prDetails = Get.arguments["proDetails"];
      mainType = Get.arguments["mainType"];
      typo = Get.arguments["post/type"];
      location = Get.arguments["location"];
      priceRent = Get.arguments["price/rent"];
      subStatus = Get.arguments["SubStatus"];
      mainStatus = Get.arguments["MainStatus"];
    } else {
      propertyID = Get.arguments["propertyId"];
      userID = Get.arguments["userId"];
      prDetails = Get.arguments["proDetails"];
      pst = Get.arguments["post/type"];
      mainType = Get.arguments["mainType"];
      priceRent = Get.arguments["price/rent"];
      subStatus = Get.arguments["SubStatus"];
      mainStatus = Get.arguments["MainStatus"];

      data = Get.arguments["data"];

      txtDescription.text = Get.arguments["data"]["Description"];

      imgCon.updatedImageLink.value = Get.arguments["data"]["Images"];
    }
  }

  Future<void> saveProperty(List<File> imageFiles) async {
    List<String> imageUrls = [];

    final storage = FirebaseStorage.instance.ref().child("property_images");

    easyLoading(context);

    for (int i = 0; i < imageFiles.length; i++) {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      File imageFile = imageFiles[i];

      try {
        await storage.child(fileName).putFile(imageFile);

        String downloadURL = await storage.child(fileName).getDownloadURL();

        imageUrls.add(downloadURL);
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading image ..... $e");
        }
      }
    }

    String propertyID = DateTime.now().millisecondsSinceEpoch.toString();

    Property prDet = Property(
      userID: authCon.userid,
      propertyID: propertyID,
      paymentID: "",
      verificationStatus: "pending",
      reason: "",
      expectedPrice: priceRent!.expectedPrice,
      priceRentNegotiable: priceRent!.priceRentNegotiable,
      bookingToken: priceRent!.bookingToken,
      maintenanceCharge: priceRent!.maintenanceCharge,
      securityAmt: priceRent!.securityAmt,
      priceInString: priceRent!.priceInString,
      rentInString: priceRent!.rentInString,
      monthRent: priceRent!.monthRent,
      country: location!.country,
      city: location!.city,
      state: location!.state,
      address: location!.address,
      fullAddress: location!.fullAddress,
      mainType: mainType,
      type: typo!.type,
      post: typo!.post,
      subStatus: subStatus,
      mainStatus: mainStatus,
      superAreaUnit: prDetails!.superAreaUnit,
      superArea: prDetails!.superArea,
      carpetAreaUnit: prDetails!.carpetAreaUnit,
      carpetArea: prDetails!.carpetArea,
      balcony: prDetails!.balcony,
      furnishing: prDetails!.furnishing,
      yourFloor: prDetails!.yourFloor,
      bathroom: prDetails!.bathroom,
      bedroom: prDetails!.bedroom,
      roadWidth: prDetails!.roadWidth,
      plotArea: prDetails!.plotArea,
      boundaryWall: prDetails!.boundaryWall,
      roadFacing: prDetails!.roadFacing,
      cornerShop: prDetails!.cornerShop,
      noAllowCon: prDetails!.noAllowCon,
      openSides: prDetails!.openSides,
      pantryCafeteria: prDetails!.pantryCafeteria,
      plotAreaUnit: prDetails!.plotAreaUnit,
      plotBreadth: prDetails!.plotBreadth,
      plotLength: prDetails!.plotLength,
      totalFloor: prDetails!.totalFloor,
      washroom: prDetails!.washroom,
      images: imageUrls,
      description: txtDescription.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection("property_status")
        .add(prDet.toJson());

    Get.back();

    Get.offAllNamed("/property_approve");
  }

  Future<void> updateProperty(List imageFiles) async {
    easyLoading(context);

    Property proDetails = Property(
      verificationStatus: data!["VerificationStatus"],
      reason: data!["Reason"],
      userID: userID,
      propertyID: propertyID,
      paymentID: data!["PaymentID"],
      images: imageFiles,
      priceInString: priceRent!.priceInString,
      rentInString: priceRent!.rentInString,
      bedroom: prDetails!.bedroom,
      bathroom: prDetails!.bathroom,
      balcony: prDetails!.balcony,
      totalFloor: prDetails!.totalFloor,
      yourFloor: prDetails!.yourFloor,
      furnishing: prDetails!.furnishing,
      carpetArea: prDetails!.carpetArea,
      carpetAreaUnit: prDetails!.carpetAreaUnit,
      superArea: prDetails!.superArea,
      superAreaUnit: prDetails!.superAreaUnit,
      description: txtDescription.text,
      post: data!["Post"],
      mainType: data!["MainType"],
      type: data!["Type"],
      country: data!["Country"],
      state: data!["State"],
      city: data!["City"],
      address: data!["Address"],
      fullAddress: data!["FullAddress"],
      roadWidth: prDetails!.roadWidth,
      noAllowCon: prDetails!.noAllowCon,
      openSides: prDetails!.openSides,
      boundaryWall: prDetails!.boundaryWall,
      plotArea: prDetails!.plotArea,
      plotAreaUnit: prDetails!.plotAreaUnit,
      plotLength: prDetails!.plotLength,
      plotBreadth: prDetails!.plotBreadth,
      pantryCafeteria: prDetails!.pantryCafeteria,
      washroom: prDetails!.washroom,
      cornerShop: prDetails!.cornerShop,
      roadFacing: prDetails!.roadFacing,
      expectedPrice: priceRent!.expectedPrice,
      priceRentNegotiable: priceRent!.priceRentNegotiable,
      bookingToken: priceRent!.bookingToken,
      subStatus: subStatus,
      mainStatus: mainStatus,
      monthRent: priceRent!.monthRent,
      securityAmt: priceRent!.securityAmt,
      maintenanceCharge: priceRent!.maintenanceCharge,
    );

    await FirebaseFirestore.instance
        .collection("property")
        .doc(authCon.userid)
        .collection("user_properties")
        .doc(propertyID)
        .set(proDetails.toJson());

    await FirebaseFirestore.instance
        .collection("all_property")
        .doc(propertyID)
        .set(proDetails.toJson());

    if (kDebugMode) {
      print("Property updated .....");
    }

    Get.back();

    Get.offNamed("/show_property", arguments: {
      "userId": userID,
      "propertyId": propertyID,
    });
  }

  void backPress() {
    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      Get.back();
    } else {

print("iiiiiiiiiiiiiiiiiiiiiiiiiiii $mainType");

      Get.off(() => const PropertyStatus(), arguments: {
        "pageInfo": pageInfo,
        "propertyId": propertyID,
        "userId": userID,
        "proDetails": prDetails,
        "data": data,
        "post/type": pst,
        "price/rent": priceRent,
        "mainType": mainType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        backPress();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => backPress(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(MyColors.white1),
                        ),
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          size: 20.0,
                          weight: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Upload your property images",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => (pageInfo != "property_residential" &&
                          pageInfo != "property_commercial")
                      ? Expanded(
                          child: GridView.builder(
                            itemCount: imgCon.selectedImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3.0,
                              mainAxisSpacing: 3.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.file(
                                      File(imgCon.selectedImages[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.0,
                                    right: 5.0,
                                    child: SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete_outlined),
                                        style: IconButton.styleFrom(
                                          backgroundColor: MyColors.white0,
                                        ),
                                        iconSize: 15.0,
                                        onPressed: () =>
                                            imgCon.deleteImage(index),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            itemCount: imgCon.updatedImageLink.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3.0,
                              mainAxisSpacing: 3.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${imgCon.updatedImageLink[index]}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.0,
                                    right: 5.0,
                                    child: SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete_outlined),
                                        style: IconButton.styleFrom(
                                          backgroundColor: MyColors.white0,
                                        ),
                                        iconSize: 15.0,
                                        onPressed: () async {
                                          easyLoading(context);

                                          imgCon.updatedImageLink
                                              .removeAt(index);

                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 10.0),
                CustomTextField2(
                  controller: txtDescription,
                  maxLines: 3,
                  maxLength: 200,
                  labelText: "Description (optional)",
                  hintText: "Description",
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton2(
                          text: "ADD IMAGES",
                          onPressed: () {
                            if (pageInfo != "property_residential" &&
                                pageInfo != "property_commercial") {
                              imgCon.pickImages1(context);
                            } else {
                              imgCon.pickImages2(context);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Visibility(
                        visible: (pageInfo == "property_residential" ||
                            pageInfo == "property_commercial"),
                        child: Expanded(
                          child: CustomElevatedButton2(
                            text: "UPDATE",
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              List lst = imgCon.updatedImageLink.toList();
                              if (imgCon.updatedImageLink.length >= 4 &&
                                  imgCon.updatedImageLink.length <= 10) {
                                updateProperty(lst);
                              } else {
                                if (imgCon.updatedImageLink.length <= 4) {
                                  snackbar(
                                    "Minimum Images Not Reached",
                                    "Select at least 4 images.",
                                  );
                                } else {
                                  snackbar(
                                    "Image Limit Exceeded",
                                    "You can only select up to 10 images.",
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (pageInfo != "property_residential" &&
                            pageInfo != "property_commercial"),
                        child: Expanded(
                          child: CustomElevatedButton2(
                            text: "CONTINUE",
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (imgCon.selectedImages.length >= 4) {
                                await saveProperty(imgCon.selectedImages);
                              } else {
                                snackbar(
                                  "Minimum Images Not Reached",
                                  "Select at least 4 images.",
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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

class ImageCon extends GetxController {
  RxList<File> selectedImages = <File>[].obs;

  Future<void> pickImages1(BuildContext context) async {
    int remainingSlots = 10 - selectedImages.length;
    int minimumRequired = 4;

    if (remainingSlots > 0) {
      List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
        imageQuality: 45,
        maxHeight: 800,
        maxWidth: 1000,
      );

      if (pickedFiles.isNotEmpty) {
        int additionalImages = pickedFiles.length;

        if (selectedImages.length + additionalImages > 10) {
          additionalImages = 10 - selectedImages.length;

          snackbar(
            "Image Limit Exceeded",
            "You can only select up to 10 images.",
          );
        }

        if (selectedImages.length + additionalImages >= minimumRequired) {
          selectedImages.addAll(
            pickedFiles
                .sublist(0, additionalImages)
                .map((file) => File(file.path)),
          );
        } else {
          snackbar(
            "Minimum Images Not Reached",
            "Select at least 4 images.",
          );
        }
      }
    } else {
      snackbar(
        "Image Limit Exceeded",
        "You can only select up to 10 images.",
      );
    }
  }

  void deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  // -----------------------------------------------------------------------------------------------------

  RxList<dynamic> updatedImageLink = [].obs;

  Future<void> pickImages2(BuildContext context) async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 45,
      maxHeight: 800,
      maxWidth: 1000,
    );

    if (pickedFiles.isNotEmpty) {
      List<File> selectedFiles =
          pickedFiles.map((file) => File(file.path)).toList();

      try {
        List<String> imageUrls = await uploadImages(selectedFiles, context);

        updatedImageLink.addAll(imageUrls);
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading images ..... $e");
        }
      }
    }
  }

  Future<List<String>> uploadImages(
      List<File> files, BuildContext context) async {
    List<String> imageUrls = [];

    final storage = FirebaseStorage.instance.ref().child("property_images");

    for (int i = 0; i < files.length; i++) {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      File imageFile = files[i];

      try {
        easyLoading(context);

        await storage.child(fileName).putFile(imageFile);

        String downloadURL = await storage.child(fileName).getDownloadURL();

        imageUrls.add(downloadURL);

        Get.back();
      } catch (e) {
        Get.back();

        if (kDebugMode) {
          print("Error uploading image ..... $e");
        }

        throw e;
      }
    }

    return imageUrls;
  }
}
