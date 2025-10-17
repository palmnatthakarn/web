class ApiConstants {
  static const String baseUrl = 'https://api.dev.dedepos.com';
  static const String listShopEndpoint = '/list-shop';

  static Map<String, String> getHeaders(String? token) => {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    // ปิด Authorization ชั่วคราว
    // if (token != null) 'Authorization': 'Bearer $token',
  };
}
