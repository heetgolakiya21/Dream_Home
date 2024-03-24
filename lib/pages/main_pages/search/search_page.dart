import 'package:csc_picker/csc_picker.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_navigation.dart';

class SearchProperty extends StatefulWidget {
  const SearchProperty({super.key});

  @override
  State<SearchProperty> createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
  final BotCon botCon = Get.put(BotCon());
  final SearchProCon searchCon = Get.put(SearchProCon());

  final List<String> residentialName = [
    "Flat/Apartment",
    "House",
    "Villa",
    "Builder Floor",
    "Plot",
    "Studio Apartment",
    "Penthouse",
    "Farm House",
  ];

  final List<String> commercialName = [
    "Office Space",
    "Office in IT Park/SEZ",
    "Shop",
    "Showroom",
    "Commercial Land",
    "Warehouse/Godown",
    "Industrial Land",
    "Industrial Building",
    "Industrial Shed",
    "Agricultural Land",
  ];

  final List<String> budget = [
    "₹ 5 Lac",
    "₹ 10 Lac",
    "₹ 20 Lac",
    "₹ 30 Lac",
    "₹ 40 Lac",
    "₹ 50 Lac",
    "₹ 60 Lac",
    "₹ 70 Lac",
    "₹ 80 Lac",
    "₹ 90 Lac",
    "₹ 1 Cr",
    "₹ 2 Cr",
    "₹ 3 Cr",
    "₹ 4 Cr",
    "₹ 5 Cr",
    "₹ 10 Cr",
    "₹ 15+ Cr",
  ];

  String? countryValue;
  String? stateValue;
  String? cityValue;

  int convertBudgetToInt(String budgetString) {
    int value = 0;

    if (budgetString.contains("Lac")) {
      value = int.tryParse(budgetString.replaceAll(RegExp(r"[^0-9]"), "")) ?? 0;
      value *= 100000;
    } else if (budgetString.contains("Cr")) {
      value = int.tryParse(budgetString.replaceAll(RegExp(r"[^0-9]"), "")) ?? 0;
      value *= 10000000;
    }

    return value;
  }

  int min = 0;
  int max = 0;

