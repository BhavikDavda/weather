import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _result = "";
  List<String> _storedData = [];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  void _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedData = prefs.getStringList('weatherData') ?? [];
    });
  }

  Future<void> _saveData(String cityName, double tempC) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weatherData = "City: $cityName, Temperature: $tempC°C";
    _storedData.add(weatherData);
    await prefs.setStringList('weatherData', _storedData);

    setState(() {});
  }

  Future<void> _deleteData(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedData.removeAt(index);
    });
    await prefs.setStringList('weatherData', _storedData);
  }

  Future<Map<String, dynamic>> getCity(String search) async {
    String query = search.isNotEmpty ? search : "rajkot";

    try {
      Response res = await get(
        Uri.parse(
            "https://api.weatherapi.com/v1/forecast.json?key=3c5009be4d49494f9d245829232208&q=$query&days=1&aqi=no&alerts=no"),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        throw Exception(
            'Failed to fetch weather data: ${res.statusCode} - ${res.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  void _searchCity() async {
    String city = _cityController.text.trim();

    try {
      Map<String, dynamic> cityData = await getCity(city);

      String cityName = cityData['location']['name'];
      double tempC = cityData['current']['temp_c'];

      setState(() {
        _result = "City: $cityName\nTemperature: $tempC°C";
      });
      await _saveData(cityName, tempC);
    } catch (e) {
      setState(() {
        _result = e.toString();
      });
    }
  }

  void _navigateToDetails(String cityName) {
    Navigator.of(context).pushNamed("/", arguments: cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text("City Weather Search", style: GoogleFonts.roboto()),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Check Weather of Any City",
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: "Enter City Name",
                        labelStyle: GoogleFonts.roboto(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _searchCity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                      ),
                      child: Text(
                        "Search",
                        style:TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )


                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Current Weather:",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _result.isNotEmpty ? _result : "No data fetched yet.",
                    style: GoogleFonts.roboto(fontSize: 16,color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                "Stored Weather Data:",
                style: GoogleFonts.roboto(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),

              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _storedData.length,
                  itemBuilder: (context, index) {
                    String cityName = _storedData[index]
                        .split(",")[0]
                        .split(":")[1]
                        .trim();
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          _storedData[index],
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteData(index),
                        ),
                        onTap: () {
                          _navigateToDetails(cityName);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
