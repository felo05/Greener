import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/favorite/cubit/favorite_cubit.dart';
import '../../feature/home/model/plant_model.dart';

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({
    super.key,
    required this.plantData,
  });

  final PlantData plantData;

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.plantData.inFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
        size: 32,
      ),
      onPressed: () {
        final favoriteCubit = context.read<FavoriteCubit>();
        widget.plantData.inFavorite
            ? favoriteCubit.removeFromFavorite(widget.plantData)
            : favoriteCubit.addToFavorite(widget.plantData);
        widget.plantData.inFavorite = !widget.plantData.inFavorite;
        setState(() {});
      },
    );
  }
}
