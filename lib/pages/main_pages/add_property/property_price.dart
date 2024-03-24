import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/pages/main_pages/add_property/utility_add_property.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyPrice extends StatefulWidget {
  const PropertyPrice({super.key});

  @override
  State<PropertyPrice> createState() => _PropertyPriceState();
}

class _PropertyPriceState extends State<PropertyPrice> {
  final AuthController authCon = Get.find<AuthController>();
  final PriceController priceCon = Get.put(PriceController());
  final UtilityAddProperty utilAddPro = UtilityAddProperty();

  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtToken = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtPrice.dispose();
    txtToken.dispose();
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
  String? userID;
  String? propertyID;
  Property? priceRent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageInfo = Get.arguments["pageInfo"];
    prDetails = Get.arguments["proDetails"];

    data = Get.arguments["data"];

    if (pageInfo != "property_residential" && pageInfo != "property_commercial") {
      mainType = Get.arguments["mainType"];
      typo = Get.arguments["post/type"];
      location = Get.arguments["location"];
    } else {
      userID = Get.arguments["userId"];
      propertyID = Get.arguments["propertyId"];
      priceRent = Get.arguments["price/rent"];

      mainType = Get.arguments["mainType"];

      print("))))))))))))))))))) $mainType");

      post = Get.arguments["data"]["Post"];

      if (Get.arguments["pageName"] != "status") {
        txtPrice.text = Get.arguments["data"]["ExpectedPrice"];
        txtToken.text = Get.arguments["data"]["BookingToken"];

        if (Get.arguments["data"]["PriceRentNegotiable"] ==
            "Price Negotiable") {
          priceCon.isVisible = true.obs;
        } else {
          priceCon.isVisible = false.obs;
        }
      } else {
        txtPrice.text = priceRent!.expectedPrice;
        txtToken.text = priceRent!.bookingToken;

        if (priceRent!.priceRentNegotiable == "Price Negotiable") {
          priceCon.isVisible = true.obs;
        } else {
          priceCon.isVisible = false.obs;
        }
      }
    }
  }

  void backPress() {
    if (pageInfo != "property_residential" &&
        pageInfo != "property_commercial") {
      Get.back();
    } else {
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
                        "Price You Except",
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
                            controller: txtPrice,
                            labelText: "₹ Enter Expected Price",
                            hintText: "₹ Price",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () {
                              priceCon.isVisible.value =
                                  !priceCon.isVisible.value;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value: priceCon.isVisible.value,
                                    onChanged: (value) {
                                      priceCon.isVisible.value = value!;
                                    },
                                    checkColor: MyColors.white0,
                                    activeColor: MyColors.green3,
                                    splashRadius: 20.0,
                                  ),
                                ),
                                Text(
                                  "Price Negotiable",
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
                            controller: txtToken,
                            labelText: "₹ Enter Booking/Token Amount (optional)",
                            hintText: "₹ Amount",
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
                              if (txtPrice.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar("Enter Price"));
                              } else if (int.tryParse(txtPrice.text)! <
                                  100000) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar("Sell price can not below 1 lac"));
                              } else {
                                formattedNumber = Utils.formatNumber(
                                    int.tryParse(txtPrice.text)!);

                                if (priceCon.isVisible == true.obs) {
                                  negotiableOrNot = "Price Negotiable";
                                } else {
                                  negotiableOrNot = "Price Not Negotiable";
                                }

                                Property proDetails = Property(
                                  verificationStatus: Get.arguments["data"]
                                  ["VerificationStatus"],
                                  reason: Get.arguments["data"]["Reason"],
                                  userID: userID,
                                  propertyID: propertyID,
                                  priceInString: formattedNumber,
                                  expectedPrice: txtPrice.text,
                                  priceRentNegotiable: negotiableOrNot,
                                  bookingToken: txtToken.text,
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
                                  maintenanceCharge: Get.arguments["data"]
                                      ["MaintenanceCharge"],
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
                                  paymentID: Get.arguments["data"]["PaymentID"],
                                  rentInString: Get.arguments["data"]
                                      ["RentInString"],
                                  subStatus: Get.arguments["data"]["SubStatus"],
                                  mainStatus: Get.arguments["data"]
                                      ["MainStatus"],
                                  monthRent: Get.arguments["data"]["MonthRent"],
                                  securityAmt: Get.arguments["data"]
                                      ["SecurityAmt"],
                                );

                                await PropertyDetails.sendPropertyData(
                                    userID!, propertyID!, proDetails, context);

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

                          if (txtPrice.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar("Enter Price"));
                          } else if (int.tryParse(txtPrice.text)! < 100000) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Sell price can not below 1 lac"));
                          } else {
                            if (priceCon.isVisible == true.obs) {
                              negotiableOrNot = "Price Negotiable";
                            } else {
                              negotiableOrNot = "Price Not Negotiable";
                            }

                            formattedNumber = Utils.formatNumber(int.tryParse(txtPrice.text)!);

                            priceRent = Property(
                              expectedPrice: txtPrice.text,
                              priceRentNegotiable: negotiableOrNot,
                              bookingToken: txtToken.text,
                              priceInString: formattedNumber,
                            );

                            if (pageInfo != "property_residential" && pageInfo != "property_commercial") {
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

class PriceController extends GetxController {
  RxBool isVisible = false.obs;
}
