import 'package:greener/feature/plant_details/model/plant_guide_model.dart';

class PlantDetailsModel {
  PlantDetailsModel({
    this.id,
    this.commonName,
    this.scientificName,
    this.otherName,
    this.family,
    this.origin,
    this.type,
    this.cycle,
    this.attracts,
    this.dimensions,
    this.propagation,
    this.watering,
    this.depthWaterRequirement,
    this.volumeWaterRequirement,
    this.wateringPeriod,
    this.wateringGeneralBenchmark,
    this.plantAnatomy,
    this.sunlight,
    this.pruningMonth,
    this.pruningCount,
    this.seeds,
    this.maintenance,
    this.soil,
    this.growthRate,
    this.droughtTolerant,
    this.saltTolerant,
    this.thorny,
    this.invasive,
    this.tropical,
    this.indoor,
    this.careLevel,
    this.pestSusceptibility,
    this.flowers,
    this.floweringSeason,
    this.flowerColor,
    this.cones,
    this.fruits,
    this.edibleFruit,
    this.fruitColor,
    this.harvestSeason,
    this.leaf,
    this.leafColor,
    this.edibleLeaf,
    this.cuisine,
    this.medicinal,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.description,
    this.defaultImage,
    this.careGuides,
  });

  factory PlantDetailsModel.fromJson(dynamic json) {
    return PlantDetailsModel(
      id: json['id'],
      commonName: json['common_name'],
      scientificName: json['scientific_name'] != null
          ? json['scientific_name'].cast<String>()
          : [],
      otherName:
          json['other_name'] != null ? json['other_name'].cast<String>() : [],
      family: json['family'],
      origin: json['origin'] != null ? json['origin'].cast<String>() : [],
      type: json['type'],
      cycle: json['cycle'],
      attracts: json['attracts'] != null ? json['attracts'].cast<String>() : [],
      propagation:
          json['propagation'] != null ? json['propagation'].cast<String>() : [],
      watering: json['watering'],
      depthWaterRequirement: json['depth_water_requirement'] is Map
          ? ValueAndUnitClass.fromJson(json['depth_water_requirement'])
          : null,
      volumeWaterRequirement: json['volume_water_requirement'] is Map
          ? ValueAndUnitClass.fromJson(json['volume_water_requirement'])
          : null,
      wateringPeriod: json['watering_period'],
      wateringGeneralBenchmark: json['watering_general_benchmark'] != null
          ? ValueAndUnitClass.fromJson(json['watering_general_benchmark'])
          : null,
      plantAnatomy: json['plant_anatomy'] != null
          ? List<PlantAnatomy>.from(
              json['plant_anatomy'].map((x) => PlantAnatomy.fromJson(x)))
          : [],
      sunlight: json['sunlight'] != null ? json['sunlight'].cast<String>() : [],
      pruningMonth: json['pruning_month'] != null
          ? json['pruning_month'].cast<String>()
          : [],
      pruningCount: json['pruning_count'] != null &&
              json['pruning_count'] is Map<String, dynamic>
          ? PruningCount.fromJson(json['pruning_count'])
          : PruningCount(amount: 0, interval: ''),
      seeds: json['seeds'],
      maintenance: json['maintenance'],
      soil: json['soil'] != null ? json['soil'].cast<String>() : [],
      growthRate: json['growth_rate'],
      droughtTolerant: json['drought_tolerant'],
      saltTolerant: json['salt_tolerant'],
      thorny: json['thorny'],
      invasive: json['invasive'],
      tropical: json['tropical'],
      indoor: json['indoor'],
      careLevel: json['care_level'],
      pestSusceptibility: json['pest_susceptibility'] != null
          ? json['pest_susceptibility'].cast<String>()
          : [],
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'])
          : null,
      flowers: json['flowers'],
      floweringSeason: json['flowering_season'],
      flowerColor: json['flower_color'],
      cones: json['cones'],
      fruits: json['fruits'],
      edibleFruit: json['edible_fruit'],
      fruitColor:
          json['fruit_color'] != null ? json['fruit_color'].cast<String>() : [],
      harvestSeason: json['harvest_season'],
      leaf: json['leaf'],
      leafColor:
          json['leaf_color'] != null ? json['leaf_color'].cast<String>() : [],
      edibleLeaf: json['edible_leaf'],
      cuisine: json['cuisine'],
      medicinal: json['medicinal'],
      poisonousToHumans: json['poisonous_to_humans'],
      poisonousToPets: json['poisonous_to_pets'],
      description: json['description'],
      defaultImage: json['default_image'] != null
          ? json['default_image']['original_url']
          : null,
      careGuides: null, // Initially null, will be set asynchronously
    );
  }

  Future<void> fetchCareGuides(String? guideUrl) async {
    if (guideUrl != null && guideUrl.isNotEmpty) {
      careGuides = await PlantGuideModel.fetchPlantGuide(guideUrl);
    }
  }

