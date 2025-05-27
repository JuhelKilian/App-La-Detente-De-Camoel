import 'dart:convert'; // Nécessaire pour la conversion JSON
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On vérifie si un QR code correspond à une réservation valide dans la base de données.
Future<Map<String, dynamic>> checkReservation(String qrCode) async {
  var headers = {
    'Accept': 'application/json',
  };

  // Récupérer le token depuis SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    // Retourne un état spécial si le token est absent
    return {'error': 'unauthenticated'};
  }

  // Ajouter le token Bearer dans le header
  headers['Authorization'] = 'Bearer $token';

  String url = '${AppConfig.baseUrl}/reservation/qrCode/?QrCode=$qrCode';
  var request = http.Request('GET', Uri.parse(url));
  request.body = '''''';
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      String responseData = await response.stream.bytesToString();
      print(responseData);
      return jsonDecode(responseData);

    } else if (response.statusCode == 404) {
      return {};
    } else {
      throw Exception('Erreur serveur: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Erreur de connexion: $e');
  }
}

Future<List<dynamic>> recupererTables() async {

  Map<String, dynamic> donnees = {};
  // On se connecte

  var headers = {
    'Accept': 'application/json',
  };

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    return ["unauthenticated"];
  }

  headers['Authorization'] = 'Bearer $token';

  String url = '${AppConfig.baseUrl}/tables';


  var request = http.Request('GET', Uri.parse(url));
  request.body = '''''';
  request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      String responseData = await response.stream.bytesToString();

      return jsonDecode(responseData);
    } else {
      throw Exception('Erreur serveur: ${response.reasonPhrase}');
    }
}

Future<List<dynamic>> changerTables(String idReservation, int? idTableChangee) async {

  List<dynamic> donnees = [];
  /* Deux cases dans ce tableau :
    * Un string correspondant à l'erreur
    * Un int avec la valeur modifiée de la table si opérations réussis
  */
  var headers = {
    'Accept': 'application/json',
  };

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    return ["Vous n'êtes pas connecté !", -1];
  }

  headers['Authorization'] = 'Bearer $token';

  String url = '${AppConfig.baseUrl}/reservation/changerTable/$idReservation/$idTableChangee';


  var request = http.Request('PATCH', Uri.parse(url));
  request.body = '''''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String responseData = await response.stream.bytesToString();
  if (response.statusCode == 200) {
    // Décoder la réponse JSON

    return ["", jsonDecode(responseData)['reservation']['IDTABLE']];
  } else {
    var message = jsonDecode(responseData);
    return [
      message['message'], -1
    ];
  }
}

Future<void> validerQR(Map<String, dynamic> Reservation) async {

  List<dynamic> donnees = [];
  int idReservation = int.parse(Reservation['id_reservation']);

  var headers = {
    'Accept': 'application/json',
  };

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception("Vous n'êtes pas connecté !");
  }

  headers['Authorization'] = 'Bearer $token';

  String url = '${AppConfig.baseUrl}/reservation/valider/$idReservation';


  var request = http.Request('PATCH', Uri.parse(url));
  request.body = '''''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String responseData = await response.stream.bytesToString();

}

Future<Map<String, dynamic>> reporterReservation(int idReservation, String date, String heure) async {
  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    return {'error': 'unauthenticated'};
  }

  headers['Authorization'] = 'Bearer $token';

  String url = '${AppConfig.baseUrl}/reservation/reporter/$idReservation';

  // On envoie date et heure dans le corps JSON
  final body = jsonEncode({
    'date': date,
    'heure': heure,
  });

  var request = http.Request('POST', Uri.parse(url));
  request.body = body;
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();

    String responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseData);
    } else {
      var message = jsonDecode(responseData);
      return {'error': message['message'] ?? 'Erreur serveur'};
    }
  } catch (e) {
    return {'error': 'Erreur de connexion: $e'};
  }
}
