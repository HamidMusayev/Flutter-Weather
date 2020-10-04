import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/coordinate.dart';
import 'package:weather_app/models/weather.dart';

class WeatherApi {
  Coordinate coordinateData;
  Weather weatherData;
  String apiKey = "821afa39423b94e3d3024a0389accbfa";

  Future<void> getDataByCityName(String cityName) async {
    String url = "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    print("getting data");
    if (jsonData != null) {
      Coordinate coordinate = Coordinate(
        lat: jsonData["coord"]["lat"],
        lon: jsonData["coord"]["lon"],
        name: jsonData["name"],
      );
      coordinateData = coordinate;

      Weather weather = Weather(
        id: jsonData["weather"][0]["id"],
        main: jsonData["weather"][0]["main"],
        description: jsonData["weather"][0]["description"],
        icon: jsonData["weather"][0]["icon"],
        temp: jsonData["main"]["temp"],
        feelsLike: jsonData["main"]["feels_like"],
        tempMin: jsonData["main"]["temp_min"],
        tempMax: jsonData["main"]["temp_max"],
        //pressure: jsonData["main"]["pressure"],
        humidity: jsonData["main"]["humidity"],
      );
      weatherData = weather;
    } else {
      print("can't get data");
    }
  }
}
