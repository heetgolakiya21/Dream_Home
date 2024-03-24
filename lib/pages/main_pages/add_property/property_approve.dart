import 'package:dream_home/global/property_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/model/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PropertyApprove extends StatefulWidget {
  const PropertyApprove({super.key});

  @override
  State<PropertyApprove> createState() => _PropertyApproveState();
}

class _PropertyApproveState extends State<PropertyApprove> {
  final AuthController authCon = Get.find<AuthController>();
  final ApproveCon proCon = Get.put(ApproveCon());
  final Razorpay razorpay = Razorpay();

  @override
  void dispose() {
    // TODO: implement dispose
    razorpay.clear();
    super.dispose();
  }

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

  void _startPayment() {
    var options = {
      "key": "rzp_test_rGj04UQSqk95Y8",
      "amount": 100 * 399,
      "name": "DREAM HOME",
      "description": "Charges for add property",
      "retry": {"enabled": true, "max_count": 3},
      "send_sms_hash": true,
      "prefill": {
        "contact": authCon.txtPhoneNo.text,
        "email": authCon.txtEmail.text,
      },
      "currency": "INR",
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    try {
      razorpay.open(options);
    } catch (e) {
      if (kDebugMode) print("Error while opening Razorpay ..... $e");
    }
  }

  String paymentID = "";

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (kDebugMode) {
      print("orderId ..... ${response.orderId}");
      print("paymentId ..... ${response.paymentId}");
      print("signature ..... ${response.signature}");
    }

    paymentID = response.paymentId!;
    await showAlertDialog(context, "Payment Success", "");
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    if (kDebugMode) {
      print("Code ..... ${response.code}");
      print("Error ..... ${response.error}");
      print("Message ..... ${response.message}");
    }

    await showAlertDialog(context, "Payment Failed", "${response.message}");
  }

