import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/property_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ShowProperty extends StatefulWidget {
  const ShowProperty({super.key});

  @override
  State<ShowProperty> createState() => _ShowPropertyState();
}

class _ShowPropertyState extends State<ShowProperty> {
  final BottomController bottCon = Get.put(BottomController());
  final AuthController authCon = Get.find<AuthController>();

  List mapKeys = [
    "BedRoom",
    "YourFloor",
    "FullAddress",
    "Description",
    "PlotArea",
    "Address",
    "MaintenanceCharge",
    "SecurityAmt",
    "BookingToken",
    "RoadWidth",
    "Furnishing",
    "MonthRent",
    "BoundaryWall",
    "PropertyID",
    "PriceRentNegotiable",
    "BathRoom",
    "SuperAreaUnit",
    "CornerShop",
    "NoAllowConstruction",
    "RoadFacing",
    "CarpetArea",
    "SuperArea",
    "SubStatus",
    "OpenSides",
    "CarpetAreaUnit",
    "PlotBreadth",
    "ExpectedPrice",
    "Balcony",
    "Post",
    "Images",
    "PantryCafeteria",
    "TotalFloor",
    "MainType",
    "City",
    "MainStatus",
    "Type",
    "Washroom",
    "State",
    "PlotAreaUnit",
    "Country",
    "PlotLength"
  ];

