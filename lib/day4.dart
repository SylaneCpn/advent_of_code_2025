import 'dart:io';

int _countAdjacentPaper(
  List<String>? prevLine,
  List<String> currentLine,
  List<String>? nextLine,
  int currentIndex,
) {
  int count = 0;

  //count on prevLine
  if (prevLine != null) {
    for (int i = currentIndex - 1; i < currentIndex + 2; i++) {
      //check if the element is indexable
      if (i >= 0) {
        final char = prevLine.elementAtOrNull(i) ?? "";
        if (char == "@") count++;
      }
    }
  }

  //count current line
  for (int i = currentIndex - 1; i < currentIndex + 2; i++) {
    //check if the element is indexable and it's not the current TP
    if (i >= 0 && i != currentIndex) {
      final char = currentLine.elementAtOrNull(i) ?? "";
      if (char == "@") count++;
    }
  }

  // count next line
  if (nextLine != null) {
    for (int i = currentIndex - 1; i < currentIndex + 2; i++) {
      //check if the element is indexable
      if (i >= 0) {
        final char = nextLine.elementAtOrNull(i) ?? "";
        if (char == "@") count++;
      }
    }
  }

  return count;
}

int day4p1() {
  final lines = File("input/day4.sylc").readAsLinesSync();
  int accessible = 0;
  for (int l = 0; l < lines.length; l++) {
    final prev = (l - 1) < 0 ? null : lines.elementAt(l - 1).split("");
    final current = lines.elementAt(l).split("");
    final next = lines.elementAtOrNull(l + 1)?.split("");

    // ignore chars that are not "@"
    for (final (paperIndex, _) in current.indexed.where(
      (indxd) => indxd.$2 == "@",
    )) {
      // if less than 4 adjacent paper , we can say we removed it
      if (_countAdjacentPaper(prev, current, next, paperIndex) < 4)
      {
        accessible++;
      }
    }
  }

  return accessible;
}

int day4p2() {
  // The first iteration
  List<String> currentlines = File("input/day4.sylc").readAsLinesSync();
  int accessible = 0;

  // Will break once we can update the rows 
  for(;;) {
    // This we be the rows for the next iteration
    final newLines = <String>[];
    // How much we removed in the current iteration
    int localAccessible = 0;

    // Just like first part, we will iterate on the rows of the current iteration
    for (int l = 0; l < currentlines.length; l++) {
      
      final prev = (l - 1) < 0 ? null : currentlines.elementAt(l - 1).split("");
      final current = currentlines.elementAt(l).split("");
      final next = currentlines.elementAtOrNull(l + 1)?.split("");

      // This will be the row for the next iteration
      final newLine = List.filled(current.length, ".");

      // ignore chars that are not "@"
      for (final (paperIndex, _) in current.indexed.where(
        (indxd) => indxd.$2 == "@",
      )) {
        // Say we took it
        if (_countAdjacentPaper(prev, current, next, paperIndex) < 4)
        {
          localAccessible++;
        }

        // There was a "@" but , it wasn't accessible so we keep it for the next iteration
        else {
          newLine[paperIndex] = "@";
        }
      }

      // Add the updated row for the next iteration
      newLines.add(newLine.join());
    }

    // No changes have been made, we converged to the solution 
    if (localAccessible == 0) {
      break;
    }
    // Add the taken "@" to the global counter
    accessible += localAccessible;
    // Update the rows for the next iteration
    currentlines = newLines;
  }
  

  return accessible;
}