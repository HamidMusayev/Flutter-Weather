import 'package:flutter/material.dart';
import 'package:weather_app/data/api.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/utils/app_colors.dart';
import 'package:weather_app/utils/text_styles.dart';
import 'package:weather_app/widgets/search_input.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<City> cities = List<City>();
  bool _loading = true;
  TextEditingController cityNameTxt = TextEditingController();

  @override
  void initState() {
    getCities("san");
    super.initState();
  }

  void getCities(String cityNameTxt) async {
    CityApi cityClass = CityApi();
    await cityClass.getCitiesByName(cityNameTxt);
    cities = cityClass.cities;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30.0)),
                  color: AppColors.blueBackground),
              child: SearchInput(
                controller: cityNameTxt,
                onPress: () {
                  setState(() {
                    getCities(cityNameTxt.text);
                  });
                },
              ),
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cities[index].title),
                        subtitle: Text(cities[index].woeId.toString()),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
