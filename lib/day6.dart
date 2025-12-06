import 'dart:io';

int day6p1() {
  final input = File("input/day6.sylc").readAsLinesSync();
  // Numbers of problems
  final columnCount = input[0].split(RegExp(r"\s+")).length;
  // Number of operations for a single problem
  final linesCount = input.length;

  // Isolates the problem
  final problems = List<List<String>>.generate(
    columnCount,
    (columnIndex) =>
        input.map((row) => row.split(RegExp(r"\s+"))[columnIndex]).toList(),
  );

  // Add or multiply all the numbers in the problem, depending of the last character
  // and sum them
  return problems
      .map((problem) {
        final (int Function(int, String) op, int init) = switch (problem.last) {
          "+" => ((acc, elem) => acc + int.parse(elem), 0),
          "*" => ((acc, elem) => acc * int.parse(elem), 1),
          _ => throw Exception("Unknown operation"),
        };
        return problem.take(linesCount - 1).fold(init, op);
      })
      .fold(0, (acc, elem) => acc + elem);
}

int day6p2() {
  final input = File("input/day6.sylc").readAsLinesSync();

  final opIndices = input.last
      .split("")
      .indexed
      .where((elem) => RegExp(r"[+*]").hasMatch(elem.$2))
      .map((elem) => elem.$1)
      .toList();

  // Add end of line index, +1 because there is no space char at
  // the end of the opLine, would fall short else.
  opIndices.add(input[0].length + 1);

  // Number of operations for a single problem
  final linesCount = input.length;

  // Isolate problems from op ranges.
  final problems = List.generate(opIndices.length - 1, (idx) {
    final problem = input
        .take(linesCount - 1)
        .map(
          (inputLine) =>
              inputLine.substring(opIndices[idx], opIndices[idx + 1] - 1),
        )
        .toList();
    // add op
    problem.add(input.last[opIndices[idx]]);
    return problem;
  });

  return problems
      .map((problem) {
        // Closure to fold, depending on the op char (as well as the initial value).
        final (int Function(int, String) op, int init) = switch (problem.last) {
          "+" => ((acc, elem) => acc + int.parse(elem), 0),
          "*" => ((acc, elem) => acc * int.parse(elem), 1),
          _ => throw Exception("Unknown operation"),
        };

        final len = problem[0].length;
        // This add the column to form the numbers.
        final numbers = Iterable.generate(len, (idx) {
          return problem
              // Exclude the op char
              .take(linesCount - 1)
              // For each line in the problem
              .map((problemExpr) {
                // Get the char at the column index
                return problemExpr.split("")[idx];
              })
              //filter whitespace
              .where((c) => c != " ")
              //form the number from the digits.
              .join();
        });
        return numbers.fold(init, op);
      })
      // sum the problems
      .fold(0, (acc, elem) => acc + elem);
}
