import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/pages/main_pages/add_property/utility_add_property.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyResidential extends StatefulWidget {
  const PropertyResidential({super.key});

  @override
  State<PropertyResidential> createState() => _ResidentialPropertyState();
}

class _ResidentialPropertyState extends State<PropertyResidential> {
  UtilityAddPropertyCon utilAddProCon = Get.put(UtilityAddPropertyCon());
  final AuthController authCon = Get.find<AuthController>();
  final UtilityAddProperty utilAddPro = UtilityAddProperty();

  String? pageInfo;
  String? userID;
  String? propertyID;
  String? mainType;
  Property? typo;
  Property? location;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageInfo = Get.arguments["pageInfo"];

    if (pageInfo != "property_residential") {
      typo = Get.arguments["post/type"];
      location = Get.arguments["location"];
      mainType = Get.arguments["mainType"];
    } else {
      userID = Get.arguments["userId"];
      propertyID = Get.arguments["propertyId"];
      mainType = Get.arguments["mainType"];

      print("main type rerrerrrrrrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeee $mainType");

      typo = Property(
        post: Get.arguments["data"]["Post"],
        type: Get.arguments["data"]["Type"],
      );

      location = Property(
        city: Get.arguments["data"]["City"],
        state: Get.arguments["data"]["State"],
        country: Get.arguments["data"]["Country"],
        address: Get.arguments["data"]["Address"],
        fullAddress: Get.arguments["data"]["FullAddress"],
      );

      int bedRoomIndex = 0;
      int bathRoomIndex = -1;
      int balconyIndex = -1;

      if (Get.arguments["data"]["BedRoom"] != "") {
        String bedroom = Get.arguments["data"]["BedRoom"];
        List bedroomSplit = bedroom.split(" ");
        bedRoomIndex = int.parse(bedroomSplit[0]);
      } else {
        bedRoomIndex = 0;
      }

      if (Get.arguments["data"]["BathRoom"] != "") {
        bathRoomIndex = int.parse(Get.arguments["data"]["BathRoom"]);
      } else {
        bathRoomIndex = -1;
      }

      if (Get.arguments["data"]["Balcony"] != -1) {
        balconyIndex = int.parse(Get.arguments["data"]["Balcony"]);
      } else {
        balconyIndex = 1;
      }

      utilAddProCon.setIndexBathRoom(bathRoomIndex + 1);
      utilAddProCon.setIndexBalcony(balconyIndex + 1);
      utilAddProCon.setIndexBedRoom(bedRoomIndex);
      utilAddProCon.gv.value = Get.arguments["data"]["Furnishing"];
      utilAddPro.txtFloor.text = Get.arguments["data"]["TotalFloor"];
      utilAddPro.txtFloorNo.text = Get.arguments["data"]["YourFloor"];
      utilAddPro.txtUnitCarpet.text = Get.arguments["data"]["CarpetAreaUnit"];
      utilAddPro.txtUnitSuper.text = Get.arguments["data"]["SuperAreaUnit"];

      List carpetSuper = [];
      String carpetArea = Get.arguments["data"]["CarpetArea"];
      carpetSuper = carpetArea.split(" ");
      utilAddPro.txtCarpet.text = carpetSuper[0];

      String superArea = Get.arguments["data"]["SuperArea"];
      carpetSuper = superArea.split(" ");
      utilAddPro.txtSuper.text = carpetSuper[0];

      utilAddPro.txtOnlyFloorNo.text = Get.arguments["data"]["TotalFloor"];
      utilAddPro.txtRoadWidth.text = Get.arguments["data"]["RoadWidth"];
      utilAddPro.txtLandFloor.text =
          Get.arguments["data"]["NoAllowConstruction"];
      utilAddPro.txtLandSide.text = Get.arguments["data"]["OpenSides"];
      utilAddProCon.boundaryGv.value = Get.arguments["data"]["BoundaryWall"];

      List plotArea = [];
      String pa = Get.arguments["data"]["PlotArea"];
      plotArea = pa.split(" ");

      utilAddPro.txtPlotArea.text = plotArea[0];
      utilAddPro.txtPlotUnit.text = Get.arguments["data"]["PlotAreaUnit"];
      utilAddPro.txtPlotLength.text = Get.arguments["data"]["PlotLength"];
      utilAddPro.txtPlotBreadth.text = Get.arguments["data"]["PlotBreadth"];
    }
  }

  void backPress() {
    if (pageInfo != "property_residential") {
      Get.back();
    } else {
      Get.offNamed(
        "/show_property",
        arguments: {
          "userId": userID,
          "propertyId": propertyID,
        },
      );
    }
  }

  void nextPage(Property proDetails) {
    if (pageInfo != "property_residential") {
      Map arguments = {
        "proDetails": proDetails,
        "mainType": mainType,
        "post/type": typo,
        "location": location,
      };

      if (typo!.post == "Sell") {
        Get.toNamed(
          "/property_price",
          arguments: arguments,
        );
      } else {
        Get.toNamed(
          "/property_rent",
          arguments: arguments,
        );
      }
    } else {
      Map arguments = {
        "proDetails": proDetails,
        "mainType": mainType,
        "post/type": typo,
        "location": location,
        "data": Get.arguments["data"],
        "pageInfo": "property_residential",
        "userId": userID,
        "propertyId": propertyID,
      };

      if (typo!.post == "Sell") {
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 15.0),
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
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 12.0),
                child: Row(
                  children: [
                    Text(
                      "More details to get relevant buyers",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: "nunito",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13.0),
              Expanded(
                child: SingleChildScrollView(
                  child: typo!.type == "Flat/Apartment" ||
                          typo!.type == "Builder Floor" ||
                          typo!.type == "Penthouse"
                      ? Column(
                          children: [
                            utilAddPro.unitDetails(3),
                            utilAddPro.floorDetails(context),
                            utilAddPro.furnishingDetails(),
                            utilAddPro.propertyAreaDetails(context),
                            const SizedBox(height: 50.0),
                          ],
                        )
                      : typo!.type == "House" || typo!.type == "Villa"
                          ? Column(
                              children: [
                                utilAddPro.unitDetails(3),
                                utilAddPro.onlyFloorNoDetails(context),
                                utilAddPro.furnishingDetails(),
                                utilAddPro.propertyAreaDetails(context),
                                utilAddPro.roadAreaDetails(context),
                                const SizedBox(height: 50.0),
                              ],
                            )
                          : typo!.type == "Plot"
                              ? Column(
                                  children: [
                                    utilAddPro.plotFloorDetails(context),
                                    utilAddPro.roadAreaDetails(context),
                                    utilAddPro.boundaryDetails(),
                                    utilAddPro.plotPropertyAreaDetails(context),
                                    const SizedBox(height: 50.0),
                                  ],
                                )
                              : typo!.type == "Studio Apartment"
                                  ? Column(
                                      children: [
                                        utilAddPro.unitDetails(2),
                                        utilAddPro.floorDetails(context),
                                        utilAddPro.furnishingDetails(),
                                        utilAddPro.propertyAreaDetails(context),
                                        const SizedBox(height: 50.0),
                                      ],
                                    )
                                  : typo!.type == "Farm House"
                                      ? Column(
                                          children: [
                                            utilAddPro.unitDetails(3),
                                            utilAddPro.floorDetails(context),
                                            utilAddPro.furnishingDetails(),
                                            utilAddPro
                                                .propertyAreaDetails(context),
                                            utilAddPro.roadAreaDetails(context),
                                            const SizedBox(height: 50.0),
                                          ],
                                        )
                                      : const SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible:
                          pageInfo == "property_residential" ? true : false,
                      child: CustomElevatedButton2(
                        text: "  Update  ",
                        onPressed: () async {
                          int bathRoomCnt =
                              utilAddPro.utilAddProCon.bathRoomIndex.value - 1;
                          int balconyCnt =
                              utilAddPro.utilAddProCon.balconyIndex.value - 1;

                          Property proDetails = Property(
                            verificationStatus: Get.arguments["data"]
                                ["VerificationStatus"],
                            reason: Get.arguments["data"]["Reason"],
                            userID: userID,
                            propertyID: propertyID,
                            mainType: mainType,
                            type: typo!.type,
                            post: typo!.post,
                            country: location!.country,
                            state: location!.state,
                            city: location!.city,
                            address: location!.address,
                            fullAddress: location!.fullAddress,
                            bedroom:
                                "${utilAddPro.utilAddProCon.bedRoomIndex} BHK",
                            bathroom: bathRoomCnt.toString(),
                            balcony: balconyCnt.toString(),
                            totalFloor: utilAddPro.txtFloor.text.trim(),
                            yourFloor: utilAddPro.txtFloorNo.text.trim(),
                            furnishing: utilAddPro.utilAddProCon.gv.toString(),
                            carpetArea:
                                " ${utilAddPro.txtCarpet.text.trim()} ${utilAddPro.txtUnitCarpet.text.trim()}",
                            carpetAreaUnit:
                                utilAddPro.txtUnitCarpet.text.trim(),
                            superArea:
                                "${utilAddPro.txtSuper.text.trim()} ${utilAddPro.txtUnitSuper.text.trim()}",
                            superAreaUnit: utilAddPro.txtUnitSuper.text.trim(),
                            roadWidth: utilAddPro.txtRoadWidth.text.trim(),
                            noAllowCon: utilAddPro.txtLandFloor.text.trim(),
                            openSides: utilAddPro.txtLandSide.text.trim(),
                            boundaryWall: utilAddProCon.boundaryGv.value,
                            plotArea:
                                "${utilAddPro.txtPlotArea.text.trim()} ${utilAddPro.txtPlotUnit.text.trim()}",
                            plotAreaUnit: utilAddPro.txtPlotUnit.text.trim(),
                            plotLength: utilAddPro.txtPlotLength.text.trim(),
                            plotBreadth: utilAddPro.txtPlotBreadth.text.trim(),
                            pantryCafeteria: utilAddProCon.cafeteriaGv.value,
                            washroom: utilAddProCon.washroomGv.value,
                            cornerShop: utilAddProCon.cornerShopGv.value,
                            roadFacing: utilAddProCon.mainRoadGv.value,
                            paymentID: Get.arguments["data"]["PaymentID"],
                            rentInString: Get.arguments["data"]["RentInString"],
                            priceInString: Get.arguments["data"]
                                ["PriceInString"],
                            description: Get.arguments["data"]["Description"],
                            images: Get.arguments["data"]["Images"],
                            expectedPrice: Get.arguments["data"]
                                ["ExpectedPrice"],
                            priceRentNegotiable: Get.arguments["data"]
                                ["PriceRentNegotiable"],
                            bookingToken: Get.arguments["data"]["BookingToken"],
                            subStatus: Get.arguments["data"]["SubStatus"],
                            mainStatus: Get.arguments["data"]["MainStatus"],
                            monthRent: Get.arguments["data"]["MonthRent"],
                            securityAmt: Get.arguments["data"]["SecurityAmt"],
                            maintenanceCharge: Get.arguments["data"]
                                ["MaintenanceCharge"],
                          );

                          if (typo!.type == "Flat/Apartment" ||
                              typo!.type == "Builder Floor" ||
                              typo!.type == "Penthouse" ||
                              typo!.type == "Farm House") {
                            if (utilAddPro.utilAddProCon.bedRoomIndex ==
                                0.obs) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select Bedroom"));
                            } else if (utilAddPro
                                    .utilAddProCon.bathRoomIndex.value ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select Bathroom"));
                            } else if (utilAddPro.txtFloor.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please provide total floors"));
                            } else if (utilAddPro.txtFloorNo.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please provide floor number"));
                            } else if (utilAddPro.utilAddProCon.gv.value ==
                                "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select furnishing status"));
                            } else if (utilAddPro.txtCarpet.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter carpet area"));
                            } else if (utilAddPro.txtSuper.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter super area"));
                            } else {
                              await PropertyDetails.sendPropertyData(
                                  userID!, propertyID!, proDetails, context);

                              Get.offNamed(
                                "/show_property",
                                arguments: {
                                  "userId": userID,
                                  "propertyId": propertyID,
                                },
                              );
                            }
                          } else if (typo!.type == "House" ||
                              typo!.type == "Villa") {
                            if (utilAddPro.utilAddProCon.bedRoomIndex.value ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select Bedroom"));
                            } else if (utilAddPro
                                    .utilAddProCon.bathRoomIndex.value ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select Bathroom"));
                            } else if (utilAddPro.txtOnlyFloorNo.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please provide total floors"));
                            } else if (utilAddPro.utilAddProCon.gv.value ==
                                "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select furnishing status"));
                            } else if (utilAddPro.txtCarpet.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter carpet area"));
                            } else if (utilAddPro.txtSuper.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter super area"));
                            } else {
                              await PropertyDetails.sendPropertyData(
                                  userID!, propertyID!, proDetails, context);

                              Get.offNamed(
                                "/show_property",
                                arguments: {
                                  "userId": userID,
                                  "propertyId": propertyID,
                                },
                              );
                            }
                          } else if (typo!.type == "Plot") {
                            if (utilAddPro.utilAddProCon.boundaryGv.value ==
                                "") {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar(
                                  "Please select if the boundary wall is made"));
                            } else if (utilAddPro.txtPlotArea.text.isEmpty &&
                                utilAddPro.txtSuper.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter the plot area"));
                            } else {
                              await PropertyDetails.sendPropertyData(
                                  userID!, propertyID!, proDetails, context);

                              Get.offNamed(
                                "/show_property",
                                arguments: {
                                  "userId": userID,
                                  "propertyId": propertyID,
                                },
                              );
                            }
                          } else if (typo!.type == "Studio Apartment") {
                            if (utilAddPro.utilAddProCon.bathRoomIndex.value ==
                                0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select Bathroom"));
                            } else if (utilAddPro.txtFloor.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please provide total floors"));
                            } else if (utilAddPro.txtFloorNo.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please provide floor number"));
                            } else if (utilAddPro.utilAddProCon.gv.value ==
                                "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please select furnishing status"));
                            } else if (utilAddPro.txtCarpet.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter carpet area"));
                            } else if (utilAddPro.txtSuper.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar("Please enter super area"));
                            } else {
                              await PropertyDetails.sendPropertyData(
                                  userID!, propertyID!, proDetails, context);

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
                      ),
                    ),
                    const Spacer(),
                    CustomElevatedButton2(
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (typo!.type == "Flat/Apartment" ||
                            typo!.type == "Builder Floor" ||
                            typo!.type == "Penthouse" ||
                            typo!.type == "Farm House") {
                          if (utilAddPro.utilAddProCon.bedRoomIndex == 0.obs) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select Bedroom"));
                          } else if (utilAddPro
                                  .utilAddProCon.bathRoomIndex.value ==
                              0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select Bathroom"));
                          } else if (utilAddPro.txtFloor.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please provide total floors"));
                          } else if (utilAddPro.txtFloorNo.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please provide floor number"));
                          } else if (utilAddPro.utilAddProCon.gv.value == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select furnishing status"));
                          } else if (utilAddPro.txtCarpet.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter carpet area"));
                          } else if (utilAddPro.txtSuper.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter super area"));
                          } else {
                            int bathRoomCnt =
                                utilAddPro.utilAddProCon.bathRoomIndex.value -
                                    1;
                            int balconyCnt =
                                utilAddPro.utilAddProCon.balconyIndex.value - 1;

                            Property proDetails = Property(
                              bedroom:
                                  "${utilAddPro.utilAddProCon.bedRoomIndex} BHK",
                              bathroom: bathRoomCnt.toString(),
                              balcony: balconyCnt.toString(),
                              totalFloor: utilAddPro.txtFloor.text.trim(),
                              yourFloor: utilAddPro.txtFloorNo.text.trim(),
                              furnishing:
                                  utilAddPro.utilAddProCon.gv.toString(),
                              carpetArea:
                                  "${utilAddPro.txtCarpet.text.trim()} ${utilAddPro.txtUnitCarpet.text.trim()}",
                              carpetAreaUnit: utilAddPro.txtUnitCarpet.text.trim(),
                              superArea:
                                  "${utilAddPro.txtSuper.text.trim()} ${utilAddPro.txtUnitSuper.text.trim()}",
                              superAreaUnit:
                                  utilAddPro.txtUnitSuper.text.trim(),
                            );

                            nextPage(proDetails);
                          }
                        } else if (typo!.type == "House" ||
                            typo!.type == "Villa") {
                          if (utilAddPro.utilAddProCon.bedRoomIndex.value ==
                              0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select Bedroom"));
                          } else if (utilAddPro
                                  .utilAddProCon.bathRoomIndex.value ==
                              0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select Bathroom"));
                          } else if (utilAddPro.txtOnlyFloorNo.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please provide total floors"));
                          } else if (utilAddPro.utilAddProCon.gv.value == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select furnishing status"));
                          } else if (utilAddPro.txtCarpet.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter carpet area"));
                          } else if (utilAddPro.txtSuper.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter super area"));
                          } else {
                            int bathRoomCnt =
                                utilAddPro.utilAddProCon.bathRoomIndex.value -
                                    1;
                            int balconyCnt =
                                utilAddPro.utilAddProCon.balconyIndex.value - 1;

                            Property proDetails = Property(
                              bedroom:
                                  "${utilAddPro.utilAddProCon.bedRoomIndex} BHK",
                              bathroom: bathRoomCnt.toString(),
                              balcony: balconyCnt.toString(),
                              totalFloor: utilAddPro.txtOnlyFloorNo.text.trim(),
                              furnishing:
                                  utilAddPro.utilAddProCon.gv.toString(),
                              carpetArea:
                                  "${utilAddPro.txtCarpet.text.trim()} ${utilAddPro.txtUnitCarpet.text.trim()}",
                              carpetAreaUnit: utilAddPro.txtUnitCarpet.text,
                              superArea:
                                  "${utilAddPro.txtSuper.text.trim()} ${utilAddPro.txtUnitSuper.text.trim()}",
                              superAreaUnit:
                                  utilAddPro.txtUnitSuper.text.trim(),
                              roadWidth: utilAddPro.txtRoadWidth.text.trim(),
                            );

                            print("main type rerrerrrrrrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeee $mainType");

                            nextPage(proDetails);
                          }
                        } else if (typo!.type == "Plot") {
                          if (utilAddPro.utilAddProCon.boundaryGv.value == "") {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar(
                                "Please select if the boundary wall is made"));
                          } else if (utilAddPro.txtPlotArea.text.isEmpty &&
                              utilAddPro.txtSuper.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter the plot area"));
                          } else {
                            Property proDetails = Property(
                              noAllowCon: utilAddPro.txtLandFloor.text.trim(),
                              openSides: utilAddPro.txtLandSide.text.trim(),
                              roadWidth: utilAddPro.txtRoadWidth.text.trim(),
                              boundaryWall:
                                  utilAddPro.utilAddProCon.boundaryGv.value,
                              plotArea:
                                  "${utilAddPro.txtPlotArea.text.trim()} ${utilAddPro.txtPlotUnit.text.trim()}",
                              plotAreaUnit: utilAddPro.txtPlotUnit.text.trim(),
                              plotLength: utilAddPro.txtPlotLength.text.trim(),
                              plotBreadth:
                                  utilAddPro.txtPlotBreadth.text.trim(),
                            );

                            nextPage(proDetails);
                          }
                        } else if (typo!.type == "Studio Apartment") {
                          if (utilAddPro.utilAddProCon.bathRoomIndex.value ==
                              0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select Bathroom"));
                          } else if (utilAddPro.txtFloor.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please provide total floors"));
                          } else if (utilAddPro.txtFloorNo.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please provide floor number"));
                          } else if (utilAddPro.utilAddProCon.gv.value == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please select furnishing status"));
                          } else if (utilAddPro.txtCarpet.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter carpet area"));
                          } else if (utilAddPro.txtSuper.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar("Please enter super area"));
                          } else {
                            int bathRoomCnt =
                                utilAddPro.utilAddProCon.bathRoomIndex.value -
                                    1;

                            Property proDetails = Property(
                              bathroom: bathRoomCnt.toString(),
                              totalFloor: utilAddPro.txtFloor.text.trim(),
                              yourFloor: utilAddPro.txtFloorNo.text.trim(),
                              furnishing:
                                  utilAddPro.utilAddProCon.gv.toString(),
                              carpetArea:
                                  "${utilAddPro.txtCarpet.text.trim()} ${utilAddPro.txtUnitCarpet.text.trim()}",
                              carpetAreaUnit: utilAddPro.txtUnitCarpet.text.trim(),
                              superArea:
                                  "${utilAddPro.txtSuper.text.trim()} ${utilAddPro.txtUnitSuper.text.trim()}",
                              superAreaUnit:
                                  utilAddPro.txtUnitSuper.text.trim(),
                            );

                            nextPage(proDetails);
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
    );
  }
}
