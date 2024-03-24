import 'package:dream_home/pages/admin/feedback_page.dart';
import 'package:dream_home/pages/admin/home_page.dart';
import 'package:dream_home/pages/admin/request_page.dart';
import 'package:dream_home/pages/main_pages/add_property/property_approve.dart';
import 'package:dream_home/pages/main_pages/add_property/property_commercial.dart';
import 'package:dream_home/pages/main_pages/add_property/property_image.dart';
import 'package:dream_home/pages/main_pages/add_property/property_location.dart';
import 'package:dream_home/pages/main_pages/add_property/property_post.dart';
import 'package:dream_home/pages/main_pages/add_property/property_price.dart';
import 'package:dream_home/pages/main_pages/add_property/property_rent.dart';
import 'package:dream_home/pages/main_pages/add_property/property_residential.dart';
import 'package:dream_home/pages/main_pages/add_property/property_status.dart';
import 'package:dream_home/pages/main_pages/add_property/property_type.dart';
import 'package:dream_home/pages/main_pages/feedback/feedback1.dart';
import 'package:dream_home/pages/main_pages/feedback/feedback2.dart';
import 'package:dream_home/pages/main_pages/search/display_search.dart';
import 'package:dream_home/pages/main_pages/see_all_page.dart';
import 'package:dream_home/pages/main_pages/show_property_page.dart';
import 'package:dream_home/pages/main_pages/my_property_page.dart';
import 'package:dream_home/pages/main_pages/home_page.dart';
import 'package:dream_home/pages/main_pages/profile_page.dart';
import 'package:dream_home/pages/main_pages/search/search_page.dart';
import 'package:dream_home/pages/main_pages/story/add_story_page.dart';
import 'package:get/get.dart';
import 'package:dream_home/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:dream_home/pages/intro_pages/splash_page.dart';
import 'package:dream_home/pages/login_pages/add_profile_page.dart';
import 'package:dream_home/pages/intro_pages/onboarding_page.dart';
import 'package:dream_home/pages/main_pages/bottom_navigation.dart';
import 'package:dream_home/pages/login_pages/login_form.dart';
import 'package:dream_home/pages/login_pages/login_option.dart';
import 'package:dream_home/pages/login_pages/login_otp.dart';

List<GetPage> appRoutes = [
  GetPage(name: "/", page: () => const MyApp()),
  GetPage(
    name: "/splash",
    page: () => const SplashPage(),
    transition: Transition.topLevel,
    curve: Curves.slowMiddle,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/onboarding",
    page: () => OnboardingPage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/login_option",
    page: () => const LoginOption(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/login_form",
    page: () => LoginForm(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/login_otp",
    page: () => const LoginOTP(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/add_profile",
    page: () => const AddProfile(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/bottom_navigation",
    page: () => const BottomNavigation(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/home",
    page: () => const HomePage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/search",
    page: () => const SearchProperty(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/my_property",
    page: () => const MyProperty(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/profile",
    page: () => const ProfilePage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_post",
    page: () => const PropertyPost(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_type",
    page: () => const PropertyType(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_location",
    page: () => const PropertyLocation(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_residential",
    page: () => const PropertyResidential(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_commercial",
    page: () => const PropertyCommercial(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_price",
    page: () => const PropertyPrice(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_rent",
    page: () => const PropertyRent(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_status",
    page: () => const PropertyStatus(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_image",
    page: () => const PropertyImage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/property_approve",
    page: () => const PropertyApprove(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/add_story",
    page: () => const AddStoryPage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/see_all",
    page: () => const SeeAllPage(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/show_property",
    page: () => const ShowProperty(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/display_search",
    page: () => const DisplaySearch(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/feedback_1",
    page: () => const Feedback1(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/feedback_2",
    page: () => const Feedback2(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/home_a",
    page: () => const HomePageA(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/feedback_a",
    page: () => const FeedbackA(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: "/request_a",
    page: () => const RequestA(),
    transition: Transition.rightToLeft,
    curve: Curves.linear,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];
