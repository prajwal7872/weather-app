import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/Model/weather_model.dart';
import '/Services/services.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
    super.initState();
  }

  myWeather() async {
    setState(() {
      isLoading = false;
    });
    try {
      weatherInfo = await WeatherServices().fetchWeather();
    } catch (e) {
      // Handle the error accordingly
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? WeatherDetail(
                      weather: weatherInfo,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display location name
        Text(
          weather.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Display current temperature
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Display weather condition if available
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 30),
        // Display current date and time
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        // Display weather icon
        Container(
          height: 105,
          width: 105,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Display more weather details
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row for wind, max temp, and min temp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherInfoCard(
                      title: "Wind",
                      value: "${weather.wind.speed} km/h",
                      icon: Icons.wind_power,
                    ),
                    weatherInfoCard(
                      title: "Max",
                      value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
                      icon: Icons.sunny,
                    ),
                    weatherInfoCard(
                      title: "Min",
                      value: "${weather.minTemperature.toStringAsFixed(2)}°C",
                      icon: Icons.ac_unit,
                    ),
                  ],
                ),
                const Divider(),
                // Row for humidity, pressure, and sea-level
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherInfoCard(
                      title: "Humidity",
                      value: "${weather.humidity}%",
                      icon: Icons.water_drop,
                    ),
                    weatherInfoCard(
                      title: "Pressure",
                      value: "${weather.pressure} hPa",
                      icon: Icons.speed,
                    ),
                    weatherInfoCard(
                      title: "Sea-Level",
                      value: "${weather.seaLevel} m",
                      icon: Icons.waves,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Weather info card widget
  Widget weatherInfoCard({required String title, required String value, required IconData icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
