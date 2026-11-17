import 'package:flutter/foundation.dart';
import '../models/destination.dart';

class FavorisModel extends ChangeNotifier {
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
  // TODO basculer(Destination d) : ajoute ou retire,
  //      prévient les écouteurs, renvoie true si ajouté
  bool basculer(Destination d) {
    if (estFavori(d)) {
      _favoris.remove(d.id);
      notifyListeners();
      return false;
    } else {
      _favoris[d.id] = d;
      notifyListeners();
      return true;
    }
  }
}
