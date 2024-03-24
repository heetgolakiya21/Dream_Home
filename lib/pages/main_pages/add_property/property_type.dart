import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/model/property.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyType extends StatefulWidget {
  const PropertyType({super.key});

  @override
  State<PropertyType> createState() => _PropertyTypeState();
}

class _PropertyTypeState extends State<PropertyType> {
  final PropertyTypeController typeCon = Get.put(PropertyTypeController());

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

  int passIndex = 1;

  Widget customRadioButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        typeCon.setValue(index);
        passIndex = index;
      },
      child: Obx(
        () => Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: (typeCon.value == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (typeCon.value == index.obs)
                  ? MyColors.green3
                  : Colors.grey.shade600,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: (typeCon.value == index.obs)
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

  String? post;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    post = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 15.0),
                child: Row(
                  children: [
                    Text(
                      "What type of property is it?",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: "nunito",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: customRadioButton("Residential", 1)),
                    const SizedBox(width: 20.0),
                    Expanded(child: customRadioButton("Commercial", 2)),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Property Type",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await infoDialogue();
                      },
                      child: Icon(
                        Icons.info_outlined,
                        size: 17.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: typeCon.isResidential.value
                        ? residentialName.length
                        : commercialName.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          contentPadding: const EdgeInsets.only(left: 10.0),
                          title: Text(
                            typeCon.isResidential.value
                                ? residentialName[index]
                                : commercialName[index],
                            style: const TextStyle(fontFamily: "nunito"),
                          ),
                          value: typeCon.isResidential.value
                              ? residentialName[index]
                              : commercialName[index],
                          groupValue: typeCon.gv.value,
                          onChanged: (value) async {
                            typeCon.setSelectedValue(value!);
                            await Future.delayed(const Duration(milliseconds: 150));

                            Property postType = Property(
                              post: post,
                              type: value,
                            );

                            Get.toNamed(
                              "/property_location",
                              arguments: {
                                "passIndex": passIndex,
                                "post/type": postType,
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> infoDialogue() async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(23.0, 20.0, 23.0, 5.0),
          color: MyColors.white0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(MyColors.white1),
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 20.0,
                      weight: 20.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Multistorey Apartment\n",
                          children: [
                            TextSpan(
                              text:
                                  "A number of flats that are built together.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "House\n",
                          children: [
                            TextSpan(
                              text:
                                  "Residence that consists of a ground floor and one or more upper storeys.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Villa\n",
                          children: [
                            TextSpan(
                              text:
                                  "A large and luxurious country house in its own grounds.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Builder Floor\n",
                          children: [
                            TextSpan(
                              text:
                                  "Individual floors constructed on a unit of land / residential plot.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Plot\n",
                          children: [
                            TextSpan(
                              text: "A measured piece or parcel of land.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Studio Apartment\n",
                          children: [
                            TextSpan(
                              text: "A flat containing one main room.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RichText(
                        softWrap: true,
                        text: TextSpan(
                          text: "Penthouse\n",
                          children: [
                            TextSpan(
                              text:
                                  "A flat on the top floor of a tall building, typically one that is luxuriously fitted.\n",
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 15.5,
                            color: MyColors.black0,
                            fontFamily: "nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PropertyTypeController extends GetxController {
  RxInt value = 1.obs;
  RxBool isResidential = true.obs;
  RxString gv = "".obs;

  void setValue(int newValue) {
    value.value = newValue;
    isResidential.value = newValue == 1;
  }

  void setSelectedValue(String newValue) {
    gv.value = newValue;
  }
}
