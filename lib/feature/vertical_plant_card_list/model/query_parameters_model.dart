class QueryParametersModel {
  int? indoor;
  int? edible;
  int? poisonous;
  String? watering;
  String? cycle;
  String? q;
  int? page;

  QueryParametersModel({
    this.indoor,
    this.edible,
    this.poisonous,
    this.watering,
    this.cycle,
    this.q,
    this.page,
  });
  QueryParametersModel copyWith({
    int? indoor,
    int? edible,
    int? poisonous,
    String? watering,
    String? cycle,
    String? q,
    int? page,
  }) {
    return QueryParametersModel(
      indoor: indoor ?? this.indoor,
      edible: edible ?? this.edible,
      poisonous: poisonous ?? this.poisonous,
      watering: watering ?? this.watering,
      cycle: cycle ?? this.cycle,
      q: q ?? this.q,
      page: page ?? this.page,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'indoor': indoor,
      'edible': edible,
      'poisonous': poisonous,
      'watering': watering,
      'cycle': cycle,
      'q': q,
      'page': page,
    };
  }
}
