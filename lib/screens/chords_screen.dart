import 'package:flutter/material.dart';
import 'package:guitarscales/data/chords_data.dart';

class ChordsScreen extends StatefulWidget {
  final bool isLeftHanded; 

  const ChordsScreen({super.key, required this.isLeftHanded});

  @override
  State<ChordsScreen> createState() => _ChordsScreenState();
}

class _ChordsScreenState extends State<ChordsScreen> {
  String selectedRoot = "C";
  String selectedType = "Major";
  List<int> currentFrets = [-1, 3, 2, 0, 1, 0];

  final List<String> roots = [
    "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
  ];
  
  final List<String> types = [
    "Major", "Minor", "7", "Major7", "Minor7"
  ];

  void _updateChord() {
    setState(() {
      if (ChordData.chordLibrary.containsKey(selectedRoot) &&
          ChordData.chordLibrary[selectedRoot]!.containsKey(selectedType)) {
        currentFrets = ChordData.chordLibrary[selectedRoot]![selectedType]!;
      } else {
        currentFrets = [-1, -1, -1, -1, -1, -1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        title: const Text("Akor Kütüphanesi"),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedRoot,
                    isExpanded: true,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    items: roots.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      selectedRoot = val!;
                      _updateChord();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    items: types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      selectedType = val!;
                      _updateChord();
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$selectedRoot $selectedType",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                  if (widget.isLeftHanded)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text("(Solak Görünüm)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  const SizedBox(height: 20),
                  
                  Container(
                    width: 220,
                    height: 280,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)]
                    ),
                    child: CustomPaint(
                      painter: ChordPainter(currentFrets, isLeftHanded: widget.isLeftHanded),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChordPainter extends CustomPainter {
  final List<int> frets;
  final bool isLeftHanded; 

  ChordPainter(this.frets, {required this.isLeftHanded});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()..color = Colors.black..strokeWidth = 2;
    final paintString = Paint()..color = Colors.grey[800]!..strokeWidth = 1.5;
    final paintDot = Paint()..color = Colors.black..style = PaintingStyle.fill;
    
    double w = size.width;
    double h = size.height;
    double stringSpacing = w / 5;
    double fretSpacing = h / 5;

    for (int i = 0; i <= 5; i++) {
      double y = i * fretSpacing;
      if (i == 0) {
        canvas.drawLine(Offset(0, y), Offset(w, y), Paint()..color = Colors.black..strokeWidth = 6);
      } else {
        canvas.drawLine(Offset(0, y), Offset(w, y), paintLine);
      }
    }

    for (int i = 0; i < 6; i++) {
      int visualIndex = isLeftHanded ? (5 - i) : i;
      
      double x = visualIndex * stringSpacing;
      
      canvas.drawLine(Offset(x, 0), Offset(x, h), paintString);

      int fret = frets[i];
      if (fret == -1) {
        _drawText(canvas, "X", Offset(x, -20), const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold));
      } else if (fret == 0) {
        _drawText(canvas, "O", Offset(x, -20), const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold));
      } else {
        double noteY = (fret > 5 ? (fret % 5 == 0 ? 5 : fret % 5) : fret) * fretSpacing - (fretSpacing / 2);
        
        if (fret <= 5) {
           canvas.drawCircle(Offset(x, noteY), 10, paintDot);
        } else {
           canvas.drawCircle(Offset(x, h - (fretSpacing/2)), 12, paintDot);
           _drawText(canvas, "$fret", Offset(x, h - (fretSpacing/2)), const TextStyle(color: Colors.white, fontSize: 10));
        }
      }
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}