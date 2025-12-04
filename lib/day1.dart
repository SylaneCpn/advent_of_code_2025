import 'dart:io';

enum Rotation {
  left,
  right;

  static Rotation fromString(String input) {
    return switch (input) {
      "L" => .left,
      "R" => .right,
      _ => throw Exception(
        "$input can't be parsed to a Rotation; Try \"L\" or \"R\".",
      ),
    };
  }
}

int day1p1() {
  final inputAsLines = File("input/day1.sylc").readAsLinesSync();
  int zeros = 0;
  int currentDial = 50;
  for (final line in inputAsLines) {
    final [rotationAsString, ...distanceDigits] = line.split("");

    final rotation = Rotation.fromString(rotationAsString);
    final distance = int.parse(distanceDigits.join(""));

    currentDial = switch (rotation) {
      .right => (currentDial + distance) % 100,
      .left => (currentDial - distance) % 100,
    };

    if (currentDial == 0) zeros++;
  }

  return zeros;
}

int day1p2() {
  final inputAsLines = File("input/day1.sylc").readAsLinesSync();
  int passedZeros = 0;
  int currentDial = 50;

  for (final line in inputAsLines) {
    final [rotationAsString, ...distanceDigits] = line.split("");

    final rotation = Rotation.fromString(rotationAsString);
    final distance = int.parse(distanceDigits.join(""));

    passedZeros += _zeroPassed(currentDial, rotation, distance);

    currentDial = switch (rotation) {
      .right => (currentDial + distance) % 100,
      .left => (currentDial - distance) % 100,
    };
  }

  return passedZeros;
}

int _zeroPassed(int dial, Rotation rot, int distance) {
  final noModulusNewDial = switch (rot) {
    .right => dial + distance,
    .left => dial - distance,
  };

  //case where the rotation is just enough
  if (noModulusNewDial == 0) return 1;

  // case where the new dial should go below zero,
  // in that case add one to accont for the sign switch
  final changedSign = (noModulusNewDial < 0 && dial != 0) ? 1 : 0;
  return noModulusNewDial.abs() ~/ 100 + changedSign;
}
