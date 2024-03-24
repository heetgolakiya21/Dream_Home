import 'dart:core';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final AuthController authCon = Get.find<AuthController>();
  final StoryController storyController = StoryController();

  @override
  void dispose() {
    // TODO: implement dispose
    storyController.dispose();
    super.dispose();
  }

  Future<void> deleteStory(String documentId) async {
    await FirebaseFirestore.instance
        .collection("story")
        .doc(documentId)
        .delete();

    Get.back();
  }

  List<StoryItem> _buildStoryItems(
      List<String> imageURLs, List<String> captions) {
    List<StoryItem> storyItems = [];

    for (int index = 0; index < captions.length; index++) {
      storyItems.add(
        StoryItem.inlineImage(
          url: imageURLs[index],
          controller: storyController,
          caption: Text(
            captions[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          imageFit: BoxFit.contain,
          duration: const Duration(milliseconds: 5000),
        ),
      );
    }

    return storyItems;
  }

  List<String>? imageURLs;
  List<String>? captions;
  String? profileImage;
  String? profileName;
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userId = Get.arguments["UID"];
    imageURLs = Get.arguments["ImageURL"];
    captions = Get.arguments["Caption"];
    profileImage = Get.arguments["ProfileImage"];
    profileName = Get.arguments["ProfileName"];

    log("IMG URLS ======> $imageURLs");
    log("CAPTIONS ======> $captions");
    log("PROFILE IMAGE =====> $profileImage");
    log("PROFILE NAME =====> $profileName");
  }

  Future<DocumentSnapshot> getProfile() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("user");

    return await collection.doc(userId).get();
  }

  List<String> profileValues = [
    "ProfileName",
    "PhoneNo",
    "Email",
    "Address",
  ];

  List<String> profileNames = [
    "Property Owner",
    "Phone No.",
    "Email",
    "Address",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            controller: storyController,
            progressPosition: ProgressPosition.top,
            repeat: false,
            inline: true,
            indicatorColor: Colors.grey,
            indicatorForegroundColor: Colors.white,
            onVerticalSwipeComplete: (p0) => Get.back(),
            onComplete: () => Get.back(),
            storyItems: _buildStoryItems(imageURLs!, captions!),
          ),
          Positioned(
            top: 60.0,
            left: 10.0,
            child: GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Wrap(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: MyColors.white0,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        text: "Owner Profile",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "nunito",
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => Get.back(),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                MyColors.white1),
                                      ),
                                      icon: const Icon(
                                        Icons.close,
                                        size: 20.0,
                                        weight: 8.0,
                                      ),
                                    ),
                                  ],
                                ),
                                FutureBuilder(
                                  future: getProfile(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        Map<String, dynamic> data =
                                            snapshot.data!.data()
                                                    as Map<String, dynamic>? ??
                                                {};

                                        return Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              child: Center(
                                                child: Container(
                                                  height: 90.0,
                                                  width: 90.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    image: profileImage != ""
                                                        ? DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                profileImage!),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : const DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/common_img/profile1.png"),
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: profileNames.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Center(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text: profileNames[
                                                                index],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "nunito",
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: data[
                                                              profileValues[
                                                                  index]],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "nunito",
                                                            fontSize: 14.0,
                                                            color:
                                                                MyColors.black0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider();
                                              },
                                            ),
                                            const SizedBox(height: 15.0),
                                          ],
                                        );
                                      } else {
                                        return const Text(
                                            "Profile data not found.");
                                      }
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          snapshot.error.toString(),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Container(
                                          height: 65.0,
                                          width: 65.0,
                                          padding: const EdgeInsets.all(17.0),
                                          child: CircularProgressIndicator(
                                            color: MyColors.green3,
                                            strokeWidth: 2.2,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: profileImage != ""
                        ? CachedNetworkImage(
                            imageUrl: profileImage!,
                            height: 50.0,
                            width: 50.0,
                          )
                        : Image.asset(
                            "assets/images/common_img/profile1.png",
                            height: 50.0,
                            width: 50.0,
                            color: MyColors.white1,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    profileName!,
                    style: TextStyle(
                      color: MyColors.white0,
                      fontFamily: "nunito",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            right: 10.0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: userId == authCon.userid
                ? IconButton(
                    onPressed: () async {
                      await deleteDialog(context, () async {
                        await deleteStory(userId!);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

Future<void> deleteDialog(BuildContext context, VoidCallback? onPressed) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: MyColors.white0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(
          "Delete Story?",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: MyColors.black0,
            fontFamily: "nunito",
          ),
        ),
        content: const Text(
          "All story will be permanently deleted from your story list.",
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black54,
            fontFamily: "nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: MyColors.green3,
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              "Delete",
              style: TextStyle(
                color: MyColors.green0,
                fontFamily: "nunito",
              ),
            ),
          ),
        ],
      );
    },
  );
}
