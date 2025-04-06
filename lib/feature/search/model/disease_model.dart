class DiseaseModel {
  List<DiseaseData>? data;

  DiseaseModel({this.data});

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      data: json['data'] != null
          ? List<DiseaseData>.from(
              json['data'].map((x) => DiseaseData.fromJson(x)))
          : [],
    );
  }
}

class DiseaseData {
  String? commonName;
  String? scientificName;
  List<String>? otherName;
  String? family;
  String? image;
  List<SubTitles>? solutions;
  List<SubTitles>? descriptions;
  List<String>? hosts;

  DiseaseData(
      {this.commonName,
      this.scientificName,
      this.otherName,
      this.family,
      this.image,
      this.solutions,
      this.hosts,
      this.descriptions});

  factory DiseaseData.fromJson(Map<String, dynamic> json) {
    return DiseaseData(
      commonName: json['common_name'],
      hosts: json['host'] != null ? json['host'].cast<String>() : [],
      scientificName: json['scientific_name'] ,
      otherName:
          json['other_name'] != null ? json['other_name'].cast<String>() : [],
      family: json['family'],
      image: json['images'] != null && json['images'].isNotEmpty
          ? json["images"][0]['original_url']
          : null,
      solutions: json['solution'] != null
          ? List<SubTitles>.from(
              json['solution'].map((x) => SubTitles.fromJson(x)))
          : [],
      descriptions: json['description'] != null
          ? List<SubTitles>.from(
              json['description'].map((x) => SubTitles.fromJson(x)))
          : [],
    );
  }
}

class SubTitles {
  String? title;
  String? description;

  SubTitles({this.title, this.description});

  factory SubTitles.fromJson(Map<String, dynamic> json) {
    return SubTitles(
      title: json['subtitle'],
      description: json['description'],
    );
  }
}
