class MusicLogic {
  static List rotatePattern(int shiftAmount, List originalList) {
    return originalList.map((innerList) {
      final newInnerList = List.from(innerList); 
      
      if (shiftAmount > 0) {
        for (var i = 0; i < shiftAmount.abs(); i++) {
          newInnerList.insert(0, newInnerList.removeLast());
        }
      } else if (shiftAmount < 0) {
        for (var i = 0; i < shiftAmount.abs(); i++) { 
           if (newInnerList.isNotEmpty) {
             newInnerList.add(newInnerList.removeAt(0));
           }
        }
      }
      return newInnerList;
    }).toList();
  }

  static List<int> flattenSelectionList(List<dynamic> list2D) {
    List<int> flatList = [];
    for (var sublist in list2D) {
      flatList.addAll(List<int>.from(sublist));
    }
    return flatList;
  }
}