import 'package:csc_picker/csc_picker.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class PropertyLocation extends StatefulWidget {
  const PropertyLocation({super.key});

  @override
  State<PropertyLocation> createState() => _PropertyLocationState();
}

class _PropertyLocationState extends State<PropertyLocation> {
  final TextEditingController txtAddress = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtAddress.dispose();
    super.dispose();
  }

  String? countryValue;
  String? stateValue;
  String? cityValue;

  int? passIndex;
  Property? typo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    passIndex = Get.arguments["passIndex"];
    typo = Get.arguments["post/type"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () => Get.back(),
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
                padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 22.0),
                child: Row(
                  children: [
                    Text(
                      "Where is your property \nlocated?",
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
                      children: [
                        CSCPicker(
                          defaultCountry: CscCountry.India,
                          showStates: true,
                          // disableCountry: true,
                          showCities: true,
                          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                          dropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            color: MyColors.white0,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.0),
                          ),
                          disabledDropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.grey.shade300,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1.0),
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
                          layout: Layout.vertical,
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

                        const SizedBox(height: 20.0),
                        CustomTextField2(
                          controller: txtAddress,
                          hintText: "Address",
                          labelText: "Enter Address",
                          helperText:
                              "Ex.\tD-06, royal heaven near yogi chowk, punagam",
                          keyboardType: TextInputType.streetAddress,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomElevatedButton2(
                      onPressed: () {
                        if (countryValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter Country"));
                        } else if (stateValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter State"));
                        } else if (cityValue == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar("Enter City"));
                        } else if (txtAddress.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar("Enter Address"));
                        } else {
                          FocusScope.of(context).unfocus();

                          Property location = Property(
                            country: countryValue,
                            state: stateValue,
                            city: cityValue,
                            address: txtAddress.text.trim(),
                            fullAddress: "${txtAddress.text}/ $cityValue/ $stateValue/ $countryValue",
                          );

                          if (passIndex == 1) {
                            Get.toNamed(
                              "/property_residential",
                              arguments: {
                                "mainType": "Residential",
                                "post/type": typo,
                                "location": location,
                              },
                            );
                          } else {
                            Get.toNamed(
                              "/property_commercial",
                              arguments: {
                                "mainType": "Commercial",
                                "post/type": typo,
                                "location": location,
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
    );
  }
}
