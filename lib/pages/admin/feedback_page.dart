import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackA extends StatefulWidget {
  const FeedbackA({Key? key}) : super(key: key);

  @override
  State<FeedbackA> createState() => _FeedbackAState();
}

class _FeedbackAState extends State<FeedbackA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
          style: TextStyle(
            fontFamily: "nunito",
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("feedback").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> userDocuments =
                    snapshot.data!.docs;
                final List<Map<String, dynamic>> dataList = userDocuments
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return SingleChildScrollView(
                  child: Column(
                    children: dataList.map((data) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .where("UID", isEqualTo: data["UID"])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              final List<DocumentSnapshot> userDocuments =
                                  snapshot.data!.docs;
                              final List<Map<String, dynamic>> userDataList =
                                  userDocuments
                                      .map((doc) =>
                                          doc.data() as Map<String, dynamic>)
                                      .toList();

                              return Column(
                                children: userDataList.map((userData) {
                                  return CustomElevatedButton(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Wrap(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    color: MyColors.white0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Feedback",
                                                            style: TextStyle(
                                                              fontFamily: "nunito",
                                                              fontWeight: FontWeight.bold,
                                                              color: MyColors.green0,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () =>
                                                                Get.back(),
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      MyColors
                                                                          .white0),
                                                            ),
                                                            icon: const Icon(
                                                              Icons.close,
                                                              size: 20.0,
                                                              weight: 20.0,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "User ID :-\n",
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "${data["UID"]}\n",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black54))
                                                          ],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "nunito",
                                                            color:
                                                                MyColors.green2,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "Main Issue :-\n",
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "${data["title1"]}\n",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black54))
                                                          ],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "nunito",
                                                            color:
                                                                MyColors.green2,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      data["title2"] != ""
                                                          ? RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    "Sub Issue :-\n",
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "${data["title2"]}\n",
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.black54))
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "nunito",
                                                                  color: MyColors
                                                                      .green2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      data["ans"] != ""
                                                          ? RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    "Description :-\n",
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          "${data["ans"]}\n",
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.black54))
                                                                ],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "nunito",
                                                                  color: MyColors
                                                                      .green2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icons.arrow_forward_ios,
                                    text: "${userData["ProfileName"]}",
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Center(child: Text("No data found"));
                            }
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
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
                          }
                        },
                      );
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text("No data found"));
              }
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
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
            }
          },
        ),
      ),
    );
  }
}
