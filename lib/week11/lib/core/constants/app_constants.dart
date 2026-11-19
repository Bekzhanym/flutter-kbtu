class AppConstants {
  AppConstants._();

  static const String apiHost = 'jsonplaceholder.typicode.com';
  static const Duration requestTimeout = Duration(seconds: 10);

  static const String users = '/users';
  static String userById(int id) => '/users/$id';
}
