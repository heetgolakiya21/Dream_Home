import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feedback1 extends StatefulWidget {
  const Feedback1({super.key});

  @override
  State<Feedback1> createState() => _Feedback1State();
}

class _Feedback1State extends State<Feedback1> {
  final AuthController authCon = Get.find<AuthController>();
  final FeedbackCon feedbackCon = Get.put(FeedbackCon());

  final TextEditingController txtMessage = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtMessage.dispose();
    super.dispose();
  }

  Widget customRadioButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        feedbackCon.setValue(index);

        if (index == 1 || index == 2 || index == 5) {
          Get.toNamed("/feedback_2", arguments: [text, index]);
        }
      },
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

  Future<void> sendData() async {
    FocusScope.of(context).unfocus();

    if (feedbackCon.index == 0.obs) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar("Select feedback type"));
    } else {
      Map<String, String> data;

      if (feedbackCon.index == 3.obs) {
        data = {
          "title1": "App Crash/Slow Speed",
          "title2": "",
          "ans": txtMessage.text,
          "UID": authCon.userid!,
        };
      } else if (feedbackCon.index == 4.obs) {
        data = {
          "title1": "Post Property/Login Issues",
          "title2": "",
          "ans": txtMessage.text,
          "UID": authCon.userid!,
        };
      } else {
        data = {
          "title1": "Others",
          "title2": "",
          "ans": txtMessage.text,
          "UID": authCon.userid!,
        };
      }
      easyLoading(context);

      FirebaseFirestore.instance.collection("feedback").add(data).then((value) {
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
                "Please share your Feedback",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  color: MyColors.black0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15.0),
              customRadioButton("Poor Listining Quality", 1),
              const SizedBox(height: 5.0),
              customRadioButton("Search Issues", 2),
              const SizedBox(height: 5.0),
              customRadioButton("App Crash/Slow Speed", 3),
              const SizedBox(height: 5.0),
              customRadioButton("Post Property/Login Issues", 4),
              const SizedBox(height: 5.0),
              customRadioButton("Notification Issues", 5),
              const SizedBox(height: 5.0),
              customRadioButton("Others", 6),
              Obx(
                () => Visibility(
                  child: (feedbackCon.index == 3.obs ||
                          feedbackCon.index == 4.obs ||
                          feedbackCon.index == 6.obs)
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

class FeedbackCon extends GetxController {
  RxInt index = 0.obs;

  void setValue(int newValue) {
    index.value = newValue;
  }
}