  Future<void> saveProperty() async {
    easyLoading(context);

    Property? prDet;

    await FirebaseFirestore.instance
        .collection("property_status")
        .where("PropertyID", isEqualTo: propertyId)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var data in snapshot.docs) {
        prDet = Property(
          propertyID: data["PropertyID"],
          userID: data["UserID"],
          paymentID: data["PaymentID"],
          verificationStatus: data["VerificationStatus"],
          reason: data["Reason"],
          images: data["Images"],
          description: data["Description"],
          expectedPrice: data["ExpectedPrice"],
          priceRentNegotiable: data["PriceRentNegotiable"],
          bookingToken: data["BookingToken"],
          maintenanceCharge: data["MaintenanceCharge"],
          securityAmt: data["SecurityAmt"],
          priceInString: data["PriceInString"],
          rentInString: data["RentInString"],
          monthRent: data["MonthRent"],
          country: data["Country"],
          city: data["City"],
          state: data["State"],
          address: data["Address"],
          fullAddress: data["FullAddress"],
          mainType: data["MainType"],
          type: data["Type"],
          post: data["Post"],
          subStatus: data["SubStatus"],
          mainStatus: data["MainStatus"],
          superAreaUnit: data["SuperAreaUnit"],
          superArea: data["SuperArea"],
          carpetAreaUnit: data["CarpetAreaUnit"],
          carpetArea: data["CarpetArea"],
          balcony: data["Balcony"],
          furnishing: data["Furnishing"],
          yourFloor: data["YourFloor"],
          bathroom: data["BathRoom"],
          bedroom: data["BedRoom"],
          roadWidth: data["RoadWidth"],
          plotArea: data["PlotArea"],
          boundaryWall: data["PlotAreaUnit"],
          roadFacing: data["RoadFacing"],
          cornerShop: data["CornerShop"],
          noAllowCon: data["NoAllowConstruction"],
          openSides: data["OpenSides"],
          pantryCafeteria: data["PantryCafeteria"],
          plotAreaUnit: data["PlotAreaUnit"],
          plotBreadth: data["PlotBreadth"],
          plotLength: data["PlotLength"],
          totalFloor: data["TotalFloor"],
          washroom: data["Washroom"],
        );
      }
    });

    // --------------------------------------------------------------------

    List<Search> search = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("search").get();

    for (var data in snapshot.docs) {
      Search sch = Search(
        tokenID: data["TokenID"],
        userID: data["UserID"],
        city: data["City"],
        state: data["State"],
        country: data["Country"],
        type: data["Type"],
        numMax: data["NumMax"],
        numMin: data["NumMin"],
        post: data["Post"],
        strMax: data["StrMax"],
        strMin: data["StrMin"],
      );

      search.add(sch);
    }

    for (int i = 0; i < search.length; i++) {
      if (prDet!.post == "Sell") {
        int expectedPrice = int.tryParse(prDet!.expectedPrice)!;
        int min = int.tryParse(search[i].numMin)!;
        int max = int.tryParse(search[i].numMax)!;

        if (prDet!.type == search[i].type && prDet!.post == search[i].post) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type && prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].city &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.post == search[i].post &&
            prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.city == search[i].city &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.city == search[i].city &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post && expectedPrice >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post && expectedPrice <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].post && expectedPrice >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].post && expectedPrice <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].post && expectedPrice >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].post && expectedPrice <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.type == search[i].type &&
            expectedPrice <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.type == search[i].type &&
            expectedPrice >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.post == search[i].post &&
            prDet!.city == search[i].city &&
            (expectedPrice <= max && expectedPrice >= min)) {
          sendNotification(search[i].tokenID!);
        }
      } else {
        int monthRent = int.tryParse(prDet!.monthRent)!;
        int min = int.tryParse(search[i].numMin)!;
        int max = int.tryParse(search[i].numMax)!;

        if (prDet!.type == search[i].type && prDet!.post == search[i].post) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].city &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.post == search[i].post &&
            prDet!.city == search[i].city) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.city == search[i].city &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.city == search[i].city &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post && monthRent >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post && monthRent <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].post && monthRent >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.city == search[i].post && monthRent <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].post && monthRent >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].post && monthRent <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.type == search[i].type &&
            monthRent <= max) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.post == search[i].post &&
            prDet!.type == search[i].type &&
            monthRent >= min) {
          sendNotification(search[i].tokenID!);
        } else if (prDet!.type == search[i].type &&
            prDet!.post == search[i].post &&
            prDet!.city == search[i].city &&
            (monthRent <= max && monthRent >= min)) {
          sendNotification(search[i].tokenID!);
        }
      }
    }

    await PropertyDetails.sendPropertyData(
        authCon.userid!, propertyId, prDet!, context);

    if (kDebugMode) {
      print("Property added to property and all_property collection .....");
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("property_status")
        .where("PropertyID", isEqualTo: propertyId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();

        if (kDebugMode) {
          print(
              "Document with property ID $propertyId deleted successfully!......");
        }
      }
    }

    await Utils.userPref!.setBool("first_payment", true);
    Get.back();
    Get.offAllNamed("/bottom_navigation", arguments: "property_image");
  }

  Future<void> sendNotification(String tokenID) async {
    Map<String, String> notification = {
      "title": "Alert ⚠",
      "body":
          "Hurry up! The Property you searched for has become available. Go and check.",
    };

    var data = {
      "to": tokenID,
      "priority": "high",
      "notification": notification,
      "data": {
        "type": "message",
        "notification": notification,
        "description": "your search property is now available."
      },
    };

    await http.post(
      Uri.parse(Utils.uri),
      body: jsonEncode(data),
      headers: {
        "Content-Type": Utils.contentType,
        "Authorization": Utils.serverID,
      },
    );
  }

  Future<void> showAlertDialog(
      BuildContext context, String title, String message) async {
    TextButton cancel = TextButton(
      onPressed: () => Get.back(),
      child: Text(
        "Cancel",
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: MyColors.green3,
        ),
      ),
    );

    Widget retry = TextButton(
        onPressed: () {
          Get.back();
          _startPayment();
        },
        child: Text(
          "Retry",
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: "nunito",
            fontWeight: FontWeight.bold,
            color: MyColors.green3,
          ),
        ));

    Widget continu = TextButton(
      onPressed: () async {
        Get.back();
        await saveProperty();
      },
      child: Text(
        "OK",
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: "nunito",
          fontWeight: FontWeight.bold,
          color: MyColors.green3,
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      titleTextStyle: TextStyle(
        color: MyColors.black0,
        fontFamily: "nunito",
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      contentTextStyle: TextStyle(
        fontFamily: "nunito",
        color: Colors.grey.shade700,
        fontSize: 15.0,
      ),
      backgroundColor: MyColors.white0,
      title: Text(title),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      content: title == "Payment Failed"
          ? Text(message)
          : Lottie.asset(
              "assets/lottie/success.json",
              height: 150.0,
            ),
      actions: title == "Payment Failed" ? [cancel, retry] : [continu],
    );

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String propertyId = "";

  Widget buildPropertyList(List<Map<String, dynamic>> propertyList) {
    List<Map<String, dynamic>> filteredList = propertyList.where((property) {
      return property["VerificationStatus"] ==
          (proCon.selectedIndex == 0.obs
              ? "pending"
              : (proCon.selectedIndex == 1.obs)
                  ? "approved"
                  : "denied");
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
                    ? "You have not any property in Pending status."
                    : (proCon.selectedIndex == 1.obs)
                        ? "You have not any property in Approved status."
                        : "You have not any property in Denied status.",
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
              onTap: () async {
                if (proCon.selectedIndex == 2.obs) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 10.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: MyColors.white0,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Why your property denied?",
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          fontSize: 15.0,
                                          color: MyColors.red0,
                                          fontWeight: FontWeight.bold,
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
                                          size: 17.0,
                                          weight: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    data["Reason"],
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 15.0,
                                        color: MyColors.black0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (proCon.selectedIndex == 1.obs) {
                  propertyId = data["PropertyID"];

                  bool status =
                      Utils.userPref!.getBool("first_payment") ?? false;

                  if (status) {
                    bool status =
                        Utils.userPref!.getBool("pay_warn_dialog") ?? false;

                    if (status) {
                      _startPayment();
                    } else {
                      await Utils.userPref!.setBool("pay_warn_dialog", true);

                      await payWarnDialog();
                    }
                  } else {
                    await saveProperty();
                  }
                } else if (proCon.selectedIndex == 0.obs) {
                  Get.toNamed(
                    "/show_property",
                    arguments: {
                      "userId" : data["UserID"],
                      "propertyId": data["PropertyID"],
                      "route": "request_page_a",
                    },
                  );
                }
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

  void backPress() {
    if (route == "my_property_profile" || route == "bottom_home") {
      Get.back();
    } else {
      Get.offAllNamed("/bottom_navigation", arguments: "property_image");
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
        appBar: AppBar(
          titleTextStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: MyColors.black0,
            fontFamily: "nunito",
          ),
          title: Text(
            "Property Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: "nunito",
              color: MyColors.green3,
            ),
          ),
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: () => backPress(),
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.black0,
              size: 20.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: customRadioButton("Pending", 0)),
                  const SizedBox(width: 10.0),
                  Expanded(child: customRadioButton("Approved", 1)),
                  const SizedBox(width: 10.0),
                  Expanded(child: customRadioButton("Denied", 2)),
                ],
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => proCon.selectedIndex == 2.obs
                    ? Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 10.0),
                            child: Text(
                              ">> Click on property to check denied reason.",
                              style: TextStyle(
                                fontFamily: "nunito",
                                fontSize: 10.0,
                                color: MyColors.black0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : (proCon.selectedIndex == 1.obs)
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 10.0),
                                child: Text(
                                  ">> For live your property, click on property and pay the payment.",
                                  style: TextStyle(
                                    fontFamily: "nunito",
                                    fontSize: 10.0,
                                    color: MyColors.black0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (proCon.selectedIndex == 0.obs)
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 10.0),
                                    child: Text(
                                      ">> Wait until your property not approve by admin.",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 10.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("property_status")
                    .where("UserID", isEqualTo: authCon.userid)
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
    );
  }

  Future<void> payWarnDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: MyColors.white0,
                  ),
                  padding: const EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            MyColors.white1,
                          ),
                        ),
                        icon: const Icon(
                          Icons.close_outlined,
                          size: 20.0,
                          weight: 20.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          text: "${authCon.txtName.text}, ",
                          children: [
                            TextSpan(
                              text:
                                  "you reached to adding property free limit. if you want to add more property then continue with",
                              style: TextStyle(
                                color: MyColors.black0,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            color: MyColors.green3,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "nunito",
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          _startPayment();
                        },
                        child: Text(
                          "Make Payment",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                            color: MyColors.green3,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ApproveCon extends GetxController {
  RxInt selectedIndex = 0.obs;

  void setValue(int newValue) {
    selectedIndex.value = newValue;
  }
}
