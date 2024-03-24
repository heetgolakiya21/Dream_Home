import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/search.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DisplaySearch extends StatefulWidget {
  const DisplaySearch({super.key});

  @override
  State<DisplaySearch> createState() => _DisplaySearchState();
}

class _DisplaySearchState extends State<DisplaySearch> {
  final AuthController auth = Get.find<AuthController>();

  String? post;
  String? type;
  String? country;
  String? state;
  String city = "";
  int min = 0;
  int max = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    post = Get.arguments["post"];
    type = Get.arguments["type"];
    country = Get.arguments["country"];
    state = Get.arguments["state"];

    if (Get.arguments["state"] == null) {
      state = "";
    } else {
      state = Get.arguments["city"];
    }

    if (Get.arguments["city"] == null) {
      city = "";
    } else {
      city = Get.arguments["city"];
    }

    min = Get.arguments["min"];
    max = Get.arguments["max"];
  }

  Future<QuerySnapshot> getData() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("all_property");
    QuerySnapshot snapshot = await collection.get();

    List fullSell = [];
    List fullRent = [];

    for (var doc in snapshot.docs) {
      if (doc["Post"] == "Sell") {
        fullSell.add(doc);
      } else {
        fullRent.add(doc);
      }
    }

    List<int> onlySell = [];

    for (int i = 0; i < fullSell.length; i++) {
      onlySell.add(int.tryParse(fullSell[i]["ExpectedPrice"])!);
    }

    List<int> onlyRent = [];

    for (int i = 0; i < fullRent.length; i++) {
      onlyRent.add(int.tryParse(fullRent[i]["MonthRent"])!);
    }

    List<String> sell = [];

    for (int i = 0; i < onlySell.length; i++) {
      if (min != 0 && max != 0) {
        if (min <= onlySell[i] && max >= onlySell[i]) {
          sell.add(onlySell[i].toString());
        }
      } else if (min == 0 && max != 0) {
        if (max >= onlySell[i]) {
          sell.add(onlySell[i].toString());
        }
      } else if (min != 0 && max == 0) {
        if (min <= onlySell[i]) {
          sell.add(onlySell[i].toString());
        }
      } else {
        sell.add(onlySell[i].toString());
      }
    }

    List<String> rent = [];

    for (int i = 0; i < onlyRent.length; i++) {
      if (min != 0 && max != 0) {
        if (min <= onlyRent[i] && max >= onlyRent[i]) {
          rent.add(onlyRent[i].toString());
        }
      } else if (min == 0 && max != 0) {
        if (max >= onlyRent[i]) {
          rent.add(onlyRent[i].toString());
        }
      } else if (min != 0 && max == 0) {
        if (min <= onlyRent[i]) {
          rent.add(onlyRent[i].toString());
        }
      } else {
        rent.add(onlyRent[i].toString());
      }
    }

    Query query = collection;

    if (type == "" && city.isEmpty && (min == 0 && max == 0)) {
      query = query.where("Post", isEqualTo: post);
    } else if (city.isNotEmpty && type == "" && (min == 0 && max == 0)) {
      query =
          query.where("Post", isEqualTo: post).where("City", isEqualTo: city);
    } else if (city.isEmpty && type != "" && (min == 0 && max == 0)) {
      query =
          query.where("Post", isEqualTo: post).where("Type", isEqualTo: type);
    } else if (city.isEmpty && type == "" && (min != 0 || max != 0)) {
      if (post == "Sell") {
        query = query.where("ExpectedPrice", whereIn: sell);
      } else {
        query = query.where("MonthRent", whereIn: rent);
      }
    } else if (city.isNotEmpty && type != "" && (min == 0 && max == 0)) {
      query = query
          .where("Post", isEqualTo: post)
          .where("City", isEqualTo: city)
          .where("Type", isEqualTo: type);
    } else if (city.isNotEmpty && type == "" && (min != 0 || max != 0)) {
      if (post == "Sell") {
        query = query
            .where("ExpectedPrice", whereIn: sell)
            .where("City", isEqualTo: city);
      } else {
        query = query
            .where("MonthRent", whereIn: rent)
            .where("City", isEqualTo: city);
      }
    } else if (city.isEmpty && type != "" && (min != 0 || max != 0)) {
      if (post == "Sell") {
        query = query
            .where("ExpectedPrice", whereIn: sell)
            .where("Type", isEqualTo: type);
      } else {
        query = query
            .where("MonthRent", whereIn: rent)
            .where("Type", isEqualTo: type);
      }
    } else if (city.isNotEmpty && type != "" && (min != 0 || max != 0)) {
      if (post == "Sell") {
        query = query
            .where("ExpectedPrice", whereIn: sell)
            .where("City", isEqualTo: city)
            .where("Type", isEqualTo: type);
      } else {
        query = query
            .where("MonthRent", whereIn: rent)
            .where("City", isEqualTo: city)
            .where("Type", isEqualTo: type);
      }
    } else {
      query = collection;
    }

    return await query.get();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Get.offNamed("/bottom_navigation", arguments: "display_search");

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Search Result",
            style: TextStyle(
                fontFamily: "nunito",
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: () {
                Get.offNamed("/bottom_navigation", arguments: "display_search");
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                size: 20.0,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 2.0 / 2.7,
                        ),
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                "/show_property",
                                arguments: {
                                  "userId": data["UserID"],
                                  "propertyId": data["PropertyID"],
                                  "route": "display_search",
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
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 150.0,
                                        margin: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: MyColors.green5,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                "${data["Images"][0]}"),
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
                                                  data["PriceInString"] != ""
                                                      ? "₹ ${data["PriceInString"]}"
                                                      : "₹ ${data["RentInString"]}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              "${data["Type"]}",
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
                                                "${data["City"]}",
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
                          );
                        },
                      ),
                    );
                  } else {
                    return noDataUI(size);
                  }
                } else {
                  return noDataUI(size);
                }
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
        ),
      ),
    );
  }

  Widget noDataUI(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Lottie.asset(
            "assets/lottie/not_found.json",
            height: size.width * .5,
            width: size.width * .5,
            fit: BoxFit.cover,
          ),
          const Text(
            "At this time your search properties is not available.",
            style: TextStyle(
              fontFamily: "nunito",
              fontSize: 13.0,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(flex: 3),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "In future, if your search property will available then you get notify. For this service, save your search.",
              style: TextStyle(
                fontFamily: "nunito",
                fontSize: 13.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton2(
                text: "Notify Me",
                onPressed: () {
                  String minStr = Utils.formatNumber(min);
                  String maxStr = Utils.formatNumber(max);

                  Search search = Search(
                    tokenID: Utils.tokenID,
                    userID: auth.userid,
                    country: country,
                    city: city,
                    state: state!,
                    type: type!,
                    post: post,
                    numMax: "$max",
                    numMin: "$min",
                    strMax: maxStr,
                    strMin: minStr,
                  );

                  easyLoading(context);

                  FirebaseFirestore.instance
                      .collection("search")
                      .add(search.toJson())
                      .then((value) {
                    Get.back();

                    if (kDebugMode) {
                      print("Search history saved .....");
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
