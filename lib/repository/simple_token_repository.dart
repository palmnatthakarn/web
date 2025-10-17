class SimpleTokenRepository {
  static String? _token = 'demo-token-for-testing'; // ใส่ token ชั่วคราว
  
  Future<void> saveToken(String token) async {
    _token = token;
  }
  
  Future<String?> getToken() async {
    return _token;
  }
  
  Future<void> deleteToken() async {
    _token = null;
  }
  
  Future<bool> hasToken() async {
    return _token != null && _token!.isNotEmpty;
  }
}