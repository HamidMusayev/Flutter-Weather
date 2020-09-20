import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/city.dart';

class CityApi {
  List<City> cities = [];

  Future<void> getCitiesByName(String cityName) async {
    String url = "https://www.metaweather.com/api/location/search/?query=$cityName";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    jsonData.forEach((element) {
      if (element["title"] != null) {
        City city = City(
          title: element["title"],
          locationType: element["location_type"],
          woeId: element["woeid"],
          lattLong: element["latt_long"],
        );
        cities.add(city);
      }
    });
  }
}
