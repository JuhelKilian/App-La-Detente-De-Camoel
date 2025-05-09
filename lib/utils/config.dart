class AppConfig {
  // URL de l'API utilisée en mode debug et en production
  static const String baseUrl = 'http://ladetentedecamoel-web-7uucjr-41b780-192-168-147-50.traefik.me/api';
  static const String ordersEndpoint = '$baseUrl/addCommande';
  
  // Configuration pour autoriser le trafic non sécurisé (HTTP)
  static const bool allowInsecureConnections = true;
}
