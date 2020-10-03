import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/api_weather.dart';
import 'package:weather_app/models/coordinate.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/app_colors.dart';
import 'package:weather_app/utils/text_styles.dart';
import 'package:weather_app/widgets/bottom_button.dart';
import 'package:weather_app/widgets/search_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Coordinate coordinate = Coordinate();
  Weather weather = Weather();

  TextEditingController cityNameTxt = TextEditingController();
  PanelController _bottomController = PanelController();

  bool _loading = false;

  @override
  void initState() {
    getWeather("baku");
    super.initState();
  }

  void getWeather(String cityName) async {
    WeatherApi weatherClass = WeatherApi();
    await weatherClass.getDataByCityName(cityName).whenComplete(() {
      coordinate = weatherClass.coordinateData;
      weather = weatherClass.weatherData;
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(coordinate.name, style: cityNameTextStyle()),
                SizedBox(height: 55.0),
                Text(
                    "H ${(weather.tempMax - 273.15).floor().toString()}°C / L ${(weather.tempMin - 273.15).floor().toString()}°C"),
                SizedBox(height: 80.0),
                Text("${(weather.temp - 273.15).floor().toString()}°",
                    style: weatherBoldTextStyle()),
                Text(weather.main, style: weatherMainTextStyle()),
                SizedBox(height: 80.0),
                Row(
                  children: <Widget>[
                    Icon(Icons.beach_access,
                        color: AppColors.darkGrey, size: 30.0),
                    Text("${weather.humidity.toString()}%",
                        style: weatherMainTextStyle())
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  "${weather.description[0].toUpperCase()}${weather.description.substring(1)}. Feels like ${(weather.feelsLike - 273.15).floor().toString()}°C",
                  style: weatherDescriptionTextStyle(),
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            minHeight: 24.0,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 10.0,
                color: Color.fromRGBO(0, 0, 0, 0.05),
              )
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            controller: _bottomController,
            panel: Container(
              padding: EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  BottomButton(),
                  SizedBox(height: 18.0),
                  SearchInput(
                    controller: cityNameTxt,
                    onPress: () {
                      setState(() {
                        _loading = true;
                        getWeather(cityNameTxt.text);
                      });
                    },
                  ),
                  _loading == false
                      ? buildListView()
                      : Container(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: CircularProgressIndicator(
                                backgroundColor: AppColors.blueBackground),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildListView() {
    return ListView.builder(
        itemCount: 1,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(coordinate.lon.toString()),
          );
        });
  }
}
