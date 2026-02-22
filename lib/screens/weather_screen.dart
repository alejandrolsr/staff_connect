import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../widgets/side_menu.dart';
import '../theme/app_theme.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<Map<String, dynamic>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchWeather();
  }

  //Función para recargar
  void _refreshWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('El Tiempo')),
      drawer: const SideMenu(currentPage: 'weather'),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _weatherFuture,
          builder: (context, snapshot) {
          
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            //Si hay error, mostramos mensaje y botón de recarga
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text("Error al cargar el tiempo", style: TextStyle(fontSize: 18)),
                  Text(snapshot.error.toString().split(':').last, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _refreshWeather,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reintentar"),
                  )
                ],
              );
            }

            if (snapshot.hasData) {
              final data = snapshot.data!;
              final weatherInfo = _weatherService.getWeatherIcon(data['code']);
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  Card( //Card principal con icono, temperatura y descripción
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: AppTheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text(weatherInfo['icon'], style: const TextStyle(fontSize: 80)),
                          const SizedBox(height: 10),
                          Text(
                            "${data['temp']}${data['units']['temperature_2m']}",
                            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            weatherInfo['text'],
                            style: const TextStyle(fontSize: 24, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard(Icons.water_drop, "Humedad", "${data['humidity']}${data['units']['relative_humidity_2m']}"),
                      _buildInfoCard(Icons.air, "Viento", "${data['wind']} ${data['units']['wind_speed_10m']}"),
                    ],
                  ),
                  
                  const SizedBox(height: 40), 
                  ElevatedButton.icon(
                    onPressed: _refreshWeather,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Actualizar datos"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  )
                ],
              );
            }

            return const Text("No hay datos disponibles");
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) { //Card para mostrar información adicional (humedad, viento, etc).
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: AppTheme.primary),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}