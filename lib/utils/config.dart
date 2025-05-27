class AppConfig {
  // URL de l'API utilisée en mode debug et en production
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String ordersEndpoint = '$baseUrl/addCommande';
  
  // Configuration pour autoriser le trafic non sécurisé (HTTP)
  static const bool allowInsecureConnections = true;
}
