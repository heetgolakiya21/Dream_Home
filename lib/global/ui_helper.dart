import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MyColors {
  static Color green0 = const Color(0xFF033838);
  static Color green1 = const Color(0xFF004C4C);
  static Color green2 = const Color(0xFF006666);
  static Color green3 = const Color(0xFF008080);
  static Color green4 = const Color(0xFF66B2B2);
  static Color green5 = const Color(0xFFB2D8D8);
  static Color green6 = const Color(0xFFE3EDED);

  static Color red0 = Colors.red;

  static Color black0 = const Color(0xFF000000);

  static Color white0 = const Color(0xFFFFFFFF);
  static Color white1 = const Color(0xFFDFDFDF);
}

class MyThemes {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColors.white0,
    backgroundColor: MyColors.white0,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(MyColors.white0),
        animationDuration: const Duration(milliseconds: 1000),
        splashFactory: InkRipple.splashFactory,
      ),
    ),
    iconTheme: IconThemeData(
      color: MyColors.black0,
      weight: 50.0,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: 20.0,
        foregroundColor: MyColors.black0,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 0.8,
      indent: 5.0,
      endIndent: 5.0,
    ),
  );
  static ThemeData dark = ThemeData(brightness: Brightness.dark);
}

Future<void> easyLoading(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Container(
          height: 65.0,
          width: 65.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(17.0),
          child: CircularProgressIndicator(
            color: MyColors.green3,
            strokeWidth: 2.2,
          ),
        ),
      );
    },
  );
}

