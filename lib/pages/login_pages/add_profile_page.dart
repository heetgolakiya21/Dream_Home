import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/model/user.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:dream_home/widget/text_field1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final AuthController authCon = Get.find<AuthController>();

  Future<void> setInfoStatus(String status) async {
    await Utils.userPref!.setString("profile_info_status", status);
  }

  bool readOnly = false;
  bool isEnabled = true;
  bool isVisible = false;

  void ref() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authCon.getUID();
    authCon.allUpdate(ref);

    if (Get.arguments == "view") {
      isVisible = true;
    }

    authCon.loginEmail = Utils.userPref!.getString("login_email");
    authCon.loginPhone = Utils.userPref!.getString("login_phone");

    if (authCon.loginEmail != null) {
      authCon.txtEmail = TextEditingController(text: authCon.loginEmail);
      readOnly = true;
    }

    if (authCon.loginPhone != null) {
      authCon.txtPhoneNo.text = authCon.loginPhone!;
      isEnabled = false;
    }
  }

  void saveProfile() {
    if (authCon.txtName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter Username"));
    } else if (authCon.txtPhoneNo.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter Phone No."));
    } else if (authCon.txtEmail.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter Email"));
    } else if (authCon.txtAddress.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar("Enter Address"));
    } else {
      FocusScope.of(context).unfocus();

      authCon.uploadImage(context).then(
            (value) => authCon
                .addUserDetails(
                    UserModel(
                      userid: authCon.userid!,
                      profileImage: authCon.profileImage,
                      profileName: authCon.txtName.text.trim(),
                      phoneNo:
                          authCon.loginPhone ?? authCon.txtPhoneNo.text.trim(),
                      email: authCon.loginEmail ?? authCon.txtEmail.text.trim(),
                      address: authCon.txtAddress.text.trim(),
                      dialCode: authCon.loginCountryCode,
                      isoCode: authCon.loginIsoCode,
                    ),
                    context)
                .then(
              (value) {
                setInfoStatus("Profile filled up");

                //  for admin
                if (authCon.loginEmail == Utils.adminEmail ||authCon.loginPhone == Utils.adminPhone) {
                  Get.offAllNamed("/home_a");
                } else {
                  Get.offAllNamed("/bottom_navigation");
                }
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                child: Row(
                  children: [
                    Visibility(
                      visible: isVisible,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: MyColors.white1,
                        ),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text(
                  "Profile Info.",
                  style: TextStyle(
                    color: MyColors.black0,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "nunito",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Stack(
                  textDirection: TextDirection.rtl,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: authCon.profileImage == ""
                          ? Container(
                              color: MyColors.white0,
                              child: Image.asset(
                                "assets/images/common_img/profile1.png",
                                fit: BoxFit.cover,
                                width: size.width * 0.5,
                                height: size.width * 0.5,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: authCon.profileImage,
                              fit: BoxFit.cover,
                              height: size.width * 0.5,
                              width: size.width * 0.5,
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outlined,
                                color: MyColors.red0,
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: MyColors.green3,
                                  backgroundColor: MyColors.white1,
                                );
                              },
                            ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () async {
                          await photoDialogue(
                            context,
                            () {
                              authCon.pickImage(ImageSource.camera, context);
                              Get.back();
                            },
                            () {
                              authCon.pickImage(ImageSource.gallery, context);
                              Get.back();
                            },
                          );
                        },
                        child: Container(
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            color: MyColors.green5,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                child: CustomTextField1(
                  controller: authCon.txtName,
                  icon: Icons.person_outlined,
                  hintText: "Username",
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.black0,
                      width: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Stack(
                    children: [
                      InternationalPhoneNumberInput(
                        textFieldController: authCon.txtPhoneNo,
                        initialValue: authCon.number,
                        onInputChanged: (value) {
                          authCon.loginCountryCode = value.dialCode.toString();
                          authCon.loginIsoCode = value.isoCode.toString();
                          authCon.number = PhoneNumber(
                            isoCode: value.isoCode.toString(),
                            dialCode: value.dialCode.toString(),
                            phoneNumber: authCon.txtPhoneNo.text.trim(),
                          );
                        },
                        isEnabled: isEnabled,
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          useBottomSheetSafeArea: true,
                        ),
                        inputDecoration: const InputDecoration(
                          hintText: "Enter Mobile Number",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: "nunito",
                          ),
                          border: InputBorder.none,
                        ),
                        textStyle: TextStyle(
                          color: MyColors.black0,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: "nunito",
                        ),
                        selectorTextStyle: TextStyle(
                          color: MyColors.black0,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: "nunito",
                        ),
                        searchBoxDecoration: InputDecoration(
                          hintText: "Search Your Country",
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: "nunito",
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.green0)),
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        cursorColor: MyColors.black0,
                        keyboardAction: TextInputAction.done,
                      ),
                      Positioned(
                        left: 100.0,
                        top: 8.0,
                        bottom: 8.0,
                        child: Container(
                          height: 30.0,
                          width: 1.0,
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.7)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextField1(
                  controller: authCon.txtEmail,
                  icon: Icons.email_outlined,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  readOnly: readOnly,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: CustomTextField1(
                  controller: authCon.txtAddress,
                  icon: Icons.home_outlined,
                  hintText: "Address",
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) => saveProfile(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  children: [
                    Text(
                      "Ex.\tSurat, Gujarat, India",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontFamily: "nunito",
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: ElevatedButton(
                  onPressed: () => saveProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.green0,
                    foregroundColor: MyColors.white0,
                    minimumSize: const Size(double.infinity, 50.0),
                    fixedSize: const Size(double.infinity, 50.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    textStyle: const TextStyle(
                      fontFamily: "nunito",
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  child:
                      isVisible ? const Text("Update") : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
