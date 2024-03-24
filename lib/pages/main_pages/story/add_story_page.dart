import 'dart:io';
import 'package:dream_home/global/auth_details.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dream_home/model/story.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/text_field2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<AddStoryPage> {
  final TextEditingController txtCaption = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtCaption.dispose();
    super.dispose();
  }

  String? imgPath;
  Story? str;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    imgPath = Get.arguments["imagePath"];
    str = Get.arguments["storyData"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0),
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
              const SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Image.file(File(imgPath!)),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              CustomTextField2(
                controller: txtCaption,
                maxLines: 2,
                labelText: "Caption",
                hintText: "Caption",
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton2(
                      text: "CANCEL",
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: CustomElevatedButton2(
                      text: "POST",
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        String storyImgName = DateTime.now().millisecondsSinceEpoch.toString();

                        try {
                          easyLoading(context);

                          Reference upload = FirebaseStorage.instance
                              .ref()
                              .child("story_images")
                              .child(storyImgName);

                          await upload.putFile(File(imgPath!));

                          String imageURL = await upload.getDownloadURL();

                          List<String> caption = str!.caption;
                          List<String> storyImage = str!.storyImage;

                          caption.add(txtCaption.text.isEmpty ? " " : txtCaption.text);
                          storyImage.add(imageURL);

                          final AuthController authCon = Get.find<AuthController>();

                          Story sto = Story(
                            uid: authCon.userid!,
                            caption: caption,
                            storyImage: storyImage,
                            profileImage: authCon.profileImage,
                            profileName: authCon.txtName.text,
                          );

                          FirebaseFirestore.instance
                              .collection("story")
                              .doc(authCon.userid)
                              .set(sto.toJson())
                              .then(
                            (value) {
                              if (kDebugMode) {
                                print("STORY ADDED .....");
                              }

                              ScaffoldMessenger.of(context).showSnackBar(snackBar("Story Added"));
                              Get.back();
                              Get.back();
                            },
                          ).catchError((error) {
                            Get.back();

                            if (kDebugMode) {
                              print("Failed to add story ..... $error");
                            }
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar("Something went wrong try again!"));
                          Get.back();

                          if (kDebugMode) {
                            print("Error ..... $e");
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
