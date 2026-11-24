import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisModel extends ChangeNotifier {
  static const _cle = 'favoris';

  // favoris rangés par id : Map<String, Destination>
  final Map<String, Destination> _favoris = {};
 
  // TODO estFavori(Destination d) -> bool
  bool estFavori(Destination d) => _favoris.containsKey(d.id);
  
  // TODO getter liste : les destinations favorites
  List<Destination> get liste => List.unmodifiable(_favoris.values.toList());
  
  // TODO getter nombre
  int get nombre {
    return _favoris.length;
  }

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final listeJson = prefs.getStringList(_cle) ?? [];

    _favoris.clear();
    for (final item in listeJson) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      final destination = Destination.fromJson(map);
      _favoris[destination.id] = destination;
    }

    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final listeJson = _favoris.values
        .map((destination) => jsonEncode(destination.toJson()))
        .toList();

    await prefs.setStringList(_cle, listeJson);
  }

  // TODO basculer(Destination d) : ajoute ou retire,
  //      prévient les écouteurs, renvoie true si ajoutéq
  bool basculer(Destination d) {
    if (estFavori(d)) {
      _favoris.remove(d.id);
      _sauvegarder();
      notifyListeners();
      return false;
    } else {
      _favoris[d.id] = d;
      _sauvegarder();
      notifyListeners();
      return true;
    }
  }
}
