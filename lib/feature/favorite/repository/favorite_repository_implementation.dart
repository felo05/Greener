import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:greener/core/errors/api_errors.dart';
import 'package:greener/core/helpers/hive_helper.dart';
import 'package:greener/feature/home/model/plant_model.dart';

import 'favorite_repository.dart';

class FavoriteRepositoryImplementation implements FavoriteRepository {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static Set<dynamic> favoriteIds = {};

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
  void addFavorite(PlantData plant) async {
    favoriteIds.add(plant.id!);
    if (!(await _checkPlantInFirebase(plant))) {
      final response = await Gemini.instance.prompt(parts: [
        Part.text(
            "For ${plant.commonName}, provide the average sunlight duration in hours and the average watering period as a JSON object in the following format: {sunlight_duration: number, average_watering_period: {value: number, unit: times per [day/week]}}. Return only the JSON object without any additional text or formatting.")
      ]);
      Map<String, dynamic> data =
      jsonDecode(response!.output!.substring(7, response.output!.length - 4));
      plant.notification = data;
      _addPlantInFirebase(plant);
    }
    _fireStore.collection('users').doc(HiveHelper.getId()).update({
      "favorite": FieldValue.arrayUnion([plant.id!])
    });
  }

  @override
  void removeFavorite(PlantData plant) {
    favoriteIds.remove(plant.id!);
    _fireStore.collection('users').doc(HiveHelper.getId()).update({
      "favorite": FieldValue.arrayRemove([plant.id!])
    });
  }

  static void getFavoriteIds() async {
    favoriteIds = ((await _fireStore
            .collection('users')
            .doc(HiveHelper.getId())
            .get())["favorite"])
        .toSet();
  }

  @override
  Future<Either<Failure, List<PlantData>>> getFavorites() async {
    try {
      List<Future<DocumentSnapshot>> futures =
          FavoriteRepositoryImplementation.favoriteIds.map((id) {
        return FirebaseFirestore.instance
            .collection("plant")
            .doc(id.toString())
            .get();
      }).toList();
      List<PlantData> plants = (await Future.wait(futures))
          .map((snapshot) =>
              PlantData.fromJson(snapshot.data() as Map<String, dynamic>))
          .toList();
      return right(plants);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
