import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAllPage> {
  Map? route;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    route = Get.arguments;
  }

  Stream<List<Map<String, dynamic>>> getProperties() {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection("all_property");

    return collection.snapshots().map((snapshot) {
      List<DocumentSnapshot> allDocuments = snapshot.docs.toList();
      allDocuments.shuffle();

      List<Map<String, dynamic>> residentialProperties = [];
      List<Map<String, dynamic>> commercialProperties = [];

      if (route!["pageType"] == "Residential") {
        for (var document in allDocuments) {
          var propertyData = document.data() as Map<String, dynamic>;

          if (propertyData["MainType"] == "Residential") {
            residentialProperties.add(propertyData);
          }
        }

        return residentialProperties;
      } else {
        for (var document in allDocuments) {
          var propertyData = document.data() as Map<String, dynamic>;

          if (propertyData["MainType"] == "Commercial") {
            commercialProperties.add(propertyData);
          }
        }

        return commercialProperties;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: Text("${route!["pageType"]} Property"),
        titleSpacing: 0.5,
        titleTextStyle: TextStyle(
          fontFamily: "nunito",
          color: MyColors.black0,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder(
          stream: getProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 65.0,
                    width: 65.0,
                    padding: const EdgeInsets.all(17.0),
                    child: CircularProgressIndicator(
                      color: MyColors.green3,
                      strokeWidth: 2.2,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              List<Map<String, dynamic>> data = snapshot.data ?? [];

              return GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2.0 / 2.7,
                ),
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                padding: const EdgeInsets.only(bottom: 70.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      "/show_property",
                      arguments: {
                        "userId": data[index]["UserID"],
                        "propertyId": data[index]["PropertyID"],
                        "route": "see_all",
                      },
                    ),
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
                          child: Column(
                            children: [
                              Container(
                                height: 150.0,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: MyColors.green5,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        "${data[index]["Images"][0]}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index]["PriceInString"] != ""
                                              ? "₹ ${data[index]["PriceInString"]}"
                                              : "₹ ${data[index]["RentInString"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: MyColors.green3,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            fontFamily: "nunito",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      data[index]["Type"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: MyColors.black0,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15.0,
                                        fontFamily: "nunito",
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 15.0,
                                      color: MyColors.black0,
                                    ),
                                    const SizedBox(width: 2.0),
                                    Expanded(
                                      child: Text(
                                        data[index]["City"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          fontSize: 15.0,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        route!["routeName"] == "admin"
                            ? Positioned(
                                left: 10.0,
                                top: 10.0,
                                child: GestureDetector(
                                  onTap: () async {
                                    await deleteDialog(
                                      context,
                                      () async {
                                        Get.back();
                                        await PropertyDetails.deleteData(
                                            data[index]["PropertyID"],
                                            data[index]["UserID"],
                                            context);
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: MyColors.white0,
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
                            data[index]["Post"] == "Sell"
                                ? "${data[index]["Post"]}"
                                : "Rent",
                            style: TextStyle(
                              color: MyColors.white0,
                              fontFamily: "nunito",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      )),
    );
  }
}
