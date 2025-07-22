class ApiConstants {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';
  
  // Auth endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String profile = '/user/profile';
  
  // Movie endpoints
  static const String movieList = '/movie/list';
  static const String movieFavorites = '/movie/favorites';
  static String movieFavorite(String id) => '/movie/favorite/$id';
  
  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
}