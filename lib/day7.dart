import 'dart:io';

int day7p1() {
  final input = File(
    "input/day7.sylc",
  ).readAsLinesSync().map((l) => l.split("")).toList();

  final startingPosition = input[0].indexOf("S");
  int splitCount = 0;
  Set<int> tachionPosition = {startingPosition};
  for (final row in input.skip(1)) {
    final newTachionPosition = <int>{};
    for (final position in tachionPosition) {
      if (row[position] == ".") {
        newTachionPosition.add(position);
      } else if (row[position] == "^") {
        newTachionPosition.add(position - 1);
        newTachionPosition.add(position + 1);
        splitCount++;
      }
    }
    tachionPosition = newTachionPosition;
  }

  return splitCount;
}


int day7p2() {
  final input = File(
    "input/day7.sylc",
  ).readAsLinesSync().map((l) => l.split("")).toList();

  //Initial tachion
  final startingPosition = input[0].indexOf("S");

  // Count how many tachions would pass a givien position for a given row
  // The key maps to the position in the row
  // The value tells how many tachions are for a given position on the row
  Map<int,int> tachionPosition = {startingPosition : 1};
  //For each row in the mainfold
  for (final row in input.skip(1)) {
    // The next iteration of tachions, on the next row.
    final newTachionPosition = <int,int>{};
    // For each previous tachion, calculate xhere the next one will go
    for (final MapEntry(key :position , value : count) in tachionPosition.entries) {
      // If "." the next tachions at this position will go at the the same position
      if (row[position] == ".") {
        newTachionPosition[position] = (newTachionPosition[position] ?? 0) + count;
      // Else if on the split char double the number of tachions, with half on the left
      // And the other Half on the right.
      } else if (row[position] == "^") {
        newTachionPosition[position - 1] = (newTachionPosition[position - 1] ?? 0) + count;
        newTachionPosition[position + 1] = (newTachionPosition[position + 1] ?? 0) + count;
      }
    }
    // Update the tachions for the next iteration
    tachionPosition = newTachionPosition;
  }

  // Sum all of the generated tachions, those are the number of universes.
  return tachionPosition.values.fold(0, (acc,elem) => acc + elem);
}

