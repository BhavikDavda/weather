import 'dart:convert';
import 'package:http/http.dart';

class ApiHelper {
  static ApiHelper obj = ApiHelper._();

  ApiHelper._(){}

  Future<Map<String,dynamic>> getCity({required String? search})async{
    Response res=await get(Uri.parse("https://api.weatherapi.com/v1/forecast.json?key=3c5009be4d49494f9d245829232208&q=$search||rajkot&days=1&aqi=no&alerts=no"));

    Map<String,dynamic> map= jsonDecode(res.body);
    return map;
    interceptor(res);
  }



  void interceptor(Response response) {
    print("user===> ${response.statusCode}");
    print("user===> ${response.body}");
  }
}

