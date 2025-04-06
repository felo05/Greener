import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:greener/core/constants/kcolors.dart';
import 'package:greener/feature/favorite/repository/favorite_repository_implementation.dart';
import 'package:greener/feature/my_garden/repository/my_garden_repository_implementation.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import '../../core/helpers/dio_helper.dart';
import '../../core/helpers/notification_helper.dart';
import '../favorite/favorite_screen.dart';
import '../my_garden/my_garden_screen.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
@override
  void initState() {
    FavoriteRepositoryImplementation.getFavoriteIds();
    MyGardenRepositoryImplementation.getMyGardenIds();
    NotificationHelper.initialize();
    NotificationHelper.requestPermissions();
    if(NotificationHelper.notificationData.isNotEmpty)
    {
      NotificationHelper.startDailyNotifications();
    }
    Gemini.init(apiKey: "AIzaSyAq02AImye-_nJugyy2yjLqVG9YldstLaE");

    DioHelpers.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final List<Widget> screens = [
      const HomeScreen(),
       const FavoriteScreen(),
       const MyGardenScreen(),
       const ProfileScreen()
    ];
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [screens[selectedIndex]],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.favorite,
            title: 'Favorite',
          ),
          BarItem(
            icon: Icons.grass,
            title: 'My Garden',
          ),
          BarItem(
            icon: Icons.person,
            title: 'Profile',
          ),
        ],
        selectedIndex: selectedIndex,
        onButtonPressed: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        activeColor: baseColor,
        backgroundColor: whitenColor,
      ),
    );
  }
}
