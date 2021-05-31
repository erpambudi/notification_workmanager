import 'artilce.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = "https://newsapi.org/v2/";
  static final String _apiKey = "YOUR_API_KEY";
  static final String _countryId = 'id';

  Future<ArticleResponse> topHeadlines() async {
    final String _url =
        _baseUrl + "top-headlines?country=$_countryId&apiKey=$_apiKey";

    final _response = await http.get(Uri.parse(_url));

    if (_response.statusCode == 200) {
      return ArticleResponse.fromJson(json.decode(_response.body));
    } else {
      throw Exception("Gagal Load API Top Headlines");
    }
  }
}
