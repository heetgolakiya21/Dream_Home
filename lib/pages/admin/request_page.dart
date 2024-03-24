import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/elevated_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestA extends StatefulWidget {
  const RequestA({Key? key}) : super(key: key);

  @override
  State<RequestA> createState() => _RequestAState();
}

class _RequestAState extends State<RequestA> {
  TextEditingController textEditingController = TextEditingController();
  AuthController authCon = Get.find<AuthController>();

  var isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Request",
          style: TextStyle(
            fontFamily: "nunito",
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("property_status")
            .where("VerificationStatus", isEqualTo: "pending")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No data found.",
                style: TextStyle(
                  fontFamily: "nunito",
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, propertyIndex) {
                final propertyData =
                    documents[propertyIndex].data() as Map<String, dynamic>;

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .where("UID", isEqualTo: propertyData["UserID"])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData) {
                      return const Text(
                        "No data found.",
                        style: TextStyle(
                          fontFamily: "nunito",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      );
                    } else {
                      final List<DocumentSnapshot> userDocuments =
                          snapshot.data!.docs;
                      final List<Map<String, dynamic>> dataList = userDocuments
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();

                      return Column(
                        children: dataList.map((userData) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    "/show_property",
                                    arguments: {
                                      "userId": userData["UID"],
                                      "propertyId": propertyData["PropertyID"],
                                      "route": "request_page_a",
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 10.0),
                                  height: 290.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: MyColors.white0,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Owner :-\t",
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "${userData["ProfileName"]}\n",
                                                  style: const TextStyle(
                                                      color: Colors.black54))
                                            ],
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              color: MyColors.green2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: "Property Type :-\t",
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "${propertyData["Type"]}\n",
                                                  style: const TextStyle(
                                                      color: Colors.black54))
                                            ],
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              color: MyColors.green2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: "Property ID :-\t",
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "${propertyData["PropertyID"]}\n",
                                                  style: const TextStyle(
                                                      color: Colors.black54))
                                            ],
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              color: MyColors.green2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: "User ID :-\t",
                                            children: [
                                              TextSpan(
                                                  text: "${userData["UID"]}\n",
                                                  style: const TextStyle(
                                                      color: Colors.black54))
                                            ],
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              color: MyColors.green2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: Text(
                                            "Approve this property?",
                                            style: TextStyle(
                                              fontFamily: "nunito",
                                              color: MyColors.black0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  textEditingController
                                                      .clear();
                                                  Material(
                                                    child: await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          child: Wrap(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0),
                                                                      child:
                                                                          IconButton(
                                                                        onPressed: () =>
                                                                            Get.back(),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStatePropertyAll(MyColors.white1),
                                                                        ),
                                                                        icon:
                                                                            const Icon(
                                                                          Icons.close,
                                                                          size:
                                                                              20.0,
                                                                          weight:
                                                                              20.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8.0),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          TextField(
                                                                        maxLength:
                                                                            300,
                                                                        maxLines:
                                                                            5,
                                                                        controller:
                                                                            textEditingController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                          hintText:
                                                                              "Enter Denied Reason",
                                                                          hintStyle:
                                                                              TextStyle(
                                                                            fontFamily: "nunito",
                                                                            color: MyColors.black0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            CustomElevatedButton2(
                                                                          text:
                                                                              "Send",
                                                                          onPressed:
                                                                              () async {
                                                                            if (textEditingController.text.isEmpty) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter denied reason."));
                                                                            } else {
                                                                              String reason = textEditingController.text.trim();

                                                                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("property_status").where("PropertyID", isEqualTo: propertyData["PropertyID"]).get();

                                                                              querySnapshot.docs.forEach((doc) async {
                                                                                String documentId = doc.id;

                                                                                await FirebaseFirestore.instance.collection("property_status").doc(documentId).update({
                                                                                  "VerificationStatus": "denied",
                                                                                  "Reason": reason
                                                                                });
                                                                                Get.back();
                                                                                print("Document $documentId updated successfully!");
                                                                              });
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.cancel_outlined,
                                                  size: 35.0,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  QuerySnapshot
                                                      querySnapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "property_status")
                                                          .where("PropertyID",
                                                              isEqualTo:
                                                                  propertyData[
                                                                      "PropertyID"])
                                                          .get();

                                                  querySnapshot.docs
                                                      .forEach((doc) async {
                                                    String documentId =
                                                        doc.id;

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "property_status")
                                                        .doc(documentId)
                                                        .update({
                                                      "VerificationStatus":
                                                          "approved",
                                                    });
                                                    print(
                                                        "Document $documentId updated successfully!");
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.check_circle_outline,
                                                  size: 35.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30.0,
                                right: 14.0,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      "assets/images/common_img/label.png",
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 20.0,
                                top: 42.0,
                                child: Text(
                                  propertyData["Post"] == "Rent / Lease"
                                      ? "Rent"
                                      : "Sell",
                                  style: TextStyle(
                                    color: MyColors.white0,
                                    fontFamily: "nunito",
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