  Map<String, dynamic> toJson() {
    return{
      'id': id,
      'common_name': commonName,
      'scientific_name': scientificName,
      'other_name': otherName,
      'family': family,
      'origin': origin,
      'type': type,
      'cycle': cycle,
      'attracts': attracts,
      'propagation': propagation,
      'watering': watering,
      'depth_water_requirement': depthWaterRequirement,
      'volume_water_requirement': volumeWaterRequirement,
      'watering_period': wateringPeriod,
      'watering_general_benchmark': wateringGeneralBenchmark,
      'plant_anatomy': plantAnatomy,
      'sunlight': sunlight,
      'pruning_month': pruningMonth,
      'pruning_count': pruningCount,
      'seeds': seeds,
      'maintenance': maintenance,
      'soil': soil,
      'growth_rate': growthRate,
      'drought_tolerant': droughtTolerant,
      'salt_tolerant': saltTolerant,
      'thorny': thorny,
      'invasive': invasive,
      'tropical': tropical,
      'indoor': indoor,
      'care_level': careLevel,
      'pest_susceptibility': pestSusceptibility,
      'dimensions': dimensions,
      'flowers': flowers,
      'flowering_season': floweringSeason,
      'flower_color': flowerColor,
      'cones': cones,
      'fruits': fruits,
      'edible_fruit': edibleFruit,
      'fruit_color': fruitColor,
      'harvest_season': harvestSeason,
      'leaf': leaf,
      'leaf_color': leafColor,
      'edible_leaf': edibleLeaf,
      'cuisine': cuisine,
      'medicinal': medicinal,
      'poisonous_to_humans': poisonousToHumans,
      'poisonous_to_pets': poisonousToPets,
      'description': description,
      'default_image': defaultImage,
      'care_guides': careGuides,
    };
  }



  int? id;
  String? commonName;
  List<String>? scientificName;
  List<String>? otherName;
  String? family;
  List<String>? origin;
  String? type;
  String? cycle;
  String? watering;
  Dimensions? dimensions;
  List<String>? sunlight;
  List<String>? soil;
  PlantGuideModel? careGuides;
  bool? fruits;
  bool? edibleFruit;
  List<String>? fruitColor;
  bool? indoor;
  bool? thorny;
  String? harvestSeason;
  bool? cuisine;
  bool? medicinal;
  bool? poisonousToHumans;
  bool? poisonousToPets;
  String? description;
  String? defaultImage;
  bool? cones;
  bool? leaf;
  bool? edibleLeaf;
  List<String>? leafColor;
  String? careLevel;
  bool? flowers;
  String? floweringSeason;
  String? flowerColor;
  bool? invasive;
  bool? tropical;
  List<String>? pestSusceptibility;
  String? wateringPeriod;
  bool? droughtTolerant;
  bool? saltTolerant;
  String? growthRate;
  ValueAndUnitClass? depthWaterRequirement;
  ValueAndUnitClass? volumeWaterRequirement;
  ValueAndUnitClass? wateringGeneralBenchmark;
  String? maintenance;
  List<PlantAnatomy>? plantAnatomy;
  List<String>? pruningMonth;
  PruningCount? pruningCount;
  List<String>? attracts;
  List<String>? propagation;
  bool? seeds;
}

class PlantPart {
  PlantPart({this.part, this.color});

  factory PlantPart.fromJson(dynamic json) {
    return PlantPart(
      part: json['part'],
      color: (json['color'] is List) ? List<String>.from(json['color']) : [],
    );
  }

  String? part;
  List<String>? color;
}

class ValueAndUnitClass {
  ValueAndUnitClass({
    this.value,
    this.unit,
  });

  factory ValueAndUnitClass.fromJson(dynamic json) {
    return ValueAndUnitClass(
      value: json['value'],
      unit: json['unit'],
    );
  }

  String? value;
  String? unit;
}

class Dimensions {
  String? type;
  String? unit;
  num? minValue;
  num? maxValue;

  Dimensions({this.type, this.unit, this.minValue, this.maxValue});

  factory Dimensions.fromJson(dynamic json) {
    return Dimensions(
        type: json['type'],
        unit: json['unit'],
        minValue: json['min_value'],
        maxValue: json['max_value']);
  }
}

class PlantAnatomy {
  PlantAnatomy({this.part, this.color});

  factory PlantAnatomy.fromJson(dynamic json) {
    return PlantAnatomy(
      part: json['part'],
      color: (json['color'] is List) ? List<String>.from(json['color']) : [],
    );
  }

  String? part;
  List<String>? color;
}

class PruningCount {
  PruningCount({
    this.amount,
    this.interval,
  });

  factory PruningCount.fromJson(dynamic json) {
    return PruningCount(
      amount: json['amount'],
      interval: json['interval'],
    );
  }

  int? amount;
  String? interval;
}
