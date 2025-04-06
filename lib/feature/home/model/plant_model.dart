import 'package:greener/feature/my_garden/repository/my_garden_repository_implementation.dart';

import '../../favorite/repository/favorite_repository_implementation.dart';

class PlantModel {
  PlantModel({
    this.data,
    this.total,
  });

  factory PlantModel.fromJson(dynamic json) {
    return PlantModel(
      data: (json['data'] != null)
          ? List<PlantData>.from(
        json['data']
            .where((x) => x["sunlight"] is List) // Filter items where sunlight is a list
            .map((x) => PlantData.fromJson(x)) // Map remaining items to PlantData
            .toList(),
      )
          : [],
      total: json['total'],
    );
  }

  List<PlantData>? data;
  num? total;
}

class PlantData {
  PlantData(
      {this.id,
      this.commonName,
      this.scientificName,
      this.otherName,
      this.cycle,
      this.watering,
      this.sunlight,
      this.notification,
      this.defaultImage,
      required this.inFavorite,
      required this.inMyGarden});

  factory PlantData.fromJson(dynamic json) {
    return PlantData(
      id: json['id'],
      inFavorite:
          FavoriteRepositoryImplementation.favoriteIds.contains(json['id']),
      inMyGarden:
          MyGardenRepositoryImplementation.myGardenIds.contains(json['id']),
      commonName: json['common_name'],
      scientificName: json['scientific_name'] != null
          ? json['scientific_name'].cast<String>()
          : [],
      otherName:
          json['other_name'] != null ? json['other_name'].cast<String>() : [],
      cycle: json['cycle'],
      watering: json['watering'],
      sunlight: json['sunlight'] != null ? json['sunlight'].cast<String>() : [],
      defaultImage: json['default_image'] != null
          ? json['default_image'] is String
              ? json['default_image']
              : json['default_image']["original_url"]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'other_name': otherName,
      'cycle': cycle,
      'watering': watering,
      'sunlight': sunlight,
      'default_image': defaultImage,
      "inMyGarden": inMyGarden,
      "inFavorite": inFavorite,
      "notification": notification,
    };
  }

  int? id;
  bool inFavorite;
  bool inMyGarden;
  String? commonName;
  List<String>? scientificName;
  List<String>? otherName;
  String? cycle;
  String? watering;
  List<String>? sunlight;
  String? defaultImage;
  Map<String, dynamic>? notification;
}
