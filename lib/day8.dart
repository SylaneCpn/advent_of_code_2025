import 'dart:io';
import 'dart:math';

// A Junction Box Position
class Box {
  final int x;
  final int y;
  final int z;

  const Box(this.x, this.y, this.z);

  // Distance between two boxes
  double distanceFrom(Box other) {
    final dx = other.x - x;
    final dy = other.y - y;
    final dz = other.z - z;

    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  // Utility function, parses a Bow from an input line
  factory Box.fromString(String input) {
    final [x, y, z] = input.split(",").map(int.parse).toList();
    return Box(x, y, z);
  }

  @override
  String toString() {
    return "[$x ,$y ,$z]";
  }
}

// Represents a junction between to boxes. Where b1 and b2 are indexes
// in a List containing all the the Junction boxes
class Junction {
  final int b1;
  final int b2;

  Junction(this.b1, this.b2);
}

//Update the connections gruops and merge them if needed.
void _unionise(List<Set<int>> connections, int b1, int b2) {
  final c1 = connections.indexWhere((conn) => conn.contains(b1));
  final c2 = connections.indexWhere((conn) => conn.contains(b2));
  // Two groups already contains the boxes, merge the two groups
  if (c1 != -1 && c2 != -1) {
    if (c1 != c2) {
      final conn2 = connections[c2];
      connections[c1].addAll(conn2);
      connections.removeAt(c2);
    }
  }
  // A group contains one of the box, add the other box to
  // this group
  else if (c1 != -1 && c2 == -1) {
    connections[c1].add(b2);
  } else if (c1 == -1 && c2 != -1) {
    connections[c2].add(b1);
  }
  // This is a new pair,create it
  else {
    connections.add({b1, b2});
  }
}

//Get all the distances combinaison between the boxs and sorts them
// by distances
List<Junction> _calculateDistances(List<Box> boxes) {
  final dists = <Junction>[];
  for (int i = 0; i < boxes.length; i++) {
    for (int j = i + 1; j < boxes.length; j++) {
      dists.add(Junction(i, j));
    }
  }

  // Sort by shortest junction
  return dists..sort(
    (a, b) => Comparable.compare(
      boxes[a.b1].distanceFrom(boxes[a.b2]),
      boxes[b.b1].distanceFrom(boxes[b.b2]),
    ),
  );
}

int day8p1() {
  final input = File("input/day8.sylc").readAsLinesSync();
  final boxes = input.map(Box.fromString).toList();

  final distances = _calculateDistances(boxes);
  final List<Set<int>> connections = [];
  //Because the input is 1000 lines long
  for (int i = 0; i < boxes.length; i++) {
    final Junction(:b1, :b2) = distances[i];
    _unionise(connections, b1, b2);
  }
  // Sort by set len
  connections.sort((a, b) => Comparable.compare(b.length, a.length));
  // Product of 3 largest
  return connections.take(3).fold(1, (acc, element) => acc * element.length);
}

int day8p2() {
  final input = File("input/day8.sylc").readAsLinesSync();
  final boxes = input.map(Box.fromString).toList();

  final distances = _calculateDistances(boxes);
  final List<Set<int>> connections = [];
  for (int i = 0; i < distances.length; i++) {
    final Junction(:b1, :b2) = distances[i];
    _unionise(connections, b1, b2);
    // All boxes are connected
    if (connections[0].length == boxes.length) {
      return boxes[b1].x * boxes[b2].x;
    }
  }

  return 0;
}
