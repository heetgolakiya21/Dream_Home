import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePageA extends StatefulWidget {
  const HomePageA({super.key});

  @override
  State<HomePageA> createState() => _HomePageAState();
}

class _HomePageAState extends State<HomePageA> {
  final AuthController authCon = Get.find<AuthController>();
  final RandomPropertiesController controller =
      Get.put(RandomPropertiesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController txtTitle = TextEditingController();
  final TextEditingController txtBody = TextEditingController();
  final TextEditingController txtDes = TextEditingController();

  Future<List<List<Map<String, dynamic>>>> getRandomProperties() async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection("all_property");
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

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtTitle.dispose();
    txtBody.dispose();
    txtDes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: MyColors.white0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                authCon.txtName.text,
                style: TextStyle(
                  fontFamily: "nunito",
                  fontSize: 15.0,
                  color: MyColors.white0,
                ),
              ),
              accountEmail: Text(
                authCon.loginEmail!,
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: MyColors.white0,
                ),
              ),
              currentAccountPicture: authCon.profileImage.isNotEmpty
                  ? CircleAvatar(
                      backgroundColor: MyColors.white0,
                      backgroundImage:
                          CachedNetworkImageProvider(authCon.profileImage),
                    )
                  : CircleAvatar(
                      backgroundColor: MyColors.white0,
                      backgroundImage: const AssetImage(
                          "assets/images/common_img/profile1.png"),
                    ),
              decoration: BoxDecoration(color: MyColors.green2),
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: Text(
                "Edit Profile",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () {
                Get.back();
                Get.toNamed("/add_profile", arguments: "view");
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: Text(
                "Home",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Icon(Icons.request_page_outlined),
              title: Text(
                "Request",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () {
                Get.back();
                Get.toNamed("/request_a");
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: Text(
                "Feedback",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () {
                Get.back();
                Get.toNamed("/feedback_a");
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(
                "Instruction",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () async {
                Get.back();

                txtTitle.clear();
                txtBody.clear();
                txtDes.clear();

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: WillPopScope(
                        onWillPop: () async => false,
                        child: Wrap(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color: MyColors.white0,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Material(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Important Instruction",
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.green0,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => Get.back(),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    MyColors.white0),
                                          ),
                                          icon: const Icon(
                                            Icons.close,
                                            size: 20.0,
                                            weight: 20.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    CustomTextField2(
                                      labelText: "Title",
                                      hintText: "Title",
                                      controller: txtTitle,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                    ),
                                    const SizedBox(height: 10.0),
                                    CustomTextField2(
                                      labelText: "Body",
                                      hintText: "Body",
                                      controller: txtBody,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                    ),
                                    const SizedBox(height: 10.0),
                                    CustomTextField2(
                                      labelText: "Description",
                                      hintText: "Description",
                                      controller: txtDes,
                                      maxLines: 5,
                                      textInputAction: TextInputAction.done,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.text,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomElevatedButton2(
                                          text: "Send",
                                          onPressed: () async {
                                            easyLoading(context);

                                            QuerySnapshot snapshot =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        "all_user_token")
                                                    .get();

                                            Map<String, String> notification = {
                                              "title": txtTitle.text.trim(),
                                              "body": txtBody.text.trim(),
                                            };

                                            for (var data in snapshot.docs) {
                                              var info = {
                                                "to": data["TokenID"],
                                                "priority": "high",
                                                "notification": notification,
                                                "data": {
                                                  "type": "alert",
                                                  "notification": notification,
                                                  "description": txtDes.text.trim()
                                                },
                                              };

                                              var response = await http.post(
                                                Uri.parse(Utils.uri),
                                                body: jsonEncode(info),
                                                headers: {
                                                  "Content-Type":
                                                      Utils.contentType,
                                                  "Authorization":
                                                      Utils.serverID,
                                                },
                                              );

                                              if (kDebugMode) {
                                                print(
                                                    "Response status: ${response.statusCode}");
                                                print(
                                                    "Response body: ${response.body}");
                                              }

                                              Get.back();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(
                "Logout",
                style: TextStyle(fontFamily: "nunito", color: MyColors.black0),
              ),
              onTap: () {
                easyLoading(context);
                authCon.logout().then((value) {
                  Get.back();
                  Get.offAllNamed("/login_option");
                });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _openDrawer(),
          icon: const Icon(Icons.menu_outlined),
        ),
        title: Text(
          "Welcome",
          style: TextStyle(
            fontFamily: "nunito",
            color: MyColors.green2,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getRandomProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                          onTap: () => Get.toNamed("/see_all", arguments: {
                            "pageType": "Residential",
                            "routeName": "admin",
                          }),
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
                        padding: const EdgeInsets.only(right: 17.0),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.fromLTRB(17.0, 8.0, 0.0, 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  "/show_property",
                                  arguments: {
                                    "userId": controller.resPro[index]
                                        ["UserID"],
                                    "propertyId": controller.resPro[index]
                                        ["PropertyID"],
                                    "route": "home",
                                  },
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: MyColors.white0,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          offset: const Offset(2.0, 2.0),
                                          blurRadius: 7.5,
                                        ),
                                      ],
                                    ),
                                    width: 150.0,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150.0,
                                          margin: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: MyColors.green5,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "${controller.resPro[index]["Images"][0]}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 3.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${controller.resPro[index]["Type"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: MyColors.green0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: "nunito",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 3.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller.resPro[index][
                                                                "PriceInString"] !=
                                                            ""
                                                        ? "₹ ${controller.resPro[index]["PriceInString"]}"
                                                        : "₹ ${controller.resPro[index]["RentInString"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: MyColors.green2,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "nunito",
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 3.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 11.0,
                                                    weight: 20.0),
                                                Expanded(
                                                  child: Text(
                                                    "${controller.resPro[index]["City"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: MyColors.green0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: "nunito",
                                                      fontSize: 11.0,
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
                                      controller.resPro[index]["Post"] == "Sell"
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
                              "routeName": "admin",
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
                    height: 450.0,
                    child: Obx(
                      () => ListView.builder(
                        itemCount: controller.comPro.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                                13.5, 10.0, 13.5, 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  "/show_property",
                                  arguments: {
                                    "userId": controller.comPro[index]
                                        ["UserID"],
                                    "propertyId": controller.comPro[index]
                                        ["PropertyID"],
                                    "route": "home",
                                  },
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: MyColors.white0,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          offset: const Offset(2.0, 2.0),
                                          blurRadius: 7.5,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 110.0,
                                          width: 110.0,
                                          margin: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: MyColors.green5,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "${controller.comPro[index]["Images"][0]}"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${controller.comPro[index]["Type"]}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: MyColors.green0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontFamily: "nunito",
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      controller.comPro[index][
                                                                  "PriceInString"] !=
                                                              ""
                                                          ? "₹ ${controller.comPro[index]["PriceInString"]}"
                                                          : "₹ ${controller.comPro[index]["RentInString"]}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: MyColors.green2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "nunito",
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 15.0,
                                                    weight: 20.0,
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  Expanded(
                                                    child: Text(
                                                      "${controller.comPro[index]["Address"]}",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: "nunito",
                                                        fontSize: 13.0,
                                                        color: MyColors.black0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "${controller.comPro[index]["MainStatus"]}",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 12.0,
                                                        fontFamily: "nunito",
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
                                      controller.comPro[index]["Post"] == "Sell"
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
            }
          },
        ),
      ),
    );
  }
}

class RandomPropertiesController extends GetxController {
  RxList<Map<String, dynamic>> resPro = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> comPro = <Map<String, dynamic>>[].obs;

  void updateResidentialProperties(List<Map<String, dynamic>> properties) {
    resPro.assignAll(properties);
  }

  void updateCommercialProperties(List<Map<String, dynamic>> properties) {
    comPro.assignAll(properties);
  }
}
