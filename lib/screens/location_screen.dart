import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late double temperature;
  late String cityName;
  late int condition;
  late String weatherIcon;
  late String temp;
  late String message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.locationWeather);
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temp = '0';
        message = 'Unable to get weather data';
        weatherIcon = 'Error';
        return;
      }

      WeatherModel weatherModel = WeatherModel();
      temperature = weatherData['main']['temp'];
      cityName = weatherData['name'];
      condition = weatherData['weather'][0]['id'];
      temp = temperature.toStringAsFixed(1);
      message = "${weatherModel.getMessage(temperature.toInt())} in $cityName!";
      weatherIcon = '${weatherModel.getWeatherIcon(condition)}';

      print('Temperature: $temperature');
      print('TEmperature = $temp');
      print('City Name: $cityName');
      print('Condition: $condition');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var newLoactionWeather =
                          await WeatherModel().getLocationWeather();
                      updateUI(newLoactionWeather);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CityScreen()));
                      print('Typed Name: $typedCityName');
                      if (typedCityName != null) {
                        var newLoactionWeather =
                            await WeatherModel().getCityWeather(typedCityName);
                        updateUI(newLoactionWeather);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  message,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
