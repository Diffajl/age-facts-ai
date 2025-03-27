import 'package:flutter/material.dart';
import 'package:groq/groq.dart';
import 'dart:core';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  TextEditingController _tahunLahir = TextEditingController();
  int _usia = 0;
  String? _message = "";

  void hitungUsia() {
    int tahunLahir = int.parse(_tahunLahir.text);
    int usia = DateTime.now().year - tahunLahir;
    setState(() {
      _usia = usia;
    });
  }

  Future<void> _sendMessage() async {
    final _groq = Groq(
      apiKey: "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",
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
        title: Text(
          "AGEFACTAI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800), // Limit max width for large screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      "HITUNG USIA",
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ),

                // Input TextField for Year of Birth
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: _tahunLahir,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Masukan tahun lahir',
                      labelText: 'Tahun Lahir',
                      prefixIcon: Icon(Icons.calendar_today),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                // Calculate Button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                      ),
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
                                fontSize: 20,
                                color: Colors.blue.shade700),
                          ),
                          SizedBox(height: 8),
                          Text("Tahun lahir: ${_tahunLahir.text}",
                              style: TextStyle(fontSize: 18)),
                          Text("Usia anda: $_usia", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),

                // Display the message from Groq if available
                if (_message != null && _message!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      _message!,
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