  List flatDescription = [
    "Total Floor",
    "Floor no. of Property",
    "Bedroom",
    "Bathroom",
    "Balcony",
    "Furnishing",
    "Carpet Area",
    "Super Area",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpFlat = [
    "TotalFloor",
    "YourFloor",
    "BedRoom",
    "BathRoom",
    "Balcony",
    "Furnishing",
    "CarpetArea",
    "SuperArea",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List houseDescription = [
    "Total Floor",
    "Bedroom",
    "Bathroom",
    "Balcony",
    "Furnishing",
    "Carpet Area",
    "Super Area",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpHouse = [
    "TotalFloor",
    "BedRoom",
    "BathRoom",
    "Balcony",
    "Furnishing",
    "CarpetArea",
    "SuperArea",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List plotDescription = [
    "Boundary Wall",
    "Plot Area",
    "Plot Length (yrd)",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpPlot = [
    "BoundaryWall",
    "PlotArea",
    "PlotLength",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List studioDescription = [
    "Total Floor",
    "Floor no. of Property",
    "Bathroom",
    "Furnishing",
    "Carpet Area",
    "Super Area",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpStudio = [
    "TotalFloor",
    "YourFloor",
    "BathRoom",
    "Furnishing",
    "CarpetArea",
    "SuperArea",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List officeDescription = [
    "Total Floor",
    "Floor no. of Property",
    "Bathroom",
    "Furnishing",
    "Carpet Area",
    "Super Area",
    "Type of Pantry/Cafeteria",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpOffice = [
    "TotalFloor",
    "YourFloor",
    "BathRoom",
    "Furnishing",
    "CarpetArea",
    "SuperArea",
    "PantryCafeteria",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List shopDescription = [
    "Total Floor",
    "Floor no. of Property",
    "Washroom",
    "Furnishing",
    "Carpet Area",
    "Super Area",
    "Type of Pantry/Cafeteria",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpShop = [
    "TotalFloor",
    "YourFloor",
    "Washroom",
    "Furnishing",
    "CarpetArea",
    "SuperArea",
    "PantryCafeteria",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List landDescription = [
    "No. Floor Allow construction",
    "Is Boundary Wall",
    "Plot Area",
    "Plot Length (yrd)",
    "Status of Property",
    "Status of Construction",
    "Negotiation",
  ];

  List cmpLand = [
    "NoAllowConstruction",
    "BoundaryWall",
    "PlotArea",
    "PlotLength",
    "MainStatus",
    "SubStatus",
    "PriceRentNegotiable",
  ];

  List propertyDatabaseDetail = [];

  int cmpLen = 0;
  int descriptionLen = 0;

  List cmpListType = [];
  List descriptionListType = [];

  Map<String, dynamic> data = {};

  List<String> profileValues = [
    "ProfileName",
    "PhoneNo",
    "Email",
    "Address",
  ];

  List<String> profileNames = [
    "Property Owner",
    "Phone No.",
    "Email",
    "Address",
  ];

  String? userID;
  String? propertyID;
  String? route;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userID = Get.arguments["userId"];
    propertyID = Get.arguments["propertyId"];
    route = Get.arguments["route"];
  }

  Future<Map<String, dynamic>?> getProperties() async {
    if (route == "request_page_a") {
      DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection("property_status")
          .where("PropertyID", isEqualTo: propertyID)
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs.first;
      });

      return snapShot.data() as Map<String, dynamic>?;

    } else {
      DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection("all_property")
          .doc(propertyID)
          .get();

      return snapShot.data() as Map<String, dynamic>;
    }
  }

  Future<DocumentSnapshot> getProfile() async {
    CollectionReference collection = FirebaseFirestore.instance.collection("user");

    return await collection.doc(userID).get();
  }

  List<String>? imgUrls;

  Future<void> shareImages() async {
    try {
      easyLoading(context);

      if (imgUrls!.isNotEmpty) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        List<String> filePaths = [];

        for (String imageUrl in imgUrls!) {
          String fileName = imageUrl.split("/").last;
          String filePath = "$tempPath/$fileName";
          File file = File(filePath);

          http.Response response = await http.get(Uri.parse(imageUrl));
          await file.writeAsBytes(response.bodyBytes);

          Uint8List pngBytes = await convertToPng(file);
          String pngPath = "$tempPath/${fileName.split(".").first}.png";
          File pngFile = File(pngPath);
          await pngFile.writeAsBytes(pngBytes);

          filePaths.add(pngPath);
        }

        Get.back();

        Share.shareFiles(filePaths);
      } else {
        Get.back();

        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar("No images to share"));
      }
    } catch (e) {
      Get.back();

      if (kDebugMode) {
        print("Error sharing images ..... $e");
      }
    }
  }

  Future<Uint8List> convertToPng(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    ui.Image image = await decodeImageFromList(imageBytes);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to convert image to PNG format.");
    }
    return byteData.buffer.asUint8List();
  }

  String phoneNo = "";

  void _launchWhatsApp(String phoneNumber) async {
    String whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    await canLaunch(whatsappUrl)
        ? await launch(whatsappUrl)
        : throw "Could not launch $whatsappUrl";
  }

  void _makePhoneCall(String phoneNumber) async {
    String telUrl = "tel:$phoneNumber";
    await canLaunch(telUrl)
        ? await launch(telUrl)
        : throw "Could not launch $telUrl";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

            if (data["Type"] == "Flat/Apartment" ||
                data["Type"] == "Builder Floor" ||
                data["Type"] == "Penthouse" ||
                data["Type"] == "Farm House") {
              cmpLen = cmpFlat.length;
              cmpListType = cmpFlat;
              descriptionLen = flatDescription.length;
            } else if (data["Type"] == "Plot") {
              cmpLen = cmpPlot.length;
              cmpListType = cmpPlot;
              descriptionLen = plotDescription.length;
            } else if (data["Type"] == "House" || data["Type"] == "Villa") {
              cmpLen = cmpHouse.length;
              cmpListType = cmpHouse;
              descriptionLen = houseDescription.length;
            } else if (data["Type"] == "Studio Apartment") {
              cmpLen = cmpStudio.length;
              cmpListType = cmpStudio;
              descriptionLen = studioDescription.length;
            } else if (data["Type"] == "Office Space" ||
                data["Type"] == "Office in IT Park/SEZ") {
              cmpLen = cmpOffice.length;
              cmpListType = cmpOffice;
              descriptionLen = officeDescription.length;
            } else if (data["Type"] == "Shop" ||
                data["Type"] == "Showroom" ||
                data["Type"] == "Warehouse/Godown" ||
                data["Type"] == "Industrial Building" ||
                data["Type"] == "Industrial Shed") {
              cmpLen = cmpShop.length;
              cmpListType = cmpShop;
              descriptionLen = shopDescription.length;
            } else if (data["Type"] == "Commercial Land" ||
                data["Type"] == "Industrial Land" ||
                data["Type"] == "Agricultural Land") {
              cmpLen = cmpLand.length;
              cmpListType = cmpLand;
              descriptionLen = landDescription.length;
            } else {
              if (kDebugMode) {
                print("Type not match.....");
              }
            }

            for (int i = 0; i < cmpLen; i++) {
              propertyDatabaseDetail.add(data["${cmpListType[i]}"]);
            }

            for (int n = 0; n < descriptionLen; n++) {
              if (data["Type"] == "Flat/Apartment" ||
                  data["Type"] == "Builder Floor" ||
                  data["Type"] == "Penthouse" ||
                  data["Type"] == "Farm House") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpFlat.removeAt(n);
                  flatDescription.removeAt(n);
                  descriptionLen = flatDescription.length;
                  descriptionListType = flatDescription;
                } else {
                  descriptionListType = flatDescription;
                }
              } else if (data["Type"] == "Plot") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpPlot.removeAt(n);
                  plotDescription.removeAt(n);
                  descriptionLen = plotDescription.length;
                  descriptionListType = plotDescription;
                } else {
                  descriptionListType = plotDescription;
                }
              } else if (data["Type"] == "House" || data["Type"] == "Villa") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpHouse.removeAt(n);
                  houseDescription.removeAt(n);
                  descriptionLen = houseDescription.length;
                  descriptionListType = houseDescription;
                } else {
                  descriptionListType = houseDescription;
                }
              } else if (data["Type"] == "Studio Apartment") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpStudio.removeAt(n);
                  studioDescription.removeAt(n);
                  descriptionLen = studioDescription.length;
                  descriptionListType = studioDescription;
                } else {
                  descriptionListType = studioDescription;
                }
              } else if (data["Type"] == "Office Space" ||
                  data["Type"] == "Office in IT Park/SEZ") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpOffice.removeAt(n);
                  officeDescription.removeAt(n);
                  descriptionLen = officeDescription.length;
                  descriptionListType = officeDescription;
                } else {
                  descriptionListType = officeDescription;
                }
              } else if (data["Type"] == "Shop" ||
                  data["Type"] == "Showroom" ||
                  data["Type"] == "Warehouse/Godown" ||
                  data["Type"] == "Industrial Building" ||
                  data["Type"] == "Industrial Shed") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpShop.removeAt(n);
                  shopDescription.removeAt(n);
                  descriptionLen = shopDescription.length;
                  descriptionListType = shopDescription;
                } else {
                  descriptionListType = shopDescription;
                }
              } else if (data["Type"] == "Commercial Land" ||
                  data["Type"] == "Industrial Land" ||
                  data["Type"] == "Agricultural Land") {
                if (propertyDatabaseDetail[n] == "-1" ||
                    propertyDatabaseDetail[n] == null ||
                    propertyDatabaseDetail[n] == "" ||
                    propertyDatabaseDetail[n] == " ") {
                  propertyDatabaseDetail.removeAt(n);
                  cmpLand.removeAt(n);
                  landDescription.removeAt(n);
                  descriptionLen = landDescription.length;
                  descriptionListType = landDescription;
                } else {
                  descriptionListType = landDescription;
                }
              } else {
                if (kDebugMode) {
                  print("Condition not match.....");
                }
              }
            }

            if (data.isNotEmpty) {
              List<dynamic> img = data["Images"];
              imgUrls = img.map((dynamic item) => item.toString()).toList();

              return Scaffold(
                body: SafeArea(
                  child: NotificationListener(
                    onNotification: (notification) {
                      bottCon.onScroll();
                      return false;
                    },
                    child: ListView(
                      controller: bottCon.scrollController,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await photoDialog(data["Images"]);
                              },
                              child: Container(
                                height: 230.0,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: CachedNetworkImage(
                                  imageUrl: "${data["Images"][0]}",
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return const Icon(
                                      Icons.error,
                                    );
                                  },
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) {
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
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10.0,
                              top: 5.0,
                              child: IconButton(
                                onPressed: () => Get.back(),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(MyColors.white0),
                                ),
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  size: 20.0,
                                  weight: 20.0,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10.0,
                              bottom: 5.0,
                              child: GestureDetector(
                                onTap: () async => await photoDialog(data["Images"]),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: MyColors.white0,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${data["Images"].length - 1}+",
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          color: MyColors.black0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Icon(
                                        Icons.photo,
                                        size: 15.0,
                                        weight: 20.0,
                                        color: MyColors.green3,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            (route == "display_search" ||
                                    route == "home" ||
                                    route == "see_all")
                                ? Positioned(
                                    right: 10.0,
                                    top: 5.0,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (await Permission.storage
                                            .request()
                                            .isGranted) {
                                          await shareImages();
                                        } else {
                                          showSettingsDialog(context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                MyColors.white0),
                                      ),
                                      icon: const Icon(
                                        Icons.share,
                                        size: 20.0,
                                        weight: 20.0,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data["Post"] == "Sell"
                                              ? "₹ ${data["PriceInString"]}"
                                              : "₹ ${data["RentInString"]}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: MyColors.green3,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const Text("  |  "),
                                        Expanded(
                                          child: Text(
                                            "${data["Type"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: MyColors.black0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3.0),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 15.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${data["City"]}, ${data["State"]}",
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: MyColors.black0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  FutureBuilder(
                                    future: getProfile(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          Map<String, dynamic> data = snapshot
                                                      .data!
                                                      .data()
                                                  as Map<String, dynamic>? ??
                                              {};

                                          phoneNo =
                                              "${data["DC"]}${data["PhoneNo"]}";

                                          return GestureDetector(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child: Wrap(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical:
                                                                      5.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                MyColors.white0,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10.0)),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Owner Profile",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "nunito",
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () => Get
                                                                            .back(),
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStatePropertyAll(
                                                                              MyColors.white1),
                                                                    ),
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      size:
                                                                          20.0,
                                                                      weight:
                                                                          8.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            60.0),
                                                                child: Center(
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        90.0,
                                                                    width: 90.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50.0),
                                                                      image: data["ProfileImage"] !=
                                                                              ""
                                                                          ? DecorationImage(
                                                                              image: CachedNetworkImageProvider(data["ProfileImage"]),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : const DecorationImage(
                                                                              image: AssetImage("assets/images/common_img/profile1.png"),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10.0),
                                                              ListView
                                                                  .separated(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    profileNames
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            profileNames[index],
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: "nunito",
                                                                              fontSize: 14.0,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          data[profileValues[
                                                                              index]],
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                "nunito",
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                MyColors.black0,
                                                                          ),
                                                                          maxLines:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return const Divider();
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  height: 15.0),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: data["ProfileImage"] != ""
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          data["ProfileImage"],
                                                      height: 40.0,
                                                      width: 40.0,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                        Icons.error_outlined,
                                                        color: MyColors.red0,
                                                      ),
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        color: MyColors.green3,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/common_img/profile1.png",
                                                      fit: BoxFit.cover,
                                                      height: 40.0,
                                                      width: 40.0,
                                                    ),
                                            ),
                                          );
                                        } else {
                                          return const Text("No data found.");
                                        }
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        return Center(
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Property Details",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "nunito",
                                fontWeight: FontWeight.bold,
                                color: MyColors.black0),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey.shade200,
                              thickness: 0.8,
                              indent: 5.0,
                              endIndent: 5.0,
                            );
                          },
                          itemCount: descriptionLen,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${descriptionListType[index]}",
                                          style: const TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${propertyDatabaseDetail[index]}",
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          fontSize: 14.0,
                                          color: MyColors.black0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        data["SecurityAmt"] != "" && data["SecurityAmt"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["SecurityAmt"] != "" && data["SecurityAmt"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Security Amount"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹ ${data["SecurityAmt"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        data["RoadWidth"] != "" && data["RoadWidth"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["RoadWidth"] != "" && data["RoadWidth"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Road Width(meter)"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data["RoadWidth"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["BookingToken"] != "" &&
                                data["BookingToken"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["BookingToken"] != "" &&
                                data["BookingToken"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Booking Amount"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹ ${data["BookingToken"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["PlotBreadth"] != "" && data["PlotBreadth"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : SizedBox(),
                        data["PlotBreadth"] != "" && data["PlotBreadth"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Plot Breadth (yrd)"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data["PlotBreadth"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["CornerShop"] != "" && data["CornerShop"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["CornerShop"] != "" && data["CornerShop"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Is Corner Shop"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data["CornerShop"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["RoadFacing"] != "" && data["RoadFacing"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["RoadFacing"] != "" && data["RoadFacing"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Is Main Road Facing"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data["RoadFacing"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["OpenSides"] != "" && data["OpenSides"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["OpenSides"] != "" && data["OpenSides"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"No. of open side"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data["OpenSides"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        data["MaintenanceCharge"] != "" &&
                                data["MaintenanceCharge"] != null
                            ? Divider(
                                color: Colors.grey.shade200,
                                thickness: 0.8,
                                indent: 5.0,
                                endIndent: 5.0,
                              )
                            : const SizedBox(),
                        data["MaintenanceCharge"] != "" &&
                                data["MaintenanceCharge"] != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"Maintenance Charge"}",
                                            style: const TextStyle(
                                              fontFamily: "nunito",
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹ ${data["MaintenanceCharge"]}",
                                          style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: MyColors.black0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 20.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Property Address Details",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "nunito",
                                fontWeight: FontWeight.bold,
                                color: MyColors.black0),
                          ),
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Address",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "${data["Address"]}",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Text(
                                      "State",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "${data["State"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "City",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "${data["City"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    const Text(
                                      "Country",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      "${data["Country"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 10.0),
                        data["Description"] != ""
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Property Description",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: "nunito",
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.black0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Text(
                                      "${data["Description"]}",
                                      style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: MyColors.black0,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Obx(
                  () => AnimatedContainer(
                    height: bottCon.isVisible.value ? 67.0 : 0.0,
                    curve: Curves.linearToEaseOut,
                    duration: const Duration(milliseconds: 700),
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _launchWhatsApp(phoneNo),
                            style: ButtonStyle(
                              shape: const MaterialStatePropertyAll(
                                ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade300),
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 13.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Enquiry",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "nunito",
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Image.asset(
                                  "assets/images/common_img/whatsapp.png",
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _makePhoneCall(phoneNo),
                            style: ButtonStyle(
                              shape: const MaterialStatePropertyAll(
                                ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(MyColors.green3),
                              padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 13.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Call Owner",
                                  style: TextStyle(
                                    color: MyColors.white0,
                                    fontFamily: "nunito",
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Icon(
                                  Icons.call,
                                  size: 20.0,
                                  color: MyColors.white0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: (route != "display_search" &&
                        route != "home" &&
                        route != "see_all" && route != "request_page_a")
                    ? ExpandableFab(
                        distance: 100.0,
                        children: [
                          ActionButton(
                            onPressed: () async {
                              await deleteDialog(
                                context,
                                () async {
                                  Get.back();
                                  await PropertyDetails.deleteData(
                                      data["PropertyID"],
                                      authCon.userid!,
                                      context);
                                  Get.back();
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          ActionButton(
                            onPressed: () {
                              Map<String, dynamic> arguments = {
                                "mainType": data["MainType"],
                                "data": data,
                                "propertyId": propertyID,
                                "userId": userID,
                              };


                              print("main type ssssssssssssssssshhhhhhhhhhhhhhhhhhhhhhhhhhh ${arguments["mainType"]}");

                              if (data["MainType"] == "Residential") {
                                arguments["pageInfo"] = "property_residential";

                                Get.offNamed(
                                  "/property_residential",
                                  arguments: arguments,
                                );
                              } else {
                                arguments["pageInfo"] = "property_commercial";
                                Get.offNamed(
                                  "/property_commercial",
                                  arguments: arguments,
                                );
                              }
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          ActionButton(
                            onPressed: () async {
                              if (await Permission.storage
                                  .request()
                                  .isGranted) {
                                await shareImages();
                              } else {
                                showSettingsDialog(context);
                              }
                            },
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      )
                    : const SizedBox(),
              );
            } else {
              return const Scaffold(
                  body: Center(child: Text("No data available")));
            }
          } else {
            return const Scaffold(body: Center(child: Text("No data found")));
          }
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")));
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                height: 65.0,
                width: 65.0,
                padding: const EdgeInsets.all(17.0),
                child: CircularProgressIndicator(
                  color: MyColors.green3,
                  strokeWidth: 2.2,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> photoDialog(List<dynamic> images) async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: MyColors.white0,
      builder: (context) {
        return Stack(
          children: [
            ListView.separated(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.error,
                    );
                  },
                  progressIndicatorBuilder: (context, url, downloadProgress) {
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
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 10.0,
                  color: Colors.grey.shade200,
                );
              },
            ),
            Positioned(
              right: 10.0,
              top: 10.0,
              child: IconButton(
                onPressed: () => Get.back(),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(MyColors.white1),
                ),
                icon: const Icon(
                  Icons.close,
                  size: 20.0,
                  weight: 20.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BottomController extends GetxController {
  RxBool isVisible = true.obs;

  final ScrollController scrollController = ScrollController();

  void onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isVisible.value = true;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isVisible.value = false;
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollController.dispose();
    super.onClose();
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            backgroundColor: MyColors.green1,
            child: Icon(
              Icons.create,
              color: MyColors.white0,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: MyColors.green3,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