snackbar(String title, String message) {
  Get.snackbar(
    "",
    "",
    titleText: Text(
      title,
      style: TextStyle(
        fontFamily: "nunito",
        color: MyColors.red0,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        fontFamily: "nunito",
        color: MyColors.red0,
        fontSize: 13.0,
        // fontWeight: FontWeight.bold,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
    backgroundColor: Colors.grey.shade300,
  );
}

SnackBar snackBar(String text) {
  return SnackBar(
    content: Center(
      child: Text(
        text,
        style: TextStyle(
          color: MyColors.red0,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          fontFamily: "nunito",
        ),
      ),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    duration: const Duration(milliseconds: 1500),
    backgroundColor: MyColors.white0,
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
    margin: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
    elevation: 5.0,
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.horizontal,
  );
}

Future<void> photoDialogue(BuildContext context, GestureTapCallback cameraOnTap,GestureTapCallback galleryOnTap) async {
  return await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      return Container(
        height: 185.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Choose an action",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                  fontFamily: "nunito",
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: cameraOnTap,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            "assets/images/common_img/camera.png",
                            height: 60.0,
                            width: 60.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Camera",
                        style: TextStyle(
                          color: MyColors.black0,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          fontFamily: "nunito",
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: galleryOnTap,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          "assets/images/common_img/gallery.png",
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        color: MyColors.black0,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        fontFamily: "nunito",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> deleteDialog(BuildContext context, VoidCallback? onPressed) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: MyColors.white0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(
          "Delete property?",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: MyColors.black0,
            fontFamily: "nunito",
          ),
        ),
        content: const Text(
          "This property will be permanently deleted from your property list.",
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.black54,
            fontFamily: "nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: MyColors.green3,
                fontFamily: "nunito",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              "Delete",
              style: TextStyle(
                color: MyColors.green0,
                fontFamily: "nunito",
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showSettingsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: MyColors.white0,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        text: "Permission Required \n\n",
                        children: [
                          TextSpan(
                            text:
                                "This app requires storage permission to function properly. Please grant the permission in app settings.",
                            style: TextStyle(
                              color: MyColors.black0,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          color: MyColors.red0,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "nunito",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await openAppSettings();
                            Get.back();
                          },
                          child: Text(
                            "Open Settings",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                              color: MyColors.green3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<void> privacyPolicy(BuildContext context) async {
  await showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dream Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: "nunito",
                          color: MyColors.green2),
                    ),
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
                RichText(
                  text: TextSpan(
                    text:
                        "This privacy policy (\"Policy\") explains the policy regarding the collection, use, disclosure and transfer of your information by Dreme Home Realty Services Limited and / or its subsidiary (ies) and / or affiliate (s) (collectively referred to as the \"Company\"), which operates various websites, including sub-sites, platforms, applications, m-web platforms and other platforms (collectively referred to as \"Sites\") for delivery of Information, products, offerings and content via any mobile or Internet connected device or otherwise (collectively the \"Services\"). \n\nThis Policy forms part and parcel of the Terms of Use and other terms on the Site (\"Terms of Use\"). Capitalized terms which have been used here but are undefined shall have the same meaning as attributed to them in the Terms of Use. This policy is effective from the date and time a user registers with the Site and accepts the terms and conditions laid out in the Site. Please read this Privacy Policy and our Terms of Use carefully before using our Services.\n\nDreme Home respects the privacy of its users and is committed to protect it in all respects. With a view to offer most enriching and holistic internet experience to its users Dreme Home offers a vast repository of Online Sites and variety of community services. The information about the user as collected by Dreme Home is: (a) information supplied by users and (b) information automatically tracked while navigating (Information). \n\nBy using Dreme Home website or its services, you consent to collect, store, use, transfer, share and distribute the personal information you provide (including any changes thereto as provided by you) for any of the services that we offer. 1. Information Received, Collected And Stored by The Company A. Information Supplied By Users Registration / Contact data When you register or make contact on the Sites for the Service, we ask you to provide basic contact information such as your name, sex, age , address, pin code, contact number, occupation, interests and email address etc. When you register using your other accounts like  Gmail etc. We shall retrieve information from such account to continue to interact with you and to continue providing the Services.",
                    style: TextStyle(
                      color: MyColors.black0,
                      fontFamily: "nunito",
                    ),
                    children: [
                      TextSpan(
                          text: "\n\nINFORMATION USED BY THE APPLICATION",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.green3)),
                      const TextSpan(
                          text:
                              "\n\nThe information as supplied by the users enables us to improve the Services and provide you the most user - friendly experience . In some cases / provision of certain service ( s ) or utility ( ies ) , we may require your contact address as well . All required Information is service dependent and the Company may use the above said user Information to , maintain , protect , and improve the Services ( including advertising and personalisation on the Sites ) and for developing new services . We may also use your email address or other personally identifiable information to send commercial or marketing messages about our Services and / or such additional updates and features . about third parties products and services with an option to subscribe / unsubscribe ( where feasible ) . We may , however , use your email address for non - marketing or administrative purposes ( such as notifying you of major changes , for customer service purposes , billing , etc.) .\n\nAny personally identifiable information provided by you will not be considered as sensitive if it is freely available and / or accessible in the public domain like any comments , messages , blogs , scribbles available on social platforms like Facebook , twitter etc. \n\nAny posted / uploaded / conveyed / communicated by users on the public sections of the Sites becomes published content and is not considered personally identifiable information subject to this Policy . \n\nIn case you choose to decline to submit personally identifiable information on the Sites , we may not be able to provide certain services on the Sites to you . We will make reasonable efforts to notify you of the same at the time of opening your account . In any case , we will not be liable and or responsible for the denial of certain services to you for lack of you providing the necessary personal information . When you register with the Sites or Services , we contact you from time to time about updating of your personal information to provide the Users such features that we believe may benefit / interest you ."),
                      TextSpan(
                          text: "\n\nInformation Security",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.green3)),
                      const TextSpan(
                          text:
                              "\n\nWe take appropriate security measures to protect against unauthorized access to or unauthorized alteration , disclosure or destruction of data .These include internal reviews of our data collection , storage and processing practices and security measures , including appropriate encryption and physical security measures to guard against unauthorized access to systems where we store personal data .All information gathered on TIL is securely stored within the Company controlled database .The database is stored on servers secured behind a firewall ;access to the servers is password- protected and is strictly limited .However , as effective as our security measures are , no security system is impenetrable .We cannot guarantee the security of our database , nor can we guarantee that information you supply will not be intercepted while being .transmitted to us over the Internet .And , of course , any information .you include in a posting to the discussion areas is available to anyone .with Internet access .\n\nWe use third - party advertising companies to serve ads when you visit or use our Sites or Services .These companies may use information ( excluding your name , address , email address or telephone number or any personally identifiable information ) about your visits or use to particular website , mobile application or services , in order to provide advertisements about goods and services of interest to you.8. Updates / Changes The internet is an ever evolving medium .We may alter our Policy from time to time to incorporate necessary changes in technology , applicable law or any other variant .In any case , we reserve the right to change ( at any point of time ) the terms of this Policy or the Terms of Use .Any changes we make will be effective immediately on notice , which we may give by posting the new policy on the Sites .Your use of the Sites or Services after such notice will be deemed acceptance of such changes .We may also make reasonable efforts to inform you via electronic mail .In any case , you are advised to review this Policy periodically on the Sites to ensure that you are aware of the latest version.")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> aboutUs(BuildContext context) async {
  await showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: 1,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "About Us",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: "nunito",
                      color: MyColors.green2),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(MyColors.white1),
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
            RichText(
              text: TextSpan(
                text:
                    "\nAbout Us Launched in March '26 , Dream Home Realty Services Limited is one of the subsidiaries of Times Internet Limited.",
                style: TextStyle(
                  color: MyColors.black0,
                  fontFamily: "nunito",
                ),
                children: const [
                  TextSpan(
                      text:
                          "\n\nWith its revolutionary next - gen services customized specifically to address the real estate industry like Property Advice , New Projects , Rates & Trends , Real Estate News ( Property Pulse ) , Prop Index ( a tool that tracks the residential price movement ) , Buyers Guide etc , Dream Home has consolidated its position of being the No.1 property portal in India."),
                  TextSpan(
                      text:
                          "\n\nTo facilitate its users to buy / sell / rent properties even on the go , Dream Home has also come up with all new app & mobile site for users . They can now search properties & contact owners / agents even when on the move . With new app users can also post property , check the responses received on them and even contact the interested buyers / tenants instantly."),
                  TextSpan(
                      text:
                          "\n\nFor any further queries , feedback & alliances you can reach us at :",
                      style: TextStyle(color: Colors.teal)),
                  TextSpan(text: "\n\nEmail : support@dreamhome.com"),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showNetworkErrorDialog() {
  return Get.dialog(
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 1000),
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: MyColors.white0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200.0,
              child: Image.asset("assets/images/common_img/no_connection.png"),
            ),
            const SizedBox(height: 32.0),
            Text(
              "Whoops!",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: MyColors.black0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              "No internet connection found.",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.grey.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              "Check your connection and try again.",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontFamily: "nunito",
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.none) {
                  snackbar("No Internet Connection",
                      "Please turn on wifi or mobile data.");
                } else {
                  Get.back();
                }
              },
              style: ButtonStyle(
                shape: const MaterialStatePropertyAll(
                  ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(MyColors.white1),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
                ),
              ),
              child: Text(
                "Try Again",
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: "nunito",
                  fontWeight: FontWeight.bold,
                  color: MyColors.black0,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
