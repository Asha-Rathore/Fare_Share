import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:travelapp/models/place_search.dart';

class PlacesService {
  var dio = Dio();

  final key = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  
}


/* import 'package:dio/dio.dart';

/// More examples see https://github.com/flutterchina/dio/tree/master/example
void main() async {
  var dio = Dio();
  final response = await dio.get('https://google.com');
  print(response.data);
} */