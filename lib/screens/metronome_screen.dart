import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; 

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  int bpm = 120;
  bool isPlaying = false;
  Timer? timer;
  bool tick = false;
  int timeSignature = 4;
  int currentBeat = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  void _toggleMetronome() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _startTimer();
      } else {
        timer?.cancel();
        currentBeat = 0;
        tick = false;
      }
    });
  }

  void _startTimer() {
    timer?.cancel();
    double interval = 60000 / bpm; 
    
    timer = Timer.periodic(Duration(milliseconds: interval.toInt()), (timer) {
      _playTickSound(); 

      setState(() {
        tick = true;
        currentBeat = (currentBeat + 1) % timeSignature;
      });
      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            tick = false;
          });
        }
      });
    });
  }

  Future<void> _playTickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (e) {
      debugPrint("Ses hatası: $e");
    }
  }

  void _changeBPM(int delta) {
    setState(() {
      bpm += delta;
      if (bpm < 40) bpm = 40;
      if (bpm > 240) bpm = 240;
      if (isPlaying) _startTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Metronom"),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tick 
                ? (currentBeat == 1 ? Colors.redAccent : Colors.orangeAccent)
                : Colors.grey[850],
              boxShadow: tick 
                ? [BoxShadow(color: Colors.orange.withOpacity(0.6), blurRadius: 20, spreadRadius: 5)]
                : [],
              border: Border.all(
                color: Colors.grey.shade800,
                width: 4
              )
            ),
            child: Center(
              child: Text(
                "$bpm",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: tick ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "BPM",
            style: TextStyle(color: Colors.grey, fontSize: 16, letterSpacing: 2),
          ),
          
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.remove, () => _changeBPM(-1)),
              const SizedBox(width: 20),
              Slider(
                value: bpm.toDouble(),
                min: 40,
                max: 240,
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.grey[800],
                onChanged: (val) {
                  setState(() {
                    bpm = val.toInt();
                    if (isPlaying) _startTimer();
                  });
                },
              ),
              const SizedBox(width: 20),
              _buildControlButton(Icons.add, () => _changeBPM(1)),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.exposure_minus_1, () => _changeBPM(-10)),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: _toggleMetronome,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isPlaying ? Colors.redAccent : Colors.greenAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isPlaying ? Colors.red : Colors.green).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4)
                      )
                    ]
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop : Icons.play_arrow,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _buildControlButton(Icons.exposure_plus_1, () => _changeBPM(10)),
            ],
          ),
          
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Ölçü: ", style: TextStyle(color: Colors.white, fontSize: 18)),
              DropdownButton<int>(
                value: timeSignature,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
                underline: Container(),
                items: [2, 3, 4, 6].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value/4"),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    timeSignature = val!;
                    currentBeat = 0;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade700)
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}