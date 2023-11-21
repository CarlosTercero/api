import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Boxeo {
  late final String name;
  String? imageUrl;
  String? apiname;
  int? score;
  int? edad;
  int? victorias;
  int? derrotas;
  String? descripcion;

  Boxeo.fromJson(Map<String, dynamic> data) {
    name = data["name"];
    imageUrl = data["img"];
    apiname = name.toLowerCase();
    score = data["score"];
    edad = data["edad"];
    victorias = data["victorias"];
    derrotas = data["derrotas"];
    descripcion = data["descripcion"];
  }

  int rating = 10;

  Boxeo(this.name);


    static Future<List<dynamic>> obtenerDatosBoxeoApi() async {
      HttpClient http = HttpClient();
      try {
        var uri = Uri.https('654e8160cbc325355742eca0.mockapi.io', '/api/boxeo/boxeo');
        var request = await http.getUrl(uri);
        var response = await request.close();
        var responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody);
      } catch (exception) {
        //print(exception);
        return[];
      }
    }

  
  
}
