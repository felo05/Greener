import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/core/helpers/notification_helper.dart';
import 'package:greener/feature/home/model/plant_model.dart';

import '../../../core/helpers/hive_helper.dart';
import 'my_garden_repository.dart';

class MyGardenRepositoryImplementation implements MyGardenRepository {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static Set<dynamic> myGardenIds = {};

  void _addPlantInFirebase(PlantData plant) {
    _fireStore
        .collection('plant')
        .doc(plant.id!.toString())
        .set(plant.toJson());
  }

  Future<bool> _checkPlantInFirebase(PlantData plant) async {
    return (await _fireStore
            .collection('plant')
            .doc(plant.id!.toString())
            .get())
        .exists;
  }

  @override
  void addPlant(PlantData plant) async {
    myGardenIds.add(plant.id!);
    final response = await Gemini.instance.prompt(parts: [
      Part.text(
          "For ${plant.commonName}, provide the average sunlight duration in hours and the average watering period as a JSON object in the following format: {sunlight_duration: number, average_watering_period: {value: number, unit: times per [day/week]}}. Return only the JSON object without any additional text or formatting.")
    ]);
    Map<String, dynamic> data =
    jsonDecode(response!.output!.substring(7, response.output!.length - 4));
    if (!(await _checkPlantInFirebase(plant))) {
      plant.notification= data;
      _addPlantInFirebase(plant);
    }
    _fireStore.collection('users').doc(HiveHelper.getId()).update({
      "garden": FieldValue.arrayUnion([plant.id!])
    });
    data["id"] = plant.id;
    data["common_name"] = plant.commonName;
    HiveHelper.addNotificationData(data);
    NotificationHelper.notificationData.add(data);
    NotificationHelper.startDailyNotifications();
  }

  @override
  void removePlant(PlantData plant) {
    myGardenIds.remove(plant.id!);
    if (myGardenIds.isEmpty) {
      NotificationHelper.cancelDailyNotifications();
    }
    _fireStore.collection('users').doc(HiveHelper.getId()).update({
      "garden": FieldValue.arrayRemove([plant.id!])
    });
    HiveHelper.removeNotificationData(plant.id!);
    if (NotificationHelper.notificationData.isEmpty) {
      NotificationHelper.cancelDailyNotifications();
    } else {
      NotificationHelper.notificationData
          .removeWhere((data) => data['id'] == plant.id);
      NotificationHelper.startDailyNotifications();
    }
  }

  static void getMyGardenIds() async {
    myGardenIds = ((await _fireStore
            .collection('users')
            .doc(HiveHelper.getId())
            .get())["garden"])
        .toSet();
  }

  @override
  Future<Either<List<PlantData>, Failure>> getPlants() async {
    try {
      List<Future<DocumentSnapshot>> futures =
          MyGardenRepositoryImplementation.myGardenIds.map((id) {
        return FirebaseFirestore.instance
            .collection("plant")
            .doc(id.toString())
            .get();
      }).toList();
      List<PlantData> plants = (await Future.wait(futures))
          .map((snapshot) =>
              PlantData.fromJson(snapshot.data() as Map<String, dynamic>))
          .toList();
      return left(plants);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }
}
