import 'package:flutter/material.dart';
import 'package:groq/groq.dart';
import 'dart:core';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({super.key});

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  TextEditingController _tahunLahir = TextEditingController();
  int _usia = 0;
  String? _message = "";

  void hitungUsia() {
    int tahunLahir = int.parse(_tahunLahir.text);
    // int usia = 2025 - tahunLahir;
    int usia = DateTime.now().year - tahunLahir;
    setState(() {
      _usia = usia;
    });
  }

  Future<void> _sendMessage() async {
    final _groq = Groq(
      apiKey: "YOUR_API_KEY",
    );
    _groq.startChat();
    try {
      GroqResponse response = await _groq.sendMessage(
          "Berikan saya 3 fakta tentang teknologi di tahun ${_tahunLahir.text.toString()}");
      setState(() {
        _message = response.choices.first.message.content.toString();
      });
    } on GroqException catch (error) {
      print("ERROR CUY");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tahunLahir.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "AGEFACTAI",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 32.0, right: 32),
        children: [
          // Title section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "HITUNG USIA",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),
          
          // Input TextField for Year of Birth
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _tahunLahir,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Masukan tahun lahir',
                labelText: 'Tahun Lahir',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          
          // Calculate Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                if (_tahunLahir.text.isNotEmpty) {
                  hitungUsia();
                  _sendMessage();
                }
              },
              child: Text(
                "Hitung",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),

          // Display the results if the year of birth is entered
          if (_tahunLahir.text.isNotEmpty && _usia != 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hasil Perhitungan:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    Text("Tahun lahir: ${_tahunLahir.text}",
                        style: TextStyle(fontSize: 16)),
                    Text("Usia anda: $_usia", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

          // Display the message from Groq if available
          if (_message != null && _message!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                _message!,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
