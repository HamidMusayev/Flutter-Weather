import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/data/api.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/utils/app_colors.dart';
import 'package:weather_app/utils/text_styles.dart';
import 'package:weather_app/widgets/search_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<City> cities = List<City>();
  bool _loading = false;
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
      body: Stack(
        children: <Widget>[
          Center(
            child: Text("This is the Widget behind the sliding panel"),
          ),
          SlidingUpPanel(
            minHeight: 65.0,
            parallaxEnabled: true,
            parallaxOffset: .5,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            header: Container(
              height: 65.0,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                  color: AppColors.blueBackground),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Change city...",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 35)
                ],
              ),
            ),
            panel: Container(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.blueBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                        ),
                        padding: const EdgeInsets.only(
                            left: 22.0, right: 22.0, top: 80.0, bottom: 22.0),
                        child: SearchInput(
                          controller: cityNameTxt,
                          onPress: () {
                            setState(() {
                              _loading = true;
                              getCities(cityNameTxt.text);
                            });
                          },
                        ),
                      ),
                      _loading == false
                          ? ListView.builder(
                              itemCount: cities.length,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(cities[index].title),
                                  subtitle:
                                      Text(cities[index].locationType),
                                );
                              })
                          : Container(
                        padding: EdgeInsets.only(top: 50.0),
                            child: Center(
                                child: CircularProgressIndicator(backgroundColor: AppColors.blueBackground),
                              ),
                          )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
