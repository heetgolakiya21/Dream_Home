import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/pages/main_pages/bottom_navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MyProperty extends StatefulWidget {
  const MyProperty({super.key});

  @override
  State<MyProperty> createState() => _MyPropertyState();
}

class _MyPropertyState extends State<MyProperty> {
  final AuthController authCon = Get.find<AuthController>();
  final MyProCon proCon = Get.put(MyProCon());
  final BotCon botCon = Get.put(BotCon());

  Widget customRadioButton(String text, int index) {
    return GestureDetector(
      onTap: () => proCon.setValue(index),
      child: Obx(
        () => Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: (proCon.selectedIndex == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (proCon.selectedIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: (proCon.selectedIndex == index.obs)
                    ? MyColors.green3
                    : Colors.grey.shade600,
                fontFamily: "nunito",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPropertyList(List<Map<String, dynamic>> propertyList) {
    List<Map<String, dynamic>> filteredList = propertyList.where((property) {
      return property["Post"] ==
          (proCon.selectedIndex == 0.obs ? "Sell" : "Rent / Lease");
    }).toList();

    if (filteredList.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lottie/no_property.json",
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              const SizedBox(height: 10.0),
              Text(
                proCon.selectedIndex == 0.obs
                    ? "You have not added any Sell property"
                    : "You have not added any Rent/Lease property",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          controller: botCon.scrollController,
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            var data = filteredList[index];

            String priceRent = "";

            if (data["RentInString"] != "") {
              priceRent = data["RentInString"];
            } else {
              priceRent = data["PriceInString"];
            }

            String fullAddress = data["FullAddress"].replaceAll("/", ",");

            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  "/show_property",
                  arguments: {
                    "userId": data["UserID"],
                    "propertyId": data["PropertyID"],
                  },
                );
              },
              child: Card(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                ),
                elevation: 3.0,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: MyColors.white0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 170.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey.shade100,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                imageUrl: data["Images"][0],
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return const Icon(
                                    Icons.error,
                                  );
                                },
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) {
                                  return Center(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: CircularProgressIndicator(
                                        color: MyColors.green3,
                                        strokeWidth: 2.2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${data["Type"]}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          color: MyColors.green0,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(fontSize: 17.0),
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: 15.0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " $fullAddress",
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          color: Colors.grey.shade700,
                                          fontSize: 13.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  "₹ $priceRent",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "nunito",
                                    color: MyColors.green3,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
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
                        data["Post"] == "Sell" ? "Sell" : "Rent",
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
          scrollDirection: Axis.vertical,
        ),
      );
    }
  }

  String? route;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    route = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (route == "my_property_profile") {
          Get.back();
        } else {
          Get.offAllNamed("/bottom_navigation", arguments: "my_property");
        }

        return Future.value(true);
      },
      child: Scaffold(
        appBar: route == "my_property_profile"
            ? AppBar(
                titleTextStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: MyColors.black0,
                  fontFamily: "nunito",
                ),
                title: Text(
                  "My Property",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: "nunito",
                    color: MyColors.green3,
                  ),
                ),
                titleSpacing: 0.0,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: MyColors.black0,
                    size: 20.0,
                  ),
                ),
              )
            : AppBar(
                titleTextStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: MyColors.black0,
                  fontFamily: "nunito",
                ),
                title: Text(
                  "My Property",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: "nunito",
                    color: MyColors.black0,
                  ),
                ),
              ),
        body: NotificationListener(
          onNotification: (notification) {
            if (route != "my_property_profile") {
              botCon.onScroll();
              return false;
            }

            return false;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: customRadioButton("Sell", 0)),
                    const SizedBox(width: 10.0),
                    Expanded(child: customRadioButton("Rent / Lease", 1)),
                  ],
                ),
                const SizedBox(height: 10.0),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("property")
                      .doc(authCon.userid)
                      .collection("user_properties")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<Map<String, dynamic>> propertyList =
                          (snapshot.data as QuerySnapshot)
                              .docs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();

                      return Obx(() => buildPropertyList(propertyList));
                    } else if (snapshot.hasError) {
                      if (kDebugMode) {
                        print("Error ..... ${snapshot.error}");
                      }
                    }
                    return Container(
                      height: 65.0,
                      width: 65.0,
                      padding: const EdgeInsets.all(17.0),
                      child: CircularProgressIndicator(
                        color: MyColors.green3,
                        strokeWidth: 2.2,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyProCon extends GetxController {
  RxInt selectedIndex = 0.obs;

  void setValue(int newValue) {
    selectedIndex.value = newValue;
  }
}
