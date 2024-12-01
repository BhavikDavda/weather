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

  Future<List<dynamic>> getUserLit() async {
    Response userResponse = await get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    interceptor(userResponse);

    List list = jsonDecode(userResponse.body);
    return list;
  }

  Future<List<dynamic>> getPhotos() async {
    Response res = await get(Uri.parse(
        "https://pixabay.com/api/?key=47290946-f24a532c9cde2b26ed1a38eef"));
    interceptor(res);

    Map<String, dynamic> map = jsonDecode(res.body);
    List list = map['hits'];
    return list;
  }

  Future<List<dynamic>> getRestUser() async{
    Response res=await get(Uri.parse("https://api-generator.retool.com/oOhR1I/data"));
    return jsonDecode(res.body);
    interceptor(res);
  }

  Future addUser(String name,String email)async{
    Map<String,dynamic> reqParam={
      "name":name,
      "email":email
    };
    Response res =await post(Uri.parse("https://api-generator.retool.com/oOhR1I/data"),
      body: jsonEncode(reqParam),
      headers: {"Content-Type":"application/json"},
    );
    interceptor(res);
  }

  Future<bool> DeleteUser(num id) async{
    Response res=await delete(Uri.parse("https://api-generator.retool.com/oOhR1I/data/$id"));
    return res.statusCode==200;
  }

  void interceptor(Response response) {
    print("user===> ${response.statusCode}");
    print("user===> ${response.body}");
  }
}

