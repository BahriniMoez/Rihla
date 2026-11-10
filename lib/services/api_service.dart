import 'dart:convert';
 
import 'package:http/http.dart' as http;
import 'package:rihla/models/reservation.dart';
 
import '../config/api_config.dart';
import '../models/destination.dart';
 
class ApiService {
  static Uri _url(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');
 
  static Future<List<Destination>> getDestinations() async {
    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 200) {
      throw Exception('Erreur de chargement des destinations (Code : ${reponse.statusCode})');
    }

    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));

    return liste
        .map((element) => Destination.fromJson(element as Map<String, dynamic>))
        .toList();

  }

  static Future<String> creerReservation(Reservation reservation) async {
  final reponse = await http
      .post(
        _url('/reservations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reservation.toJson()),
      )
      .timeout(ApiConfig.timeout);

  if (reponse.statusCode != 201) {
    throw Exception('Erreur lors de la création de la réservation (Code : ${reponse.statusCode})');
  }

  final Map<String, dynamic> creee = jsonDecode(utf8.decode(reponse.bodyBytes));
  return creee['id'].toString();   
}
}
