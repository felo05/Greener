import '../../../core/helpers/dio_helper.dart';

class PlantGuideModel {
  PlantGuideModel({this.data});

  factory PlantGuideModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List && json['data'].isNotEmpty) {
      return PlantGuideModel(
        data: PlantGuideSections.fromJson(json['data'][0]['section']), // Fix: Pass 'section' directly
      );
    }
    return PlantGuideModel();
  }

  static Future<PlantGuideModel> fetchPlantGuide(String guideUrl) async {
    final response = await DioHelpers.getData(path: guideUrl);
    return PlantGuideModel.fromJson(response.data);
  }

  PlantGuideSections? data;
}

class PlantGuideSections {
  PlantGuideSections({this.section});

  factory PlantGuideSections.fromJson(List<dynamic> json) {
    List<PlantGuideDetails> section = json.map((v) => PlantGuideDetails.fromJson(v)).toList();
    return PlantGuideSections(section: section);
  }

  List<PlantGuideDetails>? section;
}

class PlantGuideDetails {
  PlantGuideDetails({this.type, this.description});

  factory PlantGuideDetails.fromJson(dynamic json) {
    return PlantGuideDetails(
      type: json['type'] as String?,
      description: json['description'] as String?,
    );
  }

  String? type;
  String? description;
}
