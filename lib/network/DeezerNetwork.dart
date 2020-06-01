import 'package:richardmusic/model/DeezerR.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class DeezerNetwork {
  static const String API_KEY = "XXXXXXXXXXXXXXXXXXXXXXXX";

  static const String BASE_URL = "https://deezerdevs-deezer.p.rapidapi.com/";
  //static final String SEARCH_URL ="${BASE_URL}search?q=pokora&rapidapi-key=$API_KEY";

  static Future getList() async {
    String q = "La fouine";
    String url = "${BASE_URL}search?q=${q}&rapidapi-key=$API_KEY";

//    String url = "https://api.deezer.com/user/100/playlists";

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return DeezerR.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  static Future search(String q) async {
    String url = "${BASE_URL}search?q=${q}&rapidapi-key=$API_KEY";

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.encodeFull(url));

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return DeezerR.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
