import 'package:flutter/material.dart';

class ChordsScreen extends StatelessWidget {
  const ChordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Akor Kütüphanesi")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_music, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Yakında buraya akorlar gelecek..."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              }, 
              child: const Text("Akor Ekle")
            )
          ],
        ),
      ),
    );
  }
}