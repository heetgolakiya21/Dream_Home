import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/pages/main_pages/add_property/utility_add_property.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field3.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PropertyStatus extends StatefulWidget {
  const PropertyStatus({super.key});

  @override
  State<PropertyStatus> createState() => _PropertyStatusState();
}

class _PropertyStatusState extends State<PropertyStatus> {
  final AuthController authCon = Get.find<AuthController>();
  final StatusCon statusCon = Get.put(StatusCon());
  final UtilityAddProperty utilAddPro = UtilityAddProperty();

  final TextEditingController txtAgeOfConstruction = TextEditingController();
  final TextEditingController txtDate = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtAgeOfConstruction.dispose();
    txtDate.dispose();
    super.dispose();
  }

  int passIndex = 2;

  Widget customRadioButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        statusCon.setValue(index);
        passIndex = index;
        txtDate.clear();
        txtAgeOfConstruction.clear();
      },
      child: Obx(
        () => Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: (statusCon.value == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (statusCon.value == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: (statusCon.value == index.obs)
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

  List<String> ageOfCon = [
    "New Construction",
    "Less than 5 years",
    "5 to 10 years",
    "10 to 15 years",
    "15 to 20 years",
    "Above 20 years",
  ];

  Future<void> showBottomDialogue() async {
    await showModalBottomSheet(
      isDismissible: false,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Age of Construction",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "nunito",
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 23.0,
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ageOfCon.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              txtAgeOfConstruction.text = ageOfCon[index];
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      ageOfCon[index],
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "nunito",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade400),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget setWidget() {
    if (statusCon.value == 2.obs) {
      return CustomTextField3(
        controller: txtAgeOfConstruction,
        onTap: () => showBottomDialogue(),
        labelText: "Age of construction",
        hintText: "Select age of construction",
      );
    } else {
      return CustomTextField3(
        controller: txtDate,
        onTap: () async {
          await showMonthPicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: DateTime.now(),
            lastDate: DateTime(2050),
            headerColor: MyColors.green3,
            headerTextColor: MyColors.white0,
            backgroundColor: MyColors.white0,
            selectedMonthBackgroundColor: MyColors.white1,
            selectedMonthTextColor: MyColors.black0,
            unselectedMonthTextColor: MyColors.black0,
            currentMonthTextColor: MyColors.red0,
            roundedCornersRadius: 5.0,
            cancelWidget: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: MyColors.green3,
                ),
              ),
            ),
            confirmWidget: Text(
              "Ok",
              style: TextStyle(
                fontFamily: "nunito",
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: MyColors.green3,
              ),
            ),
          ).then((date) {
            if (date != null) {
              DateTime dt = date;
              txtDate.text = "${dt.year} / ${dt.month}";
            }
          });
        },
        labelText: "Available from",
        hintText: "Select date",
      );
    }
  }

  Property? prDetails;
  String? mainType;
  Property? typo;
  Property? location;
  Property? priceRent;

  String? propertyID;
  String? userID;

  String? pageInfo;

  Map? data;

  String? pst;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data = Get.arguments["data"];

    pageInfo = Get.arguments["pageInfo"];

    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      prDetails = Get.arguments["proDetails"];
      mainType = Get.arguments["mainType"];
      typo = Get.arguments["post/type"];
      location = Get.arguments["location"];
      priceRent = Get.arguments["price/rent"];
    } else {
      propertyID = Get.arguments["propertyId"];
      userID = Get.arguments["userId"];
      prDetails = Get.arguments["proDetails"];
      priceRent = Get.arguments["price/rent"];

      mainType = Get.arguments["mainType"];

      pst = Get.arguments["post/type"];

      for (int i = 0; i < ageOfCon.length; i++) {
        if (Get.arguments["data"]["SubStatus"] == ageOfCon[i]) {
          txtAgeOfConstruction.text = Get.arguments["data"]["SubStatus"];
        } else {
          txtDate.text = Get.arguments["data"]["SubStatus"];
        }
      }
    }
  }

  void backPress() {
    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      Get.back();
    } else {

      print("sssssssssssssssssssss $mainType");

      Map arguments = {
        "pageInfo": pageInfo,
        "data": data,
        "propertyId": propertyID,
        "userId": userID,
        "proDetails": prDetails,
        "price/rent": priceRent,
        "pageName": "status",
        "mainType": mainType,
      };

      if (pst == "Sell") {
        Get.offNamed(
          "/property_price",
          arguments: arguments,
        );
      } else {
        Get.offNamed(
          "/property_rent",
          arguments: arguments,
        );
      }
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
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Status of your property?",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: const Text(
                    "Available From",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "nunito",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14.0),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: customRadioButton("Under Construction", 1)),
                      const SizedBox(width: 20.0),
                      Expanded(child: customRadioButton("Ready to Move", 2)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Obx(() => setWidget()),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: pageInfo == "property_residential" ||
                                  pageInfo == "property_commercial"
                              ? true
                              : false,
                          child: CustomElevatedButton2(
                            text: "  Update  ",
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (passIndex == 1) {
                                if (txtDate.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar("Please Enter Date"));
                                } else {

                                  Property proDetails = Property(
                                    verificationStatus: Get.arguments["data"]
                                    ["VerificationStatus"],
                                    reason: Get.arguments["data"]["Reason"],
                                    userID: Get.arguments["data"]["UserID"],
                                    propertyID: Get.arguments["data"]
                                        ["PropertyID"],
                                    paymentID: Get.arguments["data"]
                                        ["PaymentID"],
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
                                    description: Get.arguments["data"]
                                        ["Description"],
                                    images: Get.arguments["data"]["Images"],
                                    post: Get.arguments["data"]["Post"],
                                    mainType: Get.arguments["data"]["MainType"],
                                    type: Get.arguments["data"]["Type"],
                                    country: Get.arguments["data"]["Country"],
                                    state: Get.arguments["data"]["State"],
                                    city: Get.arguments["data"]["City"],
                                    address: Get.arguments["data"]["Address"],
                                    fullAddress: Get.arguments["data"]
                                        ["FullAddress"],
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
                                    priceRentNegotiable:
                                        priceRent!.priceRentNegotiable,
                                    bookingToken: priceRent!.bookingToken,
                                    subStatus: txtDate.text,
                                    mainStatus: "Under Construction",
                                    monthRent: priceRent!.monthRent,
                                    securityAmt: priceRent!.securityAmt,
                                    maintenanceCharge:
                                        priceRent!.maintenanceCharge,
                                  );

                                  await PropertyDetails.sendPropertyData(
                                      userID!,
                                      propertyID!,
                                      proDetails,
                                      context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar("Property Updated."));

                                  Get.offNamed(
                                    "/show_property",
                                    arguments: {
                                      "userId": userID,
                                      "propertyId": propertyID,
                                    },
                                  );
                                }
                              } else if (passIndex == 2) {
                                if (txtAgeOfConstruction.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar(
                                          "Please select Age Of Construction"));
                                } else {

                                  Property proDetails = Property(
                                    verificationStatus: Get.arguments["data"]
                                    ["VerificationStatus"],
                                    reason: Get.arguments["data"]["Reason"],
                                    userID: Get.arguments["data"]["UserID"],
                                    propertyID: Get.arguments["data"]
                                        ["PropertyID"],
                                    paymentID: Get.arguments["data"]
                                        ["PaymentID"],
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
                                    description: Get.arguments["data"]
                                        ["Description"],
                                    images: Get.arguments["data"]["Images"],
                                    post: Get.arguments["data"]["Post"],
                                    mainType: Get.arguments["data"]["MainType"],
                                    type: Get.arguments["data"]["Type"],
                                    country: Get.arguments["data"]["Country"],
                                    state: Get.arguments["data"]["State"],
                                    city: Get.arguments["data"]["City"],
                                    address: Get.arguments["data"]["Address"],
                                    fullAddress: Get.arguments["data"]
                                        ["FullAddress"],
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
                                    priceRentNegotiable:
                                        priceRent!.priceRentNegotiable,
                                    bookingToken: priceRent!.bookingToken,
                                    maintenanceCharge:
                                        priceRent!.maintenanceCharge,
                                    subStatus: txtAgeOfConstruction.text,
                                    mainStatus: "Ready to Move",
                                    monthRent: priceRent!.monthRent,
                                    securityAmt: priceRent!.securityAmt,
                                  );

                                  await PropertyDetails.sendPropertyData(
                                      userID!,
                                      propertyID!,
                                      proDetails,
                                      context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar("Property Updated."));

                                  Get.offNamed(
                                    "/show_property",
                                    arguments: {
                                      "userId": userID,
                                      "propertyId": propertyID,
                                    },
                                  );
                                }
                              }
                            },
                          )),
                      const Spacer(),
                      CustomElevatedButton2(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (passIndex == 1) {
                            if (txtDate.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar("Please Enter Date"));
                            } else {
                              if (pageInfo != "property_residential" &&
                                  pageInfo != "property_commercial") {
                                Get.toNamed(
                                  "/property_image",
                                  arguments: {
                                    "proDetails": prDetails,
                                    "mainType": mainType,
                                    "post/type": typo,
                                    "location": location,
                                    "price/rent": priceRent,
                                    "MainStatus": "Under Construction",
                                    "SubStatus": txtDate.text,
                                  },
                                );
                              } else {
                                Get.offNamed(
                                  "/property_image",
                                  arguments: {
                                    "proDetails": prDetails,
                                    "mainType": mainType,
                                    "post/type": pst,
                                    "location": location,
                                    "price/rent": priceRent,
                                    "MainStatus": "Under Construction",
                                    "SubStatus": txtDate.text,
                                    "data": Get.arguments["data"],
                                    "pageInfo":
                                        pageInfo == "property_residential"
                                            ? "property_residential"
                                            : "property_commercial",
                                    "userId": userID,
                                    "propertyId": propertyID,
                                  },
                                );
                              }
                            }
                          } else {
                            if (txtAgeOfConstruction.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar(
                                      "Please select Age Of Construction"));
                            } else {
                              if (pageInfo != "property_residential" &&
                                  pageInfo != "property_commercial") {
                                Get.toNamed(
                                  "/property_image",
                                  arguments: {
                                    "proDetails": prDetails,
                                    "mainType": mainType,
                                    "post/type": typo,
                                    "location": location,
                                    "price/rent": priceRent,
                                    "MainStatus": "Ready to Move",
                                    "SubStatus": txtAgeOfConstruction.text,
                                  },
                                );
                              } else {
                                Get.offNamed(
                                  "/property_image",
                                  arguments: {
                                    "proDetails": prDetails,
                                    "mainType": mainType,
                                    "post/type": pst,
                                    "location": location,
                                    "price/rent": priceRent,
                                    "MainStatus": "Ready to Move",
                                    "SubStatus": txtAgeOfConstruction.text,
                                    "data": Get.arguments["data"],
                                    "pageInfo":
                                        pageInfo == "property_residential"
                                            ? "property_residential"
                                            : "property_commercial",
                                    "userId": userID,
                                    "propertyId": propertyID,
                                  },
                                );
                              }
                            }
                          }
                        },
                        text: "CONTINUE",
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

class StatusCon extends GetxController {
  RxInt value = 2.obs;

  void setValue(int newValue) {
    value.value = newValue;
  }
}
