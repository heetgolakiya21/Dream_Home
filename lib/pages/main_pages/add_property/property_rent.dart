import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyRent extends StatefulWidget {
  const PropertyRent({super.key});

  @override
  State<PropertyRent> createState() => _PropertyRentState();
}

class _PropertyRentState extends State<PropertyRent> {
  final AuthController authCon = Get.find<AuthController>();
  final RentController rentCon = Get.put(RentController());

  final TextEditingController txtRent = TextEditingController();
  final TextEditingController txtSecureAmount = TextEditingController();
  final TextEditingController txtMaintenanceCharge = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtRent.dispose();
    txtSecureAmount.dispose();
    txtMaintenanceCharge.dispose();
    super.dispose();
  }

  String formattedNumber = "";
  String negotiableOrNot = "";

  Map? data;

  String? post;

  String? pageInfo;

  Property? prDetails;
  String? mainType;
  Property? typo;
  Property? location;
  String? propertyID;
  String? userID;
  Property? priceRent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageInfo = Get.arguments["pageInfo"];
    data = Get.arguments["data"];

    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      prDetails = Get.arguments["proDetails"];
      mainType = Get.arguments["mainType"];
      typo = Get.arguments["post/type"];
      location = Get.arguments["location"];
    } else {
      propertyID = Get.arguments["propertyId"];
      userID = Get.arguments["userId"];
      prDetails = Get.arguments["proDetails"];
      mainType = Get.arguments["mainType"];

      priceRent = Get.arguments["price/rent"]; //  check

      post = Get.arguments["data"]["Post"];

      if (Get.arguments["pageName"] != "status") {
        txtRent.text = Get.arguments["data"]["MonthRent"];
        txtSecureAmount.text = Get.arguments["data"]["SecurityAmt"];
        txtMaintenanceCharge.text = Get.arguments["data"]["MaintenanceCharge"];

        if (Get.arguments["data"]["PriceRentNegotiable"] == "Rent Negotiable") {
          rentCon.isVisible = true.obs;
        } else {
          rentCon.isVisible = false.obs;
        }
      } else {
        txtRent.text = priceRent!.monthRent;
        txtSecureAmount.text = priceRent!.securityAmt;
        txtMaintenanceCharge.text = priceRent!.maintenanceCharge;

        if (priceRent!.priceRentNegotiable == "Rent Negotiable") {
          rentCon.isVisible = true.obs;
        } else {
          rentCon.isVisible = false.obs;
        }
      }
    }
  }

  void backPress() {
    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      Get.back();
    } else {
      print("rrrrrrrrrrrrrrrrrrrrrrrrrr ${Get.arguments["data"]["mainType"]}");

      print("rrrrrrrrrrrr ${data!["mainType"]}");

      Map arguments = {
        "pageInfo": pageInfo,
        "data": data,
        "propertyId": propertyID,
        "userId": userID,
        "mainType": mainType,
      };

      if (pageInfo == "property_residential") {
        Get.offNamed(
          "/property_residential",
          arguments: arguments,
        );
      } else {
        Get.offNamed(
          "/property_commercial",
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
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Rent You Except",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          CustomTextField2(
                            controller: txtRent,
                            labelText: "₹ Enter Monthly Rent",
                            hintText: "₹ Rent",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () {
                              rentCon.isVisible.value =
                                  !rentCon.isVisible.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value: rentCon.isVisible.value,
                                    onChanged: (value) {
                                      rentCon.isVisible.value = value!;
                                    },
                                    checkColor: MyColors.white0,
                                    activeColor: MyColors.green3,
                                    splashRadius: 20.0,
                                  ),
                                ),
                                Text(
                                  "Rent Negotiable",
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
                          const SizedBox(height: 12.0),
                          CustomTextField2(
                            controller: txtSecureAmount,
                            labelText: "₹ Enter Security Amount (optional)",
                            hintText: "₹ Amount",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 12.0),
                          CustomTextField2(
                            controller: txtMaintenanceCharge,
                            labelText:
                                "₹ Maintenance Charges Per Month (optional)",
                            hintText: "₹ Charges",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                              if (txtRent.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar("Enter Rent"));
                              } else if (int.tryParse(txtRent.text)! < 5000) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar(
                                        "Property rent can not less than 5000"));
                              } else {
                                formattedNumber = Utils.formatNumber(
                                    int.tryParse(txtRent.text)!);

                                if (rentCon.isVisible == true.obs) {
                                  negotiableOrNot = "Rent Negotiable";
                                } else {
                                  negotiableOrNot = "Rent Not Negotiable";
                                }

                                Property proDetails = Property(
                                  verificationStatus: Get.arguments["data"]
                                  ["VerificationStatus"],
                                  reason: Get.arguments["data"]["Reason"],
                                  userID: userID,
                                  propertyID: propertyID,
                                  maintenanceCharge:
                                      txtMaintenanceCharge.text,
                                  priceInString: prDetails!.priceInString,
                                  rentInString: formattedNumber,
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
                                  expectedPrice: prDetails!.expectedPrice,
                                  priceRentNegotiable: negotiableOrNot,
                                  bookingToken: prDetails!.bookingToken,
                                  paymentID: Get.arguments["data"]
                                      ["PaymentID"],
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
                                  subStatus: Get.arguments["data"]
                                      ["SubStatus"],
                                  mainStatus: Get.arguments["data"]
                                      ["MainStatus"],
                                  monthRent: txtRent.text,
                                  securityAmt: txtSecureAmount.text,
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
                            },
                          )),
                      const Spacer(),
                      CustomElevatedButton2(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (txtRent.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar("Enter Rent"));
                          } else if (int.tryParse(txtRent.text)! < 5000) {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar(
                                "Property rent can not less than 5000"));
                          } else {
                            if (rentCon.isVisible == true.obs) {
                              negotiableOrNot = "Rent Negotiable";
                            } else {
                              negotiableOrNot = "Rent Not Negotiable";
                            }

                            formattedNumber =
                                Utils.formatNumber(int.tryParse(txtRent.text)!);

                            priceRent = Property(
                              monthRent: txtRent.text,
                              priceRentNegotiable: negotiableOrNot,
                              securityAmt: txtSecureAmount.text,
                              maintenanceCharge: txtMaintenanceCharge.text,
                              rentInString: formattedNumber,
                            );

                            if (pageInfo != "property_residential" &&
                                pageInfo != "property_commercial") {
                              Get.toNamed(
                                "/property_status",
                                arguments: {
                                  "proDetails": prDetails,
                                  "mainType": mainType,
                                  "post/type": typo,
                                  "location": location,
                                  "price/rent": priceRent,
                                },
                              );
                            } else {
                              Get.offNamed(
                                "/property_status",
                                arguments: {
                                  "proDetails": prDetails,
                                  "mainType": mainType,
                                  "post/type": post,
                                  "location": location,
                                  "price/rent": priceRent,
                                  "data": Get.arguments["data"],
                                  "pageInfo": pageInfo == "property_residential"
                                      ? "property_residential"
                                      : "property_commercial",
                                  "userId": userID,
                                  "propertyId": propertyID,
                                },
                              );
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

class RentController extends GetxController {
  RxBool isVisible = false.obs;
}
