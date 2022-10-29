import 'package:flutter/foundation.dart';
import 'package:travelapp/models/place_search.dart';
import 'package:travelapp/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final placesService =  PlacesService();

  List<PlaceSearch> searchResults = <PlaceSearch>[];

  ApplicationBloc();

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm);
    notifyListeners();
  }
  
}