import 'package:flutter/material.dart';
import 'package:guitarscales/data/scales_data.dart' as ScaleData;
import 'dart:math';

class TrainingScreen extends StatefulWidget {
  final bool isLeftHanded; 
  const TrainingScreen({super.key, required this.isLeftHanded});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int targetIndex = 0;
  String targetNoteName = "";
  int score = 0;
  int totalTries = 0;
  String? feedbackMessage;
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      targetIndex = Random().nextInt(132);
      targetNoteName = ScaleData.allNotes[targetIndex];
      feedbackMessage = null;
    });
  }

  void _checkAnswer(String selectedNote) {
    setState(() {
      totalTries++;
      if (selectedNote == targetNoteName) {
        score++;
        feedbackMessage = "Doğru! 🎉";
        feedbackColor = Colors.green;
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) _nextQuestion();
        });
      } else {
        feedbackMessage = "Yanlış, o $targetNoteName idi.";
        feedbackColor = Colors.redAccent;
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) _nextQuestion();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> answerOptions = [
      "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Nota Ezberlemece"),
        backgroundColor: Colors.black87,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Skor: $score / $totalTries", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: widget.isLeftHanded, 
                child: Container(
                  color: const Color(0xFF3E2723),
                  width: 22 * 60.0,
                  height: 250,
                  child: GridView.builder(
                    reverse: widget.isLeftHanded, 
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 132,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 22,
                      mainAxisExtent: 250 / 6,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 22;
                      int col = index % 22;
                      bool isTarget = (index == targetIndex);

                      bool isSingleDot = [3, 5, 7, 9, 15, 17, 19, 21].contains(col);
                      bool isDoubleDot = col == 12;
                      bool showDot = false;
                      if (isSingleDot && row == 3) showDot = true;
                      if (isDoubleDot && (row == 1 || row == 4)) showDot = true;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade400, width: 2.5),
                            left: col == 0 
                              ? const BorderSide(color: Colors.white, width: 6) 
                              : BorderSide.none,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (showDot)
                              Container(
                                width: 20, height: 20,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), shape: BoxShape.circle),
                              ),
                            Container(
                              height: 1.0 + row * 0.7,
                              color: const Color(0xFFBCAAA4),
                              width: double.infinity,
                            ),
                            if (isTarget)
                              Container(
                                width: 32, height: 32,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 2)]
                                ),
                                child: const Center(
                                  child: Text("?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (feedbackMessage != null)
                    Text(feedbackMessage!, style: TextStyle(color: feedbackColor, fontSize: 24, fontWeight: FontWeight.bold))
                  else
                    const Text("İşaretli nota hangisi?", style: TextStyle(color: Colors.white, fontSize: 20)),
                  
                  const Spacer(),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: answerOptions.map((note) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[700], padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                        onPressed: feedbackMessage == null ? () => _checkAnswer(note) : null,
                        child: Text(note, style: const TextStyle(fontSize: 18, color: Colors.white)),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}