import 'dart:io';

class _Range {
  int begin;
  int end;

  _Range({required this.begin, required this.end});

  int numberOfValues() => end - begin + 1;

  factory _Range.rangeFromString(String input) {
    final [begin, end] = input.split("-");
    return _Range(begin: int.parse(begin), end: int.parse(end));
  }

  @override
  String toString() => "[$begin;$end]";
}

int day5p1() {
  final input = File("input/day5.sylc").readAsStringSync();
  // Split input between the two part : Ranges and Ids
  final [rangeInput, idsInput] = input.split(RegExp(r"\r?\n\s*\r?\n"));

  final ranges = rangeInput.split("\n").map(_Range.rangeFromString);
  final ids = idsInput.split("\n");

  int freshCount = 0;
  for (final id in ids) {
    final idAsInt = int.parse(id);
    if (ranges.any((r) => (idAsInt >= r.begin) && (idAsInt <= r.end))) {
      freshCount++;
    }
  }

  return freshCount;
}

// Brute force , take way too long but should work ?
int day5p2BruteForce() {
  final input = File("input/day5.sylc").readAsStringSync();
  // Split input between the two part : Ranges and Ids
  final [rangeInput, idsInput] = input.split(RegExp(r"\r?\n\s*\r?\n"));

  final ranges = rangeInput.split("\n").map(_Range.rangeFromString);
  final validIds = <int>{};

  for (final _Range(:begin, :end) in ranges) {
    for (int i = begin; i <= end; i++) {
      validIds.add(i);
    }
  }

  return validIds.length;
}

int day5p2() {
  final input = File("input/day5.sylc").readAsStringSync();
  // Split input between the two part : Ranges and Ids
  final [rangeInput, idsInput] = input.split(RegExp(r"\r?\n\s*\r?\n"));

  final ranges = rangeInput.split("\n").map(_Range.rangeFromString).toList();
  
  //Sort ranges by begin
  ranges.sort((a, b) {
    return Comparable.compare(a.begin, b.begin);
  });

  //first range
  final spans = [ranges[0]];

  // Iterate over the other ranges
  for (final range in ranges.skip(1)) {
    // if the begin range is superior to the end of the 
    // last, add it to the spans making an union.
    // This should not append while the begin attribute 
    // is still the same.
    if (spans.last.end < range.begin) {
      spans.add(range);
    }

    // This ensures that will have the maimum span for
    // a given begin attribute. It we do change begin attribute 
    // but it's still below the end one, this will extend the span.
    // Note this is possible because we sorted the ranges. 
    else if (spans.last.end < range.end) {
      spans.last.end = range.end;
    }
  }

  return spans.fold(0, (acc, value) => acc + value.numberOfValues());
}
