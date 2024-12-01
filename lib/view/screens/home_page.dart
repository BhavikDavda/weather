import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _weatherDetails;
  String? cityName;

  Future<Map<String, dynamic>> fetchWeatherDetails(String cityName) async {
    try {
      Response res = await get(
        Uri.parse(
            "https://api.weatherapi.com/v1/forecast.json?key=3c5009be4d49494f9d245829232208&q=$cityName&days=1&aqi=no&alerts=no"),
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

  Future<void> _refreshData() async {
    if (cityName != null) {
      setState(() {
        _weatherDetails = fetchWeatherDetails(cityName!);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      cityName = args;
      _weatherDetails = fetchWeatherDetails(cityName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text("Weather App", style: GoogleFonts.roboto()),
      ),
      body: _weatherDetails == null
          ? GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("WeatherScreen");
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.location_on_outlined,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Please Add City",
                style: GoogleFonts.roboto(fontSize: 20),
              )
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _weatherDetails,
              builder: (context, snap) {
                final data = snap.data!;
                if (snap.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Text("🏢 ${data['location']['name']}",
                              style: GoogleFonts.roboto(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 250,
                            width: double.infinity ,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade700.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                )
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${data['current']['temp_c'].toInt()}°",
                                      style:
                                      GoogleFonts.roboto(fontSize: 100)),
                                  Text(
                                    "${data['current']['condition']['text']}°C ${data['current']['feelslike_c']}°C Feel Like ${data['current']['feelslike_f']}°C" ??
                                        "",
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: 30,),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 24,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 70,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade900
                                              .withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey,
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "${1 + index}:00",
                                            style: GoogleFonts.roboto(
                                                fontSize: 14),
                                          ),
                                          const Icon(
                                            Icons.light_mode,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            "${data['current']['humidity']}°" ??
                                                "",
                                            style: GoogleFonts.roboto(
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: FutureBuilder<Map<String, dynamic>>(
                                future: _weatherDetails,
                                builder: (contetx, snap) {
                                  final data = snap.data!;
                                  if (snap.hasData) {
                                    return SizedBox(
                                      height: 280,
                                      child: ListView.builder(
                                        itemCount: 7,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade900
                                                  .withOpacity(0.1),
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Text(
                                                    "Day ${index + 1}",
                                                    style: GoogleFonts
                                                        .roboto(
                                                        fontSize: 12),
                                                  ),
                                                  const Icon(Icons.light_mode,
                                                      color:
                                                      Colors.yellow,
                                                      size: 20),
                                                  Text(
                                                    "${data['current']['temp_c'].toInt()} / ${data['current']['temp_f'].toInt()}°C" ??
                                                        "",
                                                    style: GoogleFonts
                                                        .roboto(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                }),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.light_mode, size: 20),
                                      Text(
                                        "UV",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data['current']['uv'].toInt()} Very weak" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.temple_buddhist_rounded,
                                          size: 20),
                                      Text(
                                        "Feel Like",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data['current']['feelslike_c'].toInt()}°" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.backup_rounded,
                                          size: 20),
                                      Text(
                                        "Humidlity",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        " ${data['current']['humidity'].toInt()} %" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.sensor_window, size: 20),
                                      Text(
                                        "${data['current']['wind_mph'].toInt()} mph" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "NE wind",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.air, size: 20),
                                      Text(
                                        "Air pressure",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data['current']['pressure_mb'].toInt()} mb" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 100,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade900
                                        .withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.visibility, size: 20),
                                      Text(
                                        "Visibility",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data['current']['vis_miles'].toInt()} miles" ??
                                            "",
                                        style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
