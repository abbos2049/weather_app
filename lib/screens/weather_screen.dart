import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/weather_service.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherService _weatherService;
  String _city = "London";
  Map<String, dynamic>? _weatherData;
  String _errorMessage = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService();
    _fetchWeatherData();
  }

  void _fetchWeatherData() async {
    try {
      final data = await _weatherService.fetchWeather(_city);
      setState(() {
        _weatherData = data;
        _errorMessage = "";
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load weather data";
        _weatherData = null;
      });
    }
  }

  void _searchCity() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _city = _controller.text;
      });
      _fetchWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEEE, MMM d, yyyy h:mm a');
    String formattedDate = DateFormat('EEEE, MMM d, yyyy h:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather in $_city",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,  color: Colors.white,),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar for city
              TextField(
                controller: _controller,
                onSubmitted: (_) => _searchCity(),
                decoration: InputDecoration(
                  hintText: "Enter city name",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Date display
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),

              // Weather Data display
              _weatherData == null && _errorMessage.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : _weatherData != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _weatherData!['weather'][0]['description'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${_weatherData!['main']['temp']}°C",
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Humidity: ${_weatherData!['main']['humidity']}%",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Wind Speed: ${_weatherData!['wind']['speed']} m/s",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
