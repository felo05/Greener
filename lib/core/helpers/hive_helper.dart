import 'package:hive_flutter/adapters.dart';

import '../../feature/authentication/model/user_model.dart';

class HiveHelper {
  static String boxKey = "BoxKey";
  static String onboardKey = "OnboardKey";
  static String userKey = "UserKey";
  static String idKey = "IdKey";
  static String notificationsBoxKey = "notificationsBoxKey";

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox(boxKey);
    await Hive.openBox(notificationsBoxKey);
  }

  static void addNotificationData(Map<String, dynamic> data) async {
    await Hive.box(notificationsBoxKey).put(data['id'], data);
  }

  static void removeNotificationData(int id) async {
    await Hive.box(notificationsBoxKey).delete(id);
  }

  static void clearNotificationData() async {
    await Hive.box(notificationsBoxKey).clear();
  }

  static List<Map<String, dynamic>> getNotificationData() {
    if (Hive.box(notificationsBoxKey).isNotEmpty) {
      return Hive.box(notificationsBoxKey)
          .toMap()
          .entries
          .map((entry) => {
                'id': entry.key,
                'data': entry.value,
              })
          .toList();
    }
    return [];
  }

  static bool isLoggedIn() {
    if (Hive.box(boxKey).containsKey(idKey) &&
        Hive.box(boxKey).get(idKey).length > 3) {
      return true;
    }
    return false;
  }

  static void inFirstTime() async {
    await Hive.box(boxKey).put(onboardKey, true);
  }

  static bool isFirstTime() {
    if (!Hive.box(boxKey).containsKey(onboardKey)) {
      return true;
    }
    return false;
  }

  static void setId(String id) async {
    await Hive.box(boxKey).put(idKey, id);
  }

  static String? getId() {
    if (Hive.box(boxKey).containsKey(idKey)) {
      return Hive.box(boxKey).get(idKey);
    }
    return null;
  }

  static void removeId() async {
    await Hive.box(boxKey).delete(idKey);
  }

  static void setUser(UserModel user) async {
    await Hive.box(boxKey).put(userKey, user);
  }

  static UserModel? getUser() {
    if (Hive.box(boxKey).containsKey(userKey)) {
      return Hive.box(boxKey).get(userKey);
    }
    return null;
  }

  static void removeUser() async {
    await Hive.box(boxKey).delete(userKey);
  }
}
