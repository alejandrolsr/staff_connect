import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  //Ubicación de Málaga 
  static const double lat = 36.7213;
  static const double lon = -4.4214;
  
  //URL de la API Open-Meteo
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=auto';

  Future<Map<String, dynamic>> fetchWeather() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        //Decodificamos el JSON
        final data = json.decode(response.body);
        
        //Extraemos los datos
        final current = data['current'];
        
        return {
          'temp': current['temperature_2m'],
          'humidity': current['relative_humidity_2m'],
          'wind': current['wind_speed_10m'],
          'code': current['weather_code'], 
          'units': data['current_units'], 
        };
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      //Si no hay internet o falla, lanzamos error controlado
      throw Exception('Error de conexión: $e');
    }
  }

  //Método para traducir el código numérico a icono y texto
  Map<String, dynamic> getWeatherIcon(int code) {
    if (code == 0) return {'icon': '☀️', 'text': 'Despejado'};
    if (code >= 1 && code <= 3) return {'icon': '⛅', 'text': 'Nublado'};
    if (code >= 45 && code <= 48) return {'icon': '🌫️', 'text': 'Niebla'};
    if (code >= 51 && code <= 67) return {'icon': '🌧️', 'text': 'Lluvia'};
    if (code >= 71 && code <= 77) return {'icon': '❄️', 'text': 'Nieve'};
    if (code >= 95) return {'icon': '⛈️', 'text': 'Tormenta'};
    return {'icon': '❓', 'text': 'Desconocido'};
  }
}