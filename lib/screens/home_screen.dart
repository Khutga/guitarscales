import 'package:flutter/material.dart';
import 'scales_screen.dart';
import 'chords_screen.dart';
import 'metronome_screen.dart';
import 'training_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isLeftHanded = false; 

  void _toggleLeftHanded(bool value) {
    setState(() {
      isLeftHanded = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ScalesScreen(isLeftHanded: isLeftHanded),
      ChordsScreen(isLeftHanded: isLeftHanded),
      TrainingScreen(isLeftHanded: isLeftHanded),
      const MetronomeScreen(),
      SettingsScreen(isLeftHanded: isLeftHanded, onLeftHandedChanged: _toggleLeftHanded),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.orangeAccent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.black87,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.graphic_eq, color: Colors.grey),
              selectedIcon: Icon(Icons.graphic_eq, color: Colors.black),
              label: 'Gamlar',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note, color: Colors.grey),
              selectedIcon: Icon(Icons.music_note, color: Colors.black),
              label: 'Akorlar',
            ),
             NavigationDestination(
              icon: Icon(Icons.school, color: Colors.grey),
              selectedIcon: Icon(Icons.school, color: Colors.black),
              label: 'Egzersiz',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer, color: Colors.grey),
              selectedIcon: Icon(Icons.timer, color: Colors.black),
              label: 'Metronom',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings, color: Colors.grey),
              selectedIcon: Icon(Icons.settings, color: Colors.black),
              label: 'Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
}