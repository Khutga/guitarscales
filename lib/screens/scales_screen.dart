import 'package:flutter/material.dart';
import 'package:guitarscales/data/scales_data.dart' as ScaleData;
import '../utils/logic.dart';

class ScalesScreen extends StatefulWidget {
  const ScalesScreen({super.key});

  @override
  State<ScalesScreen> createState() => _ScalesScreenState();
}

class _ScalesScreenState extends State<ScalesScreen> {
  List<int> selectedNotesFlat = [];
  String currentScaleName = "Pentatonic Minor";

  @override
  void initState() {
    super.initState();
    _updateScale(ScaleData.pentatonicMinor, 0, "Pentatonic Minor");
  }

  void _updateScale(List sourceList, int shift, String name) {
    List shiftedList = MusicLogic.rotatePattern(shift, sourceList);
    setState(() {
      selectedNotesFlat = MusicLogic.flattenSelectionList(shiftedList);
      currentScaleName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentScaleName),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text('Gam Seçimi', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Pentatonic Minor'),
              onTap: () {
                _updateScale(ScaleData.pentatonicMinor, 0, 'Pentatonic Minor');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Major Scale'),
              onTap: () {
                _updateScale(ScaleData.majorScale, 0, 'Major Scale');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Dorian Mode'),
              subtitle: const Text('Major -2 offset'),
              onTap: () {
                _updateScale(ScaleData.majorScale, -2, 'Dorian');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: 22 * 50.0, 
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 132, 
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 22,
                      mainAxisExtent: (MediaQuery.of(context).size.height - 180) / 6,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemBuilder: (context, index) {
                      bool isSelected = false;
                      if (index < selectedNotesFlat.length) {
                         isSelected = selectedNotesFlat[index] == 1;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[300], 
                          border: Border.all(color: Colors.grey.shade800),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Divider(
                                color: Colors.grey[800], 
                                thickness: 2
                              ),
                              if (isSelected)
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black26)]
                                  ),
                                  child: Center(
                                    child: Text(
                                      ScaleData.allNotes[index],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
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