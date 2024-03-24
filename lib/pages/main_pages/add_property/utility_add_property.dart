import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/text_field3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UtilityAddProperty {
  UtilityAddPropertyCon utilAddProCon = Get.put(UtilityAddPropertyCon());

  Widget bedRoomButton(String text, int index) {
    return GestureDetector(
      onTap: () => utilAddProCon.setIndexBedRoom(index),
      child: Obx(
        () => Container(
          width: 80.0,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (utilAddProCon.bedRoomIndex == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (utilAddProCon.bedRoomIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: (utilAddProCon.bedRoomIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
              fontFamily: "nunito",
            ),
          ),
        ),
      ),
    );
  }

  Widget bathRoomButton(String text, int index) {
    return GestureDetector(
      onTap: () => utilAddProCon.setIndexBathRoom(index),
      child: Obx(
        () => Container(
          width: 80.0,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (utilAddProCon.bathRoomIndex == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (utilAddProCon.bathRoomIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: (utilAddProCon.bathRoomIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
              fontFamily: "nunito",
            ),
          ),
        ),
      ),
    );
  }

  Widget balconyButton(String text, int index) {
    return GestureDetector(
      onTap: () => utilAddProCon.setIndexBalcony(index),
      child: Obx(
        () => Container(
          width: 80.0,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (utilAddProCon.balconyIndex == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (utilAddProCon.balconyIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: (utilAddProCon.balconyIndex == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
              fontFamily: "nunito",
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController txtFloor = TextEditingController();
  TextEditingController txtFloorNo = TextEditingController();
  TextEditingController txtUnitCarpet = TextEditingController(text: "Sqrt");
  TextEditingController txtUnitSuper = TextEditingController(text: "Sqrt");
  TextEditingController txtCarpet = TextEditingController();
  TextEditingController txtSuper = TextEditingController();
  TextEditingController txtLandSide = TextEditingController();
  TextEditingController txtLandFloor = TextEditingController();
  TextEditingController txtRoadWidth = TextEditingController();
  TextEditingController txtPlotArea = TextEditingController();
  TextEditingController txtPlotUnit = TextEditingController(text: "Sqrt");
  TextEditingController txtPlotLength = TextEditingController();
  TextEditingController txtPlotBreadth = TextEditingController();
  TextEditingController txtTotalFloor = TextEditingController();
  TextEditingController txtFloorNoOfPro = TextEditingController();
  TextEditingController txtOnlyFloorNo = TextEditingController();

  List unit = [
    "Sqft",
    "Sqyrd",
    "Sqm",
    "Acre",
    "Bigha",
    "Hectare",
    "Marla",
    "kanal",
    "Biswa1",
    "Biswa2",
    "Ground",
    "Aankadam",
    "Rood",
    "Chatak",
    "Kottah",
    "Cent",
    "Perch",
    "Guntha",
    "Are",
  ];
  List<dynamic> floorNo = ["Lower Basement", "Ground"];

  Future<void> showBottomDialogue(int value, BuildContext context) async {
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
                  Text(
                    value == 1 || value == 8 || value == 10
                        ? "Total Property Floor"
                        : value == 2 || value == 9
                            ? "Floor No."
                            : value == 6
                                ? "Total Floor Allowed"
                                : "Unit",
                    style: const TextStyle(
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
                  itemCount:
                      value == 1 || value == 6 || value == 8 || value == 10
                          ? 20
                          : value == 2 || value == 9
                              ? 22
                              : value == 5
                                  ? 4
                                  : value == 7
                                      ? 19
                                      : 19,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              if (value == 1) {
                                txtFloor.text = "${index + 1}";
                              } else if (value == 2) {
                                txtFloorNo.text = "${floorNo[index]}";
                              } else if (value == 3) {
                                txtUnitCarpet.text = "${unit[index]}";
                              } else if (value == 4) {
                                txtUnitSuper.text = "${unit[index]}";
                              } else if (value == 5) {
                                txtLandSide.text = "${index + 1}";
                              } else if (value == 6) {
                                txtLandFloor.text = "${index + 1}";
                              } else if (value == 7) {
                                txtPlotUnit.text = "${unit[index]}";
                              } else if (value == 8) {
                                txtTotalFloor.text = "${index + 1}";
                              } else if (value == 9) {
                                txtFloorNoOfPro.text = "${floorNo[index]}";
                              } else if (value == 10) {
                                txtOnlyFloorNo.text = "${index + 1}";
                              }
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      value == 1 || value == 8 || value == 10
                                          ? "${index + 1}"
                                          : value == 2 || value == 9
                                              ? "${floorNo[index]}"
                                              : value == 5
                                                  ? "${index + 1}"
                                                  : value == 6
                                                      ? "${index + 1}"
                                                      : value == 7
                                                          ? "${unit[index]}"
                                                          : "${unit[index]}",
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

  Widget unitDetails(int num) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Unit Details",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              Visibility(
                visible: num == 1 || num == 3 ? true : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      child: Text(
                        " Bedroom",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 37.0,
                      child: ListView.builder(
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 5.0, right: 6.5),
                        itemBuilder: (context, index) {
                          return bedRoomButton("${index + 1} BHK", index + 1);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Visibility(
                visible: num == 2 || num == 3 || num == 4 ? true : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                      child: Text(
                        num != 4 ? " Bathroom" : " Washrooms",
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 37.0,
                      child: ListView.builder(
                        itemCount: 11,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 5.0, right: 6.5),
                        itemBuilder: (context, index) {
                          return bathRoomButton("$index", index + 1);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              Visibility(
                visible: num == 3 ? true : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      child: Text(
                        " Balcony (optional)",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 37.0,
                      child: ListView.builder(
                        itemCount: 11,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 5.0, right: 6.5),
                        itemBuilder: (context, index) {
                          return balconyButton("$index", index + 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget floorDetails(BuildContext context) {
    floorNo.addAll(List.generate(20, (index) => index + 1));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Floor Details",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: CustomTextField3(
            controller: txtFloor,
            labelText: "Select Total Number of Floors",
            onTap: () => showBottomDialogue(1, context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: CustomTextField3(
            controller: txtFloorNo,
            labelText: "Floor No. of your Property",
            onTap: () => showBottomDialogue(2, context),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget onlyFloorNoDetails(BuildContext context) {
    floorNo.addAll(List.generate(20, (index) => index + 1));
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Floor Details",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: CustomTextField3(
            controller: txtOnlyFloorNo,
            labelText: "Select Total Number of Floors",
            onTap: () => showBottomDialogue(10, context),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget furnishingDetails() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Furnishing",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text(
              "Unfurnished",
              style: TextStyle(
                fontFamily: "nunito",
              ),
            ),
            activeColor: MyColors.green2,
            value: "Unfurnished",
            groupValue: utilAddProCon.gv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValue(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: MyColors.green2,
            title: const Text(
              "Semi-Furnished",
              style: TextStyle(
                fontFamily: "nunito",
              ),
            ),
            value: "Semi-Furnished",
            groupValue: utilAddProCon.gv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValue(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text(
              "Fully-Furnished",
              style: TextStyle(
                fontFamily: "nunito",
              ),
            ),
            activeColor: MyColors.green2,
            value: "Fully-Furnished",
            groupValue: utilAddProCon.gv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValue(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget propertyAreaDetails(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Property Area",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField3(
                      controller: txtCarpet,
                      labelText: "Carpet Area",
                      keyboardType: TextInputType.number,
                      suffixIcon: null,
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  SizedBox(
                    width: 100.0,
                    child: CustomTextField3(
                      controller: txtUnitCarpet,
                      onTap: () => showBottomDialogue(3, context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField3(
                      controller: txtSuper,
                      labelText: "Super Area",
                      keyboardType: TextInputType.number,
                      suffixIcon: null,
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  SizedBox(
                    width: 100.0,
                    child: CustomTextField3(
                      controller: txtUnitSuper,
                      onTap: () => showBottomDialogue(4, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cafeteriaDetails() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Pantry/Cafeteria (optional)",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Dry"),
            value: "Dry",
            groupValue: utilAddProCon.cafeteriaGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueCafeteria(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Wet"),
            value: "Wet",
            groupValue: utilAddProCon.cafeteriaGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueCafeteria(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Not Available"),
            value: "Not Available",
            groupValue: utilAddProCon.cafeteriaGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueCafeteria(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget washroomDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Washroom (optional)",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text("Personal Washroom"),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Yes"),
            value: "Yes",
            groupValue: utilAddProCon.washroomGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueWashroom(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("No"),
            value: "No",
            groupValue: utilAddProCon.washroomGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueWashroom(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget cornerShopDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Corner Shop (optional)",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Yes"),
            value: "Yes",
            groupValue: utilAddProCon.cornerShopGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueCornerShop(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("No"),
            value: "No",
            groupValue: utilAddProCon.cornerShopGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueCornerShop(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget mainRoadDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Is Main Road Facing (optional)",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Yes"),
            value: "Yes",
            groupValue: utilAddProCon.mainRoadGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueMainRoad(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("No"),
            value: "No",
            groupValue: utilAddProCon.mainRoadGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueMainRoad(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget plotFloorDetails(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Plot Specification (optional)",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: CustomTextField3(
            controller: txtLandFloor,
            labelText: "Number of Floors Allowed for Construction",
            onTap: () => showBottomDialogue(6, context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: CustomTextField3(
            controller: txtLandSide,
            labelText: "No. of Open Sides",
            onTap: () => showBottomDialogue(5, context),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget roadAreaDetails(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Width of Road facing the Plot (optional)",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtRoadWidth,
                      decoration: InputDecoration(
                        labelText: "Road Width",
                        hintText: "Road Width",
                        labelStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontSize: 13.0,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          fontSize: 13.0,
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 10.0, bottom: 0.0),
                        floatingLabelStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: MyColors.green2,
                          fontSize: 17.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      showCursor: false,
                      scrollPhysics: const BouncingScrollPhysics(),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  SizedBox(
                    width: 100.0,
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Meter",
                        hintStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 13.0,
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 10.0, bottom: 0.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget boundaryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Text(
            "Boundary wall made",
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: "nunito",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("Yes"),
            value: "Yes",
            groupValue: utilAddProCon.boundaryGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueBoundaryWall(value!);
            },
          ),
        ),
        Obx(
          () => RadioListTile(
            controlAffinity: ListTileControlAffinity.trailing,
            title: const Text("No"),
            value: "No",
            groupValue: utilAddProCon.boundaryGv.value,
            onChanged: (value) {
              utilAddProCon.setSelectedValueBoundaryWall(value!);
            },
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget plotPropertyAreaDetails(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Property Area",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: txtPlotArea,
                      decoration: InputDecoration(
                        labelText: "Plot Area",
                        hintText: "Plot Area",
                        labelStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontSize: 13.0,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                          fontSize: 13.0,
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 10.0, bottom: 0.0),
                        floatingLabelStyle: TextStyle(
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: MyColors.green2,
                          fontSize: 17.0,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.none,
                      showCursor: false,
                      scrollPhysics: const BouncingScrollPhysics(),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  SizedBox(
                    width: 100.0,
                    child: CustomTextField3(
                      controller: txtPlotUnit,
                      onTap: () => showBottomDialogue(7, context),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: txtPlotLength,
                onTap: () {},
                decoration: InputDecoration(
                  labelText: "Plot Length in yrd(optional)",
                  hintText: "Plot Length in yrd(optional)",
                  labelStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 13.0,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    fontSize: 13.0,
                  ),
                  contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                  floatingLabelStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: MyColors.green2,
                    fontSize: 17.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.none,
                showCursor: false,
                scrollPhysics: const BouncingScrollPhysics(),
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(width: 50.0),
              TextField(
                controller: txtPlotBreadth,
                onTap: () {},
                decoration: InputDecoration(
                  labelText: "Plot Breadth in yrd(optional)",
                  hintText: "Plot Breadth in yrd(optional)",
                  labelStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 13.0,
                  ),
                  hintStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    fontSize: 13.0,
                  ),
                  contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                  floatingLabelStyle: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                    color: MyColors.green2,
                    fontSize: 17.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.none,
                showCursor: false,
                scrollPhysics: const BouncingScrollPhysics(),
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget propertyFloorDetails(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Floor Details",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField3(
                      controller: txtTotalFloor,
                      labelText: "Total Number of Floor",
                      onTap: () => showBottomDialogue(8, context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField3(
                      controller: txtFloorNoOfPro,
                      labelText: "Floor No. of your Property",
                      onTap: () => showBottomDialogue(9, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UtilityAddPropertyCon extends GetxController {
  RxInt bedRoomIndex = 0.obs;

  void setIndexBedRoom(int nexIndex) {
    bedRoomIndex.value = nexIndex;
  }

  RxInt bathRoomIndex = 0.obs;

  void setIndexBathRoom(int newIndex) {
    bathRoomIndex.value = newIndex;
  }

  RxInt balconyIndex = 0.obs;

  void setIndexBalcony(int newIndex) {
    balconyIndex.value = newIndex;
  }

  RxString gv = "".obs;

  void setSelectedValue(String value) {
    gv.value = value;
  }

  RxString cafeteriaGv = "".obs;

  void setSelectedValueCafeteria(String value) {
    cafeteriaGv.value = value;
  }

  RxString washroomGv = "".obs;

  void setSelectedValueWashroom(String value) {
    washroomGv.value = value;
  }

  RxString cornerShopGv = "".obs;

  void setSelectedValueCornerShop(String value) {
    cornerShopGv.value = value;
  }

  RxString mainRoadGv = "".obs;

  void setSelectedValueMainRoad(String value) {
    mainRoadGv.value = value;
  }

  RxString boundaryGv = "".obs;

  void setSelectedValueBoundaryWall(String value) {
    boundaryGv.value = value;
  }
}
