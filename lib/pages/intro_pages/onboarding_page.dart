import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:dream_home/model/onboarding.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final OnbCon onbCon = Get.put(OnbCon());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.white1,
                          foregroundColor: MyColors.black0,
                          fixedSize: const Size(110.0, 30.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () => onbCon.skipAction(),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontFamily: "nunito",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: onbCon.pageController,
                    itemCount: onbCon.onboardingData.length,
                    onPageChanged: onbCon.selectedPageIndex,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    onbCon.onboardingData[index].title
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 23.0,
                                      color: MyColors.green2,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "nunito",
                                      letterSpacing: 0.01,
                                    ),
                                  ),
                                  Text(
                                    onbCon.onboardingData[index].description
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "nunito",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.asset(
                                  onbCon.onboardingData[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          onbCon.onboardingData.length,
                          (int index) {
                            return Obx(
                              () => Container(
                                width: 7.0,
                                height: 7.0,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: onbCon.selectedPageIndex.value == index
                                      ? MyColors.white0
                                      : Colors.grey.withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.green3,
                        foregroundColor: MyColors.white0,
                        fixedSize: const Size(150.0, 50.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      onPressed: () => onbCon.forwardAction(),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 17.5,
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
      ),
    );
  }
}

class OnbCon extends GetxController {
  RxInt selectedPageIndex = 0.obs;

  final PageController pageController = PageController();

  List<Onboarding> onboardingData = [
    Onboarding(
      title: "Find your perfect home with us today",
      description: "Find amazing design and perfect price dream house.",
      imageUrl: "assets/images/onboarding_img/onb1.png",
    ),
    Onboarding(
      title: "Find best place\nto stay in good price",
      description:
          "Effortlessly sell your property with a single click for swift transactions and hassle-free deals.",
      imageUrl: "assets/images/onboarding_img/onb2.png",
    ),
    Onboarding(
      title: "Fast sell your property\nin just one click",
      description: "Discover optimal accommodations at affordable rates.",
      imageUrl: "assets/images/onboarding_img/onb3.png",
    ),
    Onboarding(
      title: "Find perfect choice for\nyour future house",
      description:
          "Discover your ideal future home effortlessly – matching your needs and desires with the perfect blend of location.",
      imageUrl: "assets/images/onboarding_img/onb4.png",
    ),
  ];

  bool get isLastPage => selectedPageIndex.value == onboardingData.length - 1;

  void skipAction() {
    pageController.animateToPage(
      onboardingData.length,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void forwardAction() {
    if (isLastPage) {
      Get.offNamed("/splash");
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    pageController.dispose();
    super.onClose();
  }
}
