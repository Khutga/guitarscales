import 'package:flutter/material.dart';
import 'package:guitarscales/data/scales_data.dart' as ScaleData;
import '../utils/logic.dart';

class ScalesScreen extends StatefulWidget {
  final bool isLeftHanded;

  const ScalesScreen({super.key, required this.isLeftHanded});

  @override
  State<ScalesScreen> createState() => _ScalesScreenState();
}

class _ScalesScreenState extends State<ScalesScreen> {
  final Map<String, List> scalesMap = {
    "Pentatonic Minor": ScaleData.pentatonicMinor,
    "Major Scale": ScaleData.majorScale,
    "Harmonic Minor": ScaleData.HarmonicMinor,
    "Melodic Minor": ScaleData.MelodicMinor,
    "Diminished": ScaleData.Diminished,
    "Blues": ScaleData.pentatonicblues,
  };

  final List<String> rootNotes = [
    "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#"
  ];

  List<int> selectedNotesFlat = [];
  String selectedScaleName = "Pentatonic Minor";
  String selectedRootNote = "E";

  @override
  void initState() {
    super.initState();
    _updateDisplay();
  }

  void _updateDisplay() {
    List sourceList = scalesMap[selectedScaleName]!;
    int shiftAmount = rootNotes.indexOf(selectedRootNote);
    List shiftedList = MusicLogic.rotatePattern(shiftAmount, sourceList);
    
    setState(() {
      selectedNotesFlat = MusicLogic.flattenSelectionList(shiftedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black87,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Ton", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        DropdownButton<String>(
                          value: selectedRootNote,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          underline: Container(height: 2, color: Colors.orangeAccent),
                          items: rootNotes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedRootNote = newValue!;
                              _updateDisplay();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gam", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        DropdownButton<String>(
                          value: selectedScaleName,
                          isExpanded: true,
                          dropdownColor: Colors.grey[900],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          underline: Container(height: 2, color: Colors.blueAccent),
                          items: scalesMap.keys.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedScaleName = newValue!;
                              _updateDisplay();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: widget.isLeftHanded, 
                child: Container(
                  color: const Color(0xFF3E2723), 
                  width: 22 * 60.0,
                  child: GridView.builder(
                    reverse: widget.isLeftHanded, 
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 132,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 22,
                      mainAxisExtent: (MediaQuery.of(context).size.height - 150) / 6,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ 22;
                      int col = index % 22;
                      bool isSelected = false;
                      
                      if (index < selectedNotesFlat.length) {
                         isSelected = selectedNotesFlat[index] == 1;
                      }

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
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Container(
                              height: 1.0 + row * 0.7,
                              color: const Color(0xFFBCAAA4),
                              width: double.infinity,
                            ),
                            if (isSelected)
                              Container(
                                width: 28, height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 4, offset: const Offset(0, 2))
                                  ]
                                ),
                                child: Center(
                                  child: Text(
                                    ScaleData.allNotes[index],
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                                  ),
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
          ],
        ),
      ),
    );
  }
}