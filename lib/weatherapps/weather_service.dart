import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:note_app/weatherapps/weather_model.dart';

class WeatherService {
  final String apiKey;
  WeatherService(this.apiKey);

  // ✅ ดึงตำแหน่งปัจจุบัน
  Future<List<double>> getCurrentLocatino() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint(pos.toString());
    return [pos.latitude, pos.longitude];
  }

  // ✅ ดึงสภาพอากาศจากตำแหน่ง (ใช้ GPS)
  Future<Weather> getWeather(List pos, {String units = "metric"}) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${pos[0]}&lon=${pos[1]}&appid=$apiKey&units=$units";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  // ✅ ดึงสภาพอากาศจากชื่อเมืองหรือรหัสไปรษณีย์
  Future<Weather> getWeatherByCityOrZip({
    String? city,
    String? selectedCountry,
    String? zip,
    String? countryCode,
    String units = "metric",
  }) async {
    String url;

    if (zip != null && countryCode != null && zip.isNotEmpty) {
      url =
          "https://api.openweathermap.org/data/2.5/weather?zip=$zip,$countryCode&appid=$apiKey&units=$units";
    } else if (city != null && selectedCountry != null && city.isNotEmpty) {
      url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city,$selectedCountry&appid=$apiKey&units=$units";
    } else {
      throw Exception("กรุณากรอกชื่อเมืองหรือรหัสไปรษณีย์ให้ถูกต้อง");
    }

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("ไม่พบข้อมูลสภาพอากาศสำหรับพารามิเตอร์ที่ให้มา");
    }
  }

  // ✅ เพิ่มฟังก์ชันใหม่: ดึงสภาพอากาศจาก Latitude / Longitude
  Future<Weather> getWeatherByLatLon({
    required double lat,
    required double lon,
    String units = "metric",
  }) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=$units";
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("ไม่พบข้อมูลสภาพอากาศจากพิกัดนี้");
    }
  }
}