  bool status = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAllNamed("/bottom_navigation", arguments: "search");

        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0, left: 10.0),
                          child: Text(
                            "Filter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: "nunito",
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (status) {
                              Get.offNamed(
                                "/display_search",
                                arguments: {
                                  "post": searchCon.post.value,
                                  "country": countryValue,
                                  "state": stateValue,
                                  "city": cityValue,
                                  "type": searchCon.type.value,
                                  "min": min,
                                  "max": max,
                                },
                              );
                            } else {
                              if (min > max) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar("Enter valid budget"));
                              }
                            }
                          },
                          style: ButtonStyle(
                            shape: const MaterialStatePropertyAll(
                              ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            backgroundColor:
                                MaterialStatePropertyAll(MyColors.green2),
                            padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 13.0),
                            ),
                          ),
                          child: Text(
                            "See Properties",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                              color: MyColors.white0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Property Buy/Rent",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => RadioListTile(
                              shape: ContinuousRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade300, width: 1.0),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(
                                "Buy",
                                style: TextStyle(
                                  fontFamily: "nunito",
                                  fontSize: 15.0,
                                  color: MyColors.black0,
                                ),
                              ),
                              value: "Sell",
                              groupValue: searchCon.post.value,
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              fillColor:
                                  MaterialStatePropertyAll(MyColors.green2),
                              dense: true,
                              onChanged: (value) {
                                searchCon.setBuyRentValue(value!);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Obx(
                            () => RadioListTile(
                              shape: ContinuousRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade300, width: 1.0),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(
                                "Rent",
                                style: TextStyle(
                                  fontFamily: "nunito",
                                  fontSize: 15.0,
                                  color: MyColors.black0,
                                ),
                              ),
                              value: "Rent / Lease",
                              groupValue: searchCon.post.value,
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              fillColor:
                                  MaterialStatePropertyAll(MyColors.green2),
                              dense: true,
                              onChanged: (value) {
                                searchCon.setBuyRentValue(value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Location",
                        children: [
                          TextSpan(
                            text: " (by city)",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "nunito",
                          fontWeight: FontWeight.bold,
                          color: MyColors.black0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 13.0, 5.0, 0.0),
                    child: CSCPicker(
                      defaultCountry: CscCountry.India,
                      flagState: CountryFlag.DISABLE,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: MyColors.white0,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.0),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade300,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.0),
                      ),
                      selectedItemStyle: TextStyle(
                        color: MyColors.black0,
                        fontSize: 14.0,
                        fontFamily: "nunito",
                      ),
                      dropdownHeadingStyle: TextStyle(
                        color: MyColors.black0,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "nunito",
                      ),
                      dropdownItemStyle: TextStyle(
                        color: MyColors.black0,
                        fontSize: 14.0,
                        fontFamily: "nunito",
                      ),
                      dropdownDialogRadius: 10.0,
                      searchBarRadius: 10.0,
                      layout: Layout.horizontal,
                      onCountryChanged: (value) {
                        countryValue = value;
                      },
                      onStateChanged: (value) {
                        stateValue = value;
                      },
                      onCityChanged: (value) {
                        cityValue = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Property Type",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "(Residential or Commercial)",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.grey.shade100,
                                expansionTileTheme:
                                    const ExpansionTileThemeData(
                                        childrenPadding: EdgeInsets.zero),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                collapsedIconColor: MyColors.green2,
                                iconColor: MyColors.green2,
                                title: const Text(
                                  "Residential",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "nunito",
                                  ),
                                ),
                                children: [
                                  SizedBox(
                                    height: 250.0,
                                    child: ListView.builder(
                                      itemCount: residentialName.length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0),
                                            title: Text(
                                              residentialName[index],
                                              style: const TextStyle(
                                                fontFamily: "nunito",
                                              ),
                                            ),
                                            value: residentialName[index],
                                            groupValue: searchCon.type.value,
                                            fillColor: MaterialStatePropertyAll(
                                                MyColors.green2),
                                            dense: true,
                                            onChanged: (value) async {
                                              searchCon.setTypeValue(value!);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.grey.shade100,
                                expansionTileTheme:
                                    const ExpansionTileThemeData(
                                        childrenPadding: EdgeInsets.zero),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                collapsedIconColor: MyColors.green2,
                                iconColor: MyColors.green2,
                                title: const Text(
                                  "Commercial",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "nunito",
                                  ),
                                ),
                                children: [
                                  SizedBox(
                                    height: 250.0,
                                    child: ListView.builder(
                                      itemCount: commercialName.length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0),
                                            title: Text(
                                              commercialName[index],
                                              style: const TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            value: commercialName[index],
                                            groupValue: searchCon.type.value,
                                            fillColor: MaterialStatePropertyAll(
                                                MyColors.green2),
                                            onChanged: (value) async {
                                              searchCon.setTypeValue(value!);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.all(5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Budget",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.grey.shade100,
                                expansionTileTheme:
                                    const ExpansionTileThemeData(
                                        childrenPadding: EdgeInsets.zero),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: const Text(
                                  "₹ Min",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "nunito",
                                  ),
                                ),
                                collapsedIconColor: MyColors.green2,
                                iconColor: MyColors.green2,
                                children: [
                                  SizedBox(
                                    height: 250.0,
                                    child: ListView.builder(
                                      itemCount: budget.length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0),
                                            title: Text(
                                              budget[index],
                                              style: const TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            value: budget[index],
                                            groupValue: searchCon.min.value,
                                            fillColor: MaterialStatePropertyAll(
                                                MyColors.green2),
                                            onChanged: (value) async {
                                              searchCon.setMinValue(value!);
                                              min = convertBudgetToInt(
                                                  searchCon.min.value);

                                              if (min <= max || max == 0) {
                                                status = true;
                                              } else {
                                                status = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar(
                                                        "You can't select min budget above ${searchCon.max.value}"));
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.0),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.grey.shade100,
                                expansionTileTheme:
                                    const ExpansionTileThemeData(
                                        childrenPadding: EdgeInsets.zero),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: const Text(
                                  "₹ Max",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "nunito",
                                  ),
                                ),
                                collapsedIconColor: MyColors.green2,
                                iconColor: MyColors.green2,
                                children: [
                                  SizedBox(
                                    height: 250.0,
                                    child: ListView.builder(
                                      itemCount: budget.length,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0),
                                            title: Text(
                                              budget[index],
                                              style: const TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            value: budget[index],
                                            groupValue: searchCon.max.value,
                                            fillColor: MaterialStatePropertyAll(
                                                MyColors.green2),
                                            onChanged: (value) async {
                                              searchCon.setMaxValue(value!);
                                              max = convertBudgetToInt(
                                                  searchCon.max.value);

                                              if (min <= max || min == 0) {
                                                status = true;
                                              } else {
                                                status = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  snackBar(
                                                      "Select max budget above ${searchCon.min.value}"),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchProCon extends GetxController {
  RxString post = "Sell".obs;

  void setBuyRentValue(String value) {
    post.value = value;
  }

  RxString type = "".obs;

  void setTypeValue(String newValue) {
    type.value = newValue;
  }

  RxString min = "min".obs;

  void setMinValue(String newValue) {
    min.value = newValue;
  }

  RxString max = "max".obs;

  void setMaxValue(String newValue) {
    max.value = newValue;
  }
}
