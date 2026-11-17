import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/favoris_model.dart';
class FavoriteButton extends StatelessWidget {
  final Destination destination;
  const FavoriteButton({super.key, required this.destination});
 
  @override
  Widget build(BuildContext context) {
    // TODO lire l'état avec context.watch<FavorisModel>()
    final favorisModel = context.watch<FavorisModel>().estFavori(destination);

    // TODO IconButton : cœur plein ou vide
    return IconButton(
      icon: Icon(
        favorisModel ? Icons.favorite : Icons.favorite_border,
        color: favorisModel ? Colors.red : null,
      ),
      onPressed: () {
        context.read<FavorisModel>().basculer(destination);
      },
    );
  }
}
