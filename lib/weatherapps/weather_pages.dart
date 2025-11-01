import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/weatherapps/weather_model.dart';
import 'package:note_app/weatherapps/weather_service.dart';

class WeatherPages extends StatefulWidget {
  const WeatherPages({super.key});

  @override
  State<WeatherPages> createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPages> {
  final _weatherService = WeatherService("eaf66ff29ddd3ee2dff987b8ed555ab7");
  Weather? _weather;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  String _selectedCountry = "Thailand";
  String _selectedUnit = "metric";

  // ✅ เพิ่มตัวแปรนี้เพื่อเก็บโหมดที่เลือกจาก Drawer
  String _mode = "current"; // current | cityZip | latLon

  final List<String> _countries = [
    "Thailand",
    "Japan",
    "United States",
    "United Kingdom",
    "France",
    "Germany",
  ];

  final Map<String, String> _countryCodes = {
    "Thailand": "TH",
    "Japan": "JP",
    "United States": "US",
    "United Kingdom": "GB",
    "France": "FR",
    "Germany": "DE",
  };

  final Map<String, String> _unitLabels = {
    "metric": "เซลเซียส (°C)",
    "imperial": "ฟาเรนไฮต์ (°F)",
    "standard": "เคลวิน (K)",
  };

  static TextStyle textStyle = GoogleFonts.roboto(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  // ✅ ดึงข้อมูลตาม city / zip
  Future<void> _fetchWeather() async {
    final city = _cityController.text.trim();
    final zip = _zipController.text.trim();

    if (city.isEmpty && zip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกชื่อเมืองหรือรหัสไปรษณีย์")),
      );
      return;
    }

    try {
      final weather = await _weatherService.getWeatherByCityOrZip(
        city: city.isNotEmpty ? city : null,
        zip: zip.isNotEmpty ? zip : null,
        selectedCountry: _selectedCountry,
        countryCode: _countryCodes[_selectedCountry],
        units: _selectedUnit,
      );

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่พบข้อมูล หรือเกิดข้อผิดพลาด")),
      );
    }
  }

  // ✅ ดึงข้อมูลตาม Latitude / Longitude
  Future<void> _fetchWeatherByLatLon() async {
    final latText = _latController.text.trim();
    final lonText = _lonController.text.trim();

    if (latText.isEmpty || lonText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอก Latitude และ Longitude")),
      );
      return;
    }

    try {
      final lat = double.parse(latText);
      final lon = double.parse(lonText);

      final weather = await _weatherService.getWeather([
        lat,
        lon,
      ], units: _selectedUnit);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่พบข้อมูลพิกัดนี้ หรือเกิดข้อผิดพลาด")),
      );
    }
  }

  // ✅ ดึงตำแหน่งปัจจุบัน
  Future<void> _fetchCurrentLocationWeather() async {
    try {
      final pos = await _weatherService.getCurrentLocatino();
      final weather = await _weatherService.getWeather(
        pos,
        units: _selectedUnit,
      );

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่สามารถเข้าถึงตำแหน่งของคุณได้")),
      );
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/lotties/loading.json";
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "fog":
      case "mist":
      case "smoke":
      case "dust":
      case "haze":
        return "assets/lotties/cloudy.json";
      case "rain":
      case "dizzle":
      case "shower rain":
        return "assets/lotties/rainy.json";
      case "thunderstorm":
        return "assets/lotties/thunder.json";
      default:
        return "assets/lotties/sunny.json";
    }
  }

  String getUnitSymbol() {
    switch (_selectedUnit) {
      case "metric":
        return "°C";
      case "imperial":
        return "°F";
      case "standard":
        return "K";
      default:
        return "°C";
    }
  }

  Widget _buildForm() {
    switch (_mode) {
      case "cityZip":
        return Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "ชื่อเมือง",
                hintText: "เช่น Bangkok, Tokyo",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _zipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "รหัสไปรษณีย์ (ไม่บังคับ)",
                hintText: "เช่น 10110",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              items: _countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCountry = v!),
              decoration: InputDecoration(
                labelText: "เลือกประเทศ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text("ดูสภาพอากาศ"),
            ),
          ],
        );

      case "latLon":
        return Column(
          children: [
            TextField(
              controller: _latController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Latitude (ละติจูด)",
                hintText: "เช่น 13.7563",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lonController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Longitude (ลองจิจูด)",
                hintText: "เช่น 100.5018",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _fetchWeatherByLatLon,
              child: const Text("ดูสภาพอากาศจากพิกัด"),
            ),
          ],
        );

      case "current":
      default:
        return Column(
          children: [
            const Text("กดปุ่มด้านล่างเพื่อดูสภาพอากาศจากตำแหน่งปัจจุบัน"),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _fetchCurrentLocationWeather,
              child: const Text("ดูสภาพอากาศปัจจุบัน"),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌤 Weather App"), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "🔍 เลือกวิธีดูสภาพอากาศ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text("ตำแหน่งปัจจุบัน"),
              onTap: () {
                setState(() => _mode = "current");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text("ชื่อเมือง / รหัสไปรษณีย์"),
              onTap: () {
                setState(() => _mode = "cityZip");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("พิกัด Latitude / Longitude"),
              onTap: () {
                setState(() => _mode = "latLon");
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text("กลับไป Note App"),
              onTap: () {
                Navigator.pop(context); // ปิด Drawer
                Navigator.pop(context); // กลับไป Note App
                // หรือถ้า Note App ยังไม่อยู่ใน stack:
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NoteAppPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                items: _unitLabels.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedUnit = v!),
                decoration: InputDecoration(
                  labelText: "เลือกหน่วยอุณหภูมิ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildForm(),
              const SizedBox(height: 30),
              if (_weather != null) ...[
                Text("${_weather!.cityName}", style: textStyle),
                const SizedBox(height: 15),
                Lottie.asset(
                  getWeatherAnimation(_weather!.mainCondition),
                  width: 250,
                  height: 250,
                ),
                Text(
                  "${_weather!.temperature.round()} ${getUnitSymbol()}",
                  style: textStyle,
                ),
                const SizedBox(height: 10),
                Text(_weather!.mainCondition, style: textStyle),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
