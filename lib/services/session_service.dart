class Session {
  static String? token;
  static Map<String, dynamic>? user;

  static bool get isLoggedIn => token != null;

  static void logout() {
    token = null;
    user = null;
  }
}
