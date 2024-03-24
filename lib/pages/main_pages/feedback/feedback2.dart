import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feedback2 extends StatefulWidget {
  const Feedback2({super.key});

  @override
  State<Feedback2> createState() => _State();
}

class _State extends State<Feedback2> {
  final AuthController authCon = Get.find<AuthController>();
  final FeedbackCon1 feedbackCon = Get.put(FeedbackCon1());
  final TextEditingController txtMessage = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtMessage.dispose();
    super.dispose();
  }

  List<String> listing = [
    "Didn't Find Matching Property Options",
    "Incorrect Information posted by Advertisers",
    "Property already sold/rented out",
  ];

  List<String> search = [
    "Irrelevant Search Results",
    "Location Mismatch",
    "Other",
  ];

  List<String> notification = [
    "Too Many Notifications",
    "Irrelevant Notifications",
    "Other",
  ];

  Widget customRadioButton(String text, int index) {
    return GestureDetector(
      onTap: () => feedbackCon.setValue(index),
      child: Obx(
        () => Container(
          height: 45.0,
          decoration: BoxDecoration(
            color: (feedbackCon.index == index.obs)
                ? MyColors.green6
                : MyColors.white0,
            border: Border.all(
              color: (feedbackCon.index == index.obs)
                  ? Colors.grey.shade50
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "nunito",
            ),
          ),
        ),
      ),
    );
  }

  String? text;
  int? idx;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    text = Get.arguments[0];
    idx = Get.arguments[1];
  }

  Future<void> sendData() async {
    FocusScope.of(context).unfocus();

    if (feedbackCon.index == 7.obs) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar("Select feedback type"));
    } else {
      Map<String, String> data = {
        "title1": text!,
        "ans": txtMessage.text,
        "UID": authCon.userid!,
      };

      if (idx == 1) {
        data["title2"] = listing[feedbackCon.index.value];
      }

      if (idx == 2) {
        data["title2"] = search[feedbackCon.index.value];
      }

      if (idx == 5) {
        data["title2"] = notification[feedbackCon.index.value];
      }

      easyLoading(context);

      FirebaseFirestore.instance.collection("feedback").add(data).then((value) {
        Get.back();
        Get.back();
        Get.back();

        ScaffoldMessenger.of(context).showSnackBar(snackBar("Feedback Send"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        titleTextStyle: TextStyle(
          color: MyColors.white0,
          fontFamily: "nunito",
          fontSize: 20.0,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.white0,
            size: 20.0,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: MyColors.green2,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text!,
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  color: MyColors.black0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0),
              ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return idx == 1
                      ? customRadioButton(listing[index], index)
                      : (idx == 2)
                          ? customRadioButton(search[index], index)
                          : customRadioButton(notification[index], index);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5.0);
                },
              ),
              Obx(
                () => Visibility(
                  child: (feedbackCon.index != 7.obs)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15.0),
                            const Text(
                              "Please tell us the issue in detail (Optional)",
                              style: TextStyle(
                                fontFamily: "nunito",
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextField(
                              controller: txtMessage,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: MyColors.green0)),
                                hintText: "Message",
                                hintStyle: const TextStyle(
                                  fontFamily: "nunito",
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: "nunito",
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: MyColors.black0,
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (value) => sendData(),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () => sendData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.green2,
                  foregroundColor: MyColors.white0,
                  minimumSize: const Size(double.infinity, 50.0),
                  fixedSize: const Size(double.infinity, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                child: const Text(
                  "SEND FEEDBACK",
                  style: TextStyle(
                    fontFamily: "nunito",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackCon1 extends GetxController {
  RxInt index = 7.obs;

  void setValue(int newValue) {
    index.value = newValue;
  }
}
