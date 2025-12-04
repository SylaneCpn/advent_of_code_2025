import 'dart:io';

bool _isIdInvalidP1(int id) {
  final digits = id.toString().split("");
  for (int i = 0; i < digits.length; i++) {
    final firstPart = digits.sublist(0, i).join("");
    final secondPart = digits.sublist(i, digits.length).join("");
    if (firstPart == secondPart) return true;
  }
  return false;
}

List<int> _invalidIdsInRangeP1(int begin, int end) {
  final invalidIds = <int>[];
  for (int id = begin; id <= end; id++) {
    if (_isIdInvalidP1(id)) {
      invalidIds.add(id);
    }
  }
  return invalidIds;
}

int day2p1() {
  final input = File("input/day2.sylc").readAsStringSync();
  final ids = input.split(",");
  return ids
      .expand((range) {
        final [begin, end] = range.split("-");
        return _invalidIdsInRangeP1(int.parse(begin), int.parse(end));
      })
      .fold(0, (acc, e) => acc + e);
}

Iterable<int> _multiplesFromHalfRange(int range) sync* {
  for (int i = 1; i <= range ~/ 2; i++) {
    if (range % i == 0) yield i;
  }
}

extension SpiltEven on String {
  List<String> splitEven(int charNum) {
    final out = <String>[];
    for (int i = 0; i < length; i += charNum) {
      out.add(substring(i, i + charNum));
    }
    return out;
  }
}

bool _isIdInvalidP2(int id) {
  final digits = id.toString().split("");
  final subpatterns = _multiplesFromHalfRange(
    digits.length,
  ).map((m) => digits.sublist(0, m).join()).toList();
  for (final subpattern in subpatterns) {
    if (id
        .toString()
        .splitEven(subpattern.length)
        .every((idPart) => idPart == subpattern)) {
      return true;
    }
  }

  return false;
}

List<int> _invalidIdsInRangeP2(int begin, int end) {
  final invalidIds = <int>[];
  for (int id = begin; id <= end; id++) {
    if (_isIdInvalidP2(id)) {
      invalidIds.add(id);
    }
  }
  return invalidIds;
}

int day2p2() {
  final input = File("input/day2.sylc").readAsStringSync();
  final ids = input.split(",");
  return ids
      .expand((range) {
        final [begin, end] = range.split("-");
        return _invalidIdsInRangeP2(int.parse(begin), int.parse(end));
      })
      .fold(0, (acc, e) => acc + e);
}
