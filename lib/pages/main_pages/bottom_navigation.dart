import 'package:dream_home/pages/main_pages/my_property_page.dart';
import 'package:dream_home/pages/main_pages/home_page.dart';
import 'package:dream_home/pages/main_pages/profile_page.dart';
import 'package:dream_home/pages/main_pages/search/search_page.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BotCon bottomNav = Get.put(BotCon());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Get.arguments == "display_search") {
      bottomNav.currentIndex = 1.obs;
    }

    if (Get.arguments == "my_property" || Get.arguments == "profile" || Get.arguments == "search") {
      bottomNav.currentIndex = 0.obs;
    }

    if (Get.arguments == "property_image") {
      bottomNav.currentIndex = 2.obs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(
        () => SizedBox(
          width: size.width,
          height: size.height,
          child: bottomNav.page.elementAt(bottomNav.currentIndex.value),
        ),
      ),
      bottomNavigationBar: Obx(
        () => AnimatedContainer(
          width: size.width,
          height: bottomNav.isVisible.value ? 67.0 : 0.0,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 700),
          child: Stack(
            children: [
              CustomPaint(
                  size: Size(size.width, 67.0), painter: BNBCustomPainter()),
              Center(
                heightFactor: 0.6,
                child: FloatingActionButton(
                  backgroundColor: MyColors.green1,
                  elevation: 0.1,
                  onPressed: () => Get.toNamed("/property_post"),
                  child: Icon(Icons.add, color: MyColors.white0),
                ),
              ),
              SizedBox(
                width: size.width,
                height: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: bottomNav.currentIndex.value == 0
                            ? MyColors.green1
                            : Colors.grey.shade400,
                        size: 23.5,
                      ),
                      onPressed: () => bottomNav.currentIndex.value = 0,
                      splashColor: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: bottomNav.currentIndex.value == 1
                            ? MyColors.green1
                            : Colors.grey.shade400,
                        size: 23.5,
                      ),
                      onPressed: () => bottomNav.currentIndex.value = 1,
                      splashColor: Colors.white,
                    ),
                    SizedBox(width: size.width * 0.20),
                    IconButton(
                      icon: Icon(
                        Icons.real_estate_agent,
                        color: bottomNav.currentIndex.value == 2
                            ? MyColors.green1
                            : Colors.grey.shade400,
                        size: 23.5,
                      ),
                      onPressed: () => bottomNav.currentIndex.value = 2,
                      splashColor: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: bottomNav.currentIndex.value == 3
                            ? MyColors.green1
                            : Colors.grey.shade400,
                        size: 23.5,
                      ),
                      onPressed: () => bottomNav.currentIndex.value = 3,
                      splashColor: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BotCon extends GetxController {
  RxInt currentIndex = 0.obs;

  RxList page = [
    const HomePage(),
    const SearchProperty(),
    const MyProperty(),
    const ProfilePage(),
  ].obs;

//   SCROLL ----------------------------------

  RxBool isVisible = true.obs;

  final ScrollController scrollController = ScrollController();

  void onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isVisible.value = true;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isVisible.value = false;
    }
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20.0); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
