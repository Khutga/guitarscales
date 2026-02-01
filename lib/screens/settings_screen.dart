import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isLeftHanded;
  final ValueChanged<bool> onLeftHandedChanged;

  const SettingsScreen({
    super.key,
    required this.isLeftHanded,
    required this.onLeftHandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Ayarlar"),
        backgroundColor: Colors.black87,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Solak Modu", style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              "Klavye ve akor görünümlerini solaklar için ters çevirir.",
              style: TextStyle(color: Colors.grey),
            ),
            activeColor: Colors.orangeAccent,
            value: isLeftHanded,
            onChanged: onLeftHandedChanged,
            secondary: const Icon(Icons.back_hand, color: Colors.orangeAccent),
          ),
        ],
      ),
    );
  }
}