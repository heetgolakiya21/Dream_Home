import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dream_home/model/story.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_home/pages/main_pages/story/story_page.dart';
import 'package:dream_home/pages/main_pages/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authCon = Get.find<AuthController>();
  final RandomPropCon controller = Get.put(RandomPropCon());
  final BotCon botCon = Get.put(BotCon());

  Future<void> pickImage(ImageSource imageSource, Story storyData) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 75);
      if (pickedFile != null) {
        Get.toNamed("/add_story", arguments: {
          "imagePath": pickedFile.path,
          "storyData": storyData,
        });
      } else {
        if (kDebugMode) {
          print("Image not selected .....");
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to pick image ..... $e");
      }
    }
  }

  Stream<List<Story>> retrieveStoryDetails() {
    CollectionReference collection = FirebaseFirestore.instance.collection("story");

    return collection.snapshots().map(
      (querySnapshot) {
        List<Story> stories = [];

        for (var doc in querySnapshot.docs) {
          List<String> imageUri = [];
          List<String> caption = [];

          for (var imgUri in doc["StoryImage"]) {
            imageUri.add(imgUri);
          }

          for (var cap in doc["Caption"]) {
            caption.add(cap);
          }

          stories.add(
            Story(
              uid: doc["UID"],
              caption: caption,
              storyImage: imageUri,
              profileImage: doc["ProfileImage"],
              profileName: doc["ProfileName"],
            ),
          );
        }

        return stories;
      },
    );
  }

  Future<List<List<Map<String, dynamic>>>> getRandomProperties() async {
    final CollectionReference collection = FirebaseFirestore.instance.collection("all_property");
    QuerySnapshot snapshot = await collection.get();

    List<DocumentSnapshot> allDocuments = snapshot.docs.toList();
    allDocuments.shuffle();

    List<Map<String, dynamic>> residentialProperties = [];
    List<Map<String, dynamic>> commercialProperties = [];

    for (var document in allDocuments) {
      var propertyData = document.data() as Map<String, dynamic>;

      if (propertyData["MainType"] == "Residential" &&
          residentialProperties.length < 5) {
        residentialProperties.add(propertyData);
      } else if (propertyData["MainType"] == "Commercial" &&
          commercialProperties.length < 5) {
        commercialProperties.add(propertyData);
      }

      if (residentialProperties.length == 5 &&
          commercialProperties.length == 5) {
        break;
      }
    }

    return [residentialProperties, commercialProperties];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            botCon.onScroll();
            return false;
          },
          child: CustomScrollView(
            controller: botCon.scrollController,
            slivers: <Widget>[
              SliverAppBar(
                stretch: true,
                stretchTriggerOffset: 100.0,
                expandedHeight: 50.0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 0.0),
                  child: Row(
                    children: [
                      Text(
                        "DREAM HOME",
                        style: TextStyle(
                          fontSize: 18.5,
                          color: MyColors.green3,
                          fontWeight: FontWeight.bold,
                          fontFamily: "nunito",
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.toNamed("/property_approve",arguments: "bottom_home"),
                        icon: const Icon(Icons.task_outlined),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 88.0,
                          child: StreamBuilder(
                            stream: retrieveStoryDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Stack(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0),
                                                height: 100.0,
                                                width: 90.0,
                                                decoration: BoxDecoration(
                                                  color: MyColors.white1,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child:
                                                      authCon.profileImage == ""
                                                          ? Image.asset(
                                                              "assets/images/common_img/profile1.png",
                                                              fit: BoxFit.cover,
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl: authCon
                                                                  .profileImage,
                                                              fit: BoxFit.cover,
                                                              errorWidget:
                                                                  (context, url,
                                                                      error) {
                                                                return const Icon(
                                                                  Icons.error,
                                                                );
                                                              },
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                      downloadProgress) {
                                                                return CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                );
                                                              },
                                                            ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0.0,
                                                right: 1.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    color: MyColors.green0,
                                                  ),
                                                  height: 25.0,
                                                  width: 25.0,
                                                  child: Icon(
                                                    Icons.add_outlined,
                                                    size: 25.0,
                                                    color: MyColors.white0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 100.0,
                                            width: 90.0,
                                            margin: const EdgeInsets.only(
                                                left: 7.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              shape: BoxShape.circle,
                                            ),
                                          );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                List<Story> stories = snapshot.data ?? [];

                                if (stories.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: stories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      Story story = stories[index];

                                      return Row(
                                        children: [
                                          index == 0
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    int storyIndex = stories.indexWhere((element) => element.uid == authCon.userid);

                                                    if (storyIndex == -1) {
                                                      await photoDialogue(
                                                        context,
                                                            () {
                                                          pickImage(
                                                            ImageSource.camera,
                                                            Story(
                                                              uid: authCon
                                                                  .userid!,
                                                              caption: [],
                                                              storyImage: [],
                                                              profileImage: authCon
                                                                  .profileImage,
                                                              profileName:
                                                              authCon
                                                                  .txtName
                                                                  .text,
                                                            ),
                                                          );
                                                          Get.back();
                                                        },
                                                            () {
                                                          pickImage(
                                                            ImageSource.gallery,
                                                            Story(
                                                              uid: authCon
                                                                  .userid!,
                                                              caption: [],
                                                              storyImage: [],
                                                              profileImage: authCon
                                                                  .profileImage,
                                                              profileName:
                                                              authCon
                                                                  .txtName
                                                                  .text,
                                                            ),
                                                          );
                                                          Get.back();
                                                        },
                                                      );
                                                    } else {
                                                      await photoDialogue(
                                                        context,
                                                            () {
                                                          pickImage(
                                                            ImageSource.camera,
                                                            stories[storyIndex],
                                                          );
                                                          Get.back();
                                                        },
                                                            () {
                                                          pickImage(
                                                            ImageSource.gallery,
                                                            stories[storyIndex],
                                                          );
                                                          Get.back();
                                                        },
                                                      );
                                                    }
                                                  },
                                                  onDoubleTap: () async {
                                                    int storyIndex = stories.indexWhere((element) => element.uid == authCon.userid);

                                                    if (storyIndex == -1) {
                                                      await photoDialogue(
                                                        context,
                                                        () {
                                                          pickImage(
                                                            ImageSource.camera,
                                                            Story(
                                                              uid: authCon
                                                                  .userid!,
                                                              caption: [],
                                                              storyImage: [],
                                                              profileImage: authCon
                                                                  .profileImage,
                                                              profileName:
                                                                  authCon
                                                                      .txtName
                                                                      .text,
                                                            ),
                                                          );
                                                          Get.back();
                                                        },
                                                        () {
                                                          pickImage(
                                                            ImageSource.gallery,
                                                            Story(
                                                              uid: authCon.userid!,
                                                              caption: [],
                                                              storyImage: [],
                                                              profileImage: authCon.profileImage,
                                                              profileName: authCon.txtName.text,
                                                            ),
                                                          );
                                                          Get.back();
                                                        },
                                                      );
                                                    } else {
                                                      Get.to(
                                                        () => const StoryPage(),
                                                        arguments: {
                                                          "UID": stories[
                                                                  storyIndex]
                                                              .uid,
                                                          "ImageURL": stories[
                                                                  storyIndex]
                                                              .storyImage,
                                                          "Caption": stories[
                                                                  storyIndex]
                                                              .caption,
                                                          "ProfileImage":
                                                              stories[storyIndex]
                                                                  .profileImage,
                                                          "ProfileName":
                                                              stories[storyIndex]
                                                                  .profileName,
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Stack(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10.0),
                                                        height: 100.0,
                                                        width: 90.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              MyColors.white1,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          child: authCon
                                                                      .profileImage ==
                                                                  ""
                                                              ? Image.asset(
                                                                  "assets/images/common_img/profile1.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : CachedNetworkImage(
                                                                  imageUrl: authCon
                                                                      .profileImage,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorWidget:
                                                                      (context,
                                                                          url,
                                                                          error) {
                                                                    return const Icon(
                                                                      Icons
                                                                          .error,
                                                                    );
                                                                  },
                                                                  progressIndicatorBuilder:
                                                                      (context,
                                                                          url,
                                                                          downloadProgress) {
                                                                    return CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress,
                                                                    );
                                                                  },
                                                                ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0.0,
                                                        right: 1.0,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            color:
                                                                MyColors.green0,
                                                          ),
                                                          height: 25.0,
                                                          width: 25.0,
                                                          child: Icon(
                                                            Icons.add_outlined,
                                                            size: 25.0,
                                                            color:
                                                                MyColors.white0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                          stories[index].uid == authCon.userid
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                      () => const StoryPage(),
                                                      arguments: {
                                                        "UID":
                                                            stories[index].uid,
                                                        "ImageURL":
                                                            stories[index]
                                                                .storyImage,
                                                        "Caption":
                                                            stories[index]
                                                                .caption,
                                                        "ProfileImage":
                                                            stories[index]
                                                                .profileImage,
                                                        "ProfileName":
                                                            stories[index]
                                                                .profileName,
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 100.0,
                                                    width: 90.0,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 7.0),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      child: story.profileImage !=
                                                              ""
                                                          ? CachedNetworkImage(
                                                              imageUrl: story
                                                                  .profileImage,
                                                              fit: BoxFit.cover,
                                                              errorWidget:
                                                                  (context, url,
                                                                      error) {
                                                                return Icon(
                                                                  Icons.error,
                                                                  color:
                                                                      MyColors
                                                                          .red0,
                                                                );
                                                              },
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                      downloadProgress) {
                                                                return CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                  color: MyColors
                                                                      .green3,
                                                                );
                                                              },
                                                            )
                                                          : Image.asset(
                                                              "assets/images/common_img/profile1.png",
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await photoDialogue(
                                            context,
                                            () {
                                              pickImage(
                                                ImageSource.camera,
                                                Story(
                                                  uid: authCon.userid!,
                                                  caption: [],
                                                  storyImage: [],
                                                  profileImage:
                                                      authCon.profileImage,
                                                  profileName:
                                                      authCon.txtName.text,
                                                ),
                                              );
                                              Get.back();
                                            },
                                            () {
                                              pickImage(
                                                ImageSource.gallery,
                                                Story(
                                                  uid: authCon.userid!,
                                                  caption: [],
                                                  storyImage: [],
                                                  profileImage:
                                                      authCon.profileImage,
                                                  profileName:
                                                      authCon.txtName.text,
                                                ),
                                              );
                                              Get.back();
                                            },
                                          );
                                        },
                                        child: Stack(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10.0),
                                              height: 100.0,
                                              width: 90.0,
                                              decoration: BoxDecoration(
                                                color: MyColors.white1,
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: authCon.profileImage ==
                                                        ""
                                                    ? Image.asset(
                                                        "assets/images/common_img/profile1.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: authCon
                                                            .profileImage,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return const Icon(
                                                            Icons.error,
                                                          );
                                                        },
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                downloadProgress) {
                                                          return CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0.0,
                                              right: 1.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: MyColors.green0,
                                                ),
                                                height: 25.0,
                                                width: 25.0,
                                                child: Icon(
                                                  Icons.add_outlined,
                                                  size: 25.0,
                                                  color: MyColors.white0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        FutureBuilder(
                          future: getRandomProperties(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              if (snapshot.data!.isNotEmpty) {
                                controller.updateResidentialProperties(snapshot.data![0]);
                                controller.updateCommercialProperties(snapshot.data![1]);

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Residential Property",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "nunito",
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => Get.toNamed(
                                              "/see_all",
                                              arguments: {
                                                "pageType": "Residential",
                                                "routeName": "user",
                                              },
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "See All",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: "nunito",
                                                  ),
                                                ),
                                                Icon(Icons.arrow_right_outlined),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 250.0,
                                      child: Obx(
                                            () => ListView.builder(
                                          itemCount: controller.resPro.length,
                                          scrollDirection: Axis.horizontal,
                                          padding:
                                          const EdgeInsets.only(right: 20.0),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  17.0, 8.0, 0.0, 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    "/show_property",
                                                    arguments: {
                                                      "userId":
                                                      controller.resPro[index]
                                                      ["UserID"],
                                                      "propertyId":
                                                      controller.resPro[index]
                                                      ["PropertyID"],
                                                      "route": "home",
                                                    },
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                        color: MyColors.white0,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade300,
                                                            offset: const Offset(
                                                                2.0, 2.0),
                                                            blurRadius: 7.5,
                                                          ),
                                                        ],
                                                      ),
                                                      width: 150.0,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 150.0,
                                                            margin:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                              color:
                                                              MyColors.green5,
                                                              image:
                                                              DecorationImage(
                                                                image: NetworkImage(
                                                                    "${controller.resPro[index]["Images"][0]}"),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10.0,
                                                                  vertical:
                                                                  3.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${controller.resPro[index]["Type"]}",
                                                                      maxLines: 1,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      style:
                                                                      TextStyle(
                                                                        color: MyColors
                                                                            .green0,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                        fontFamily:
                                                                        "nunito",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10.0,
                                                                  vertical:
                                                                  3.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller.resPro[index]["PriceInString"] !=
                                                                          ""
                                                                          ? "₹ ${controller.resPro[index]["PriceInString"]}"
                                                                          : "₹ ${controller.resPro[index]["RentInString"]}",
                                                                      maxLines: 1,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      style:
                                                                      TextStyle(
                                                                        color: MyColors
                                                                            .green2,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                        fontFamily:
                                                                        "nunito",
                                                                        fontSize:
                                                                        12.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  10.0,
                                                                  vertical:
                                                                  3.0),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .location_on_outlined,
                                                                      size: 11.0,
                                                                      weight:
                                                                      20.0),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${controller.resPro[index]["City"]}",
                                                                      maxLines: 1,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      style:
                                                                      TextStyle(
                                                                        color: MyColors
                                                                            .green0,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                        fontFamily:
                                                                        "nunito",
                                                                        fontSize:
                                                                        11.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: Stack(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/common_img/label.png",
                                                            height: 50.0,
                                                            width: 50.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 7.5,
                                                      bottom: 15.0,
                                                      child: Text(
                                                        controller.resPro[index]
                                                        ["Post"] ==
                                                            "Sell"
                                                            ? "${controller.resPro[index]["Post"]}"
                                                            : "Rent",
                                                        style: TextStyle(
                                                          color: MyColors.white0,
                                                          fontFamily: "nunito",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Commercial Property",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "nunito",
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => Get.toNamed(
                                              "/see_all",
                                              arguments: {
                                                "pageType": "Commercial",
                                                "pageName": "user",
                                              },
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "See All",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: "nunito",
                                                  ),
                                                ),
                                                Icon(Icons.arrow_right_outlined),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 400.0,
                                      child: Obx(
                                            () => ListView.builder(
                                          itemCount: controller.comPro.length,
                                          padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  13.5, 10.0, 13.5, 10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    "/show_property",
                                                    arguments: {
                                                      "userId":
                                                      controller.comPro[index]
                                                      ["UserID"],
                                                      "propertyId":
                                                      controller.comPro[index]
                                                      ["PropertyID"],
                                                      "route": "home",
                                                    },
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                        color: MyColors.white0,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade300,
                                                            offset: const Offset(
                                                                2.0, 2.0),
                                                            blurRadius: 7.5,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 110.0,
                                                            width: 110.0,
                                                            margin:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10.0),
                                                              color:
                                                              MyColors.green5,
                                                              image:
                                                              DecorationImage(
                                                                image: NetworkImage(
                                                                    "${controller.comPro[index]["Images"][0]}"),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        "${controller.comPro[index]["Type"]}",
                                                                        maxLines:
                                                                        1,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style:
                                                                        TextStyle(
                                                                          color: MyColors
                                                                              .green0,
                                                                          fontWeight:
                                                                          FontWeight.w300,
                                                                          fontFamily:
                                                                          "nunito",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                        5.0),
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child: Text(
                                                                        controller.comPro[index]["PriceInString"] !=
                                                                            ""
                                                                            ? "₹ ${controller.comPro[index]["PriceInString"]}"
                                                                            : "₹ ${controller.comPro[index]["RentInString"]}",
                                                                        maxLines:
                                                                        1,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style:
                                                                        TextStyle(
                                                                          color: MyColors
                                                                              .green2,
                                                                          fontWeight:
                                                                          FontWeight.w600,
                                                                          fontFamily:
                                                                          "nunito",
                                                                          fontSize:
                                                                          12.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .location_on_outlined,
                                                                      size: 15.0,
                                                                      weight:
                                                                      20.0,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                        5.0),
                                                                    Expanded(
                                                                      child: Text(
                                                                        "${controller.comPro[index]["Address"]}",
                                                                        maxLines:
                                                                        2,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily:
                                                                          "nunito",
                                                                          fontSize:
                                                                          13.0,
                                                                          color: MyColors
                                                                              .black0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        "${controller.comPro[index]["MainStatus"]}",
                                                                        maxLines:
                                                                        2,
                                                                        overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                        style:
                                                                        TextStyle(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                          fontSize:
                                                                          12.0,
                                                                          fontFamily:
                                                                          "nunito",
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
                                                    Positioned(
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: Stack(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/common_img/label.png",
                                                            height: 50.0,
                                                            width: 50.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 7.5,
                                                      bottom: 15.0,
                                                      child: Text(
                                                        controller.comPro[index]
                                                        ["Post"] ==
                                                            "Sell"
                                                            ? "${controller.comPro[index]["Post"]}"
                                                            : "Rent",
                                                        style: TextStyle(
                                                          color: MyColors.white0,
                                                          fontFamily: "nunito",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                              } else {
                                return Text(
                                  "Data not available.",
                                  style: TextStyle(
                                    fontFamily: "nunito",
                                    fontSize: 15.0,
                                    color: MyColors.black0,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RandomPropCon extends GetxController {
  RxList<Map<String, dynamic>> resPro = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> comPro = <Map<String, dynamic>>[].obs;

  void updateResidentialProperties(List<Map<String, dynamic>> properties) {
    resPro.assignAll(properties);
  }

  void updateCommercialProperties(List<Map<String, dynamic>> properties) {
    comPro.assignAll(properties);
  }
}
