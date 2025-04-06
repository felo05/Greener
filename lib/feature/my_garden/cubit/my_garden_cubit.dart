import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greener/feature/my_garden/repository/my_garden_repository_implementation.dart';
import '../../home/model/plant_model.dart';
part 'my_garden_state.dart';

class MyGardenCubit extends Cubit<MyGardenState> {
  MyGardenCubit() : super(MyGardenInitial());
   final MyGardenRepositoryImplementation
      _myGardenRepositoryImplementation = MyGardenRepositoryImplementation();

  List<PlantData> _myGardenPlants = [];

  void getMyGardenPlants() async {
    emit(MyGardenLoadingState());
    (await _myGardenRepositoryImplementation.getPlants()).fold((data) {
      _myGardenPlants = data;
      emit(MyGardenSuccessState(data));
    }, (failure) {
      emit(MyGardenErrorState(failure.errorMessage));
    });
  }

   void addToMyGarden(PlantData plant) {
    _myGardenRepositoryImplementation.addPlant(plant);
    _myGardenPlants.add(plant);
    emit(MyGardenSuccessState(_myGardenPlants));
  }

   void removeFromMyGarden(PlantData plant) {
    _myGardenRepositoryImplementation.removePlant(plant);
    _myGardenPlants.removeWhere((p) => p.id == plant.id);
    emit(MyGardenSuccessState(_myGardenPlants));
  }
}
