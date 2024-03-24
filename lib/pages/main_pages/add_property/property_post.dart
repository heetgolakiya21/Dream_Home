import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyPost extends StatefulWidget {
  const PropertyPost({super.key});

  @override
  State<PropertyPost> createState() => _PropertyPostingState();
}

class _PropertyPostingState extends State<PropertyPost> {
  final PropertyPostController postCon = Get.put(PropertyPostController());
  final AuthController authCon = Get.find<AuthController>();

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
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 22.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Hi ",
                        children: [
                          TextSpan(
                            text: "${authCon.txtName.text},\n",
                            style: TextStyle(color: MyColors.green3),
                          ),
                          const TextSpan(
                              text: "You are posting your property for:"),
                        ],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: const Text(
                  "Property Posting Type",
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
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  title: const Text(
                    "Sell",
                    style: TextStyle(fontFamily: "nunito"),
                  ),
                  value: "Sell",
                  groupValue: postCon.gv.value,
                  onChanged: (value) async {
                    postCon.setSelectedValue(value!);
                    await Future.delayed(const Duration(milliseconds: 150));
                    Get.toNamed("/property_type", arguments: value);
                  },
                ),
              ),
              Obx(
                () => RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  title: const Text(
                    "Rent / Lease",
                    style: TextStyle(fontFamily: "nunito"),
                  ),
                  value: "Rent / Lease",
                  groupValue: postCon.gv.value,
                  onChanged: (value) async {
                    postCon.setSelectedValue(value!);
                    await Future.delayed(const Duration(milliseconds: 150));

                    Get.toNamed("/property_type", arguments: value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyPostController extends GetxController {
  RxString gv = "".obs;

  void setSelectedValue(String value) {
    gv.value = value;
  }
}
