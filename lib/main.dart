import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greener/core/helpers/hive_helper.dart';
import 'package:greener/feature/authentication/login/login_screen.dart';
import 'package:greener/feature/home/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/firebase_options.dart';
import 'feature/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.initialize();

  await Supabase.initialize(
    url: 'https://vbagahybewywqhjhdbro.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZiYWdhaHliZXd5d3FoamhkYnJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM4NjY5MzIsImV4cCI6MjA1OTQ0MjkzMn0.3RohNY0nYkkwQZ8F8iNlHjMUTabfYtRrrlTTl0NZG-0',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HiveHelper.isFirstTime()
            ? const OnboardingScreen()
            : HiveHelper.isLoggedIn()
                ? const MainScreen()
                : const LoginScreen(),
      ),
    );
  }
}
