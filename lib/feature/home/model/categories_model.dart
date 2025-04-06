import 'package:greener/feature/vertical_plant_card_list/model/query_parameters_model.dart';

class CategoriesModel {
  final String name;
  final String image;
  QueryParametersModel queryParameters;

  CategoriesModel(
      {required this.name, required this.image, required this.queryParameters});

  static List<CategoriesModel> categoriesInHome = [
    CategoriesModel(
        name: "Edible Plants",
        image:
            "https://perenual.com/storage/species_image/351_malus_akane/og/800px-Akane-Pomme-20141026.jpg",
        queryParameters: QueryParametersModel(edible: 1)),
    CategoriesModel(
        name: "Indoor Plants",
        image:
            "https://www.thespruce.com/thmb/orTyb7Vt19_wN6kSPe6iqRlKILI=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/growing-pilea-peperomioides-5090425-2-ef38a5c14652468c9d489a09e7676e20-913dc81040e448e7beff619c8adf0030.jpg",
        queryParameters: QueryParametersModel(indoor: 1)),
    CategoriesModel(
        name: "Japanese Plants",
        image:
            "https://perenual.com/storage/species_image/50_acer_palmatum_chitose_yama/og/pexels-photo-4977537.jpg",
        queryParameters: QueryParametersModel(q: "Japanese")),
    CategoriesModel(
        name: "Outdoor Plants",
        image:
            "https://horticulture.co.uk/wp-content/uploads/2022/07/spikyplants-header.jpg",
        queryParameters: QueryParametersModel(indoor: 0)),
    CategoriesModel(
        name: "Poisonous Plants",
        image:
            "https://perenual.com/storage/species_image/4828_ligustrum_vulgare/og/52407988632_998974bb49_b.jpg",
        queryParameters: QueryParametersModel(poisonous: 1)),
    CategoriesModel(
        name: "Flower",
        image:
            "https://www.gardendesign.com/pictures/images/675x529Max/site_3/endless-illumination-shade-annual-browallia-proven-winners_15185.jpg",
        queryParameters: QueryParametersModel(q: "Flower")),
  ];
}
