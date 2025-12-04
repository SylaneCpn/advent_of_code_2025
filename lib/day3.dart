import 'dart:io';

int _maxJoltage2(String bank) {
  //split the string as an array of digits
  final digits = bank.split("");

  //find the biggest digit
  //Ignore the last one since there will be no other digit to make a two digit number.
  final maxDigit = digits
      .take(digits.length - 1)
      .reduce(
        // Since there are only digit char, we can compare the code Unit to find the biggest one
        (value, element) =>
            (value.codeUnitAt(0) > element.codeUnitAt(0)) ? value : element,
      );

  //Find the first position where the max digits appears
  final maxDigitPosition = digits.indexWhere((d) => d == maxDigit);

  //Starting from the maxDigit position, well the orther digit in the array that will give the maximum value.
  return digits.skip(maxDigitPosition + 1).fold(0, (acc, secondDigit) {
    final fused = digits[maxDigitPosition] + secondDigit;
    int value = int.parse(fused);
    return acc > value ? acc : value;
  });
}

int day3p1() {
  final inputAsLines = File("input/day3.sylc").readAsLinesSync();
  return inputAsLines.map(_maxJoltage2).fold(0, (acc, elem) => acc + elem);
}

int _maxJoltage12(String bank) {
  //split the string as an array of digits
  final digits = bank.split("");

  //find the biggest digit
  //Ignore the last 11 since there will be no other digit to make a two digit number.
  final maxDigit = digits
      .take(digits.length - 11)
      .reduce(
        // Since there are only digit char, we can compare the code Unit to find the biggest one
        (value, element) =>
            (value.codeUnitAt(0) > element.codeUnitAt(0)) ? value : element,
      );

  //Find the first position where the max digits appears
  final maxDigitPosition = digits.indexOf(maxDigit);

  //Keep track of the digits seen
  final otherDigits = <String>[];
  for (int i = maxDigitPosition + 1; i < digits.length; i++) {
    // We can add an other digit, no problem
    if (otherDigits.length < 11) {
      otherDigits.add(digits[i]);
      // Else we should try to replace the first ascending digit digit
    } else {
      //pop first that is not descending
      int? flexIndex;
      for (int j = 1; j < otherDigits.length; j++) {
        final prev = otherDigits[j - 1].codeUnitAt(0);
        final curr = otherDigits[j].codeUnitAt(0);

        //descending broken
        if (prev < curr) {
          flexIndex = j - 1;
          break;
        }
      }

      // Pop to keep the list descending
      if (flexIndex != null) {
        otherDigits
          ..removeAt(flexIndex)
          ..add(digits[i]);
      }
      //List is descending add new digit to the end
      else {
        // Only append last if the new digit is greater than the previous last
        if (otherDigits.last.codeUnitAt(0) < digits[i].codeUnitAt(0)) {
          otherDigits
            ..removeLast()
            ..add(digits[i]);
        }
      }
    }
  }
  return int.parse([digits[maxDigitPosition], ...otherDigits].join());
}

int day3p2() {
  final inputAsLines = File("input/day3.sylc").readAsLinesSync();
  return inputAsLines
      .map(_maxJoltage12)
      .fold(0, (acc, elem) => acc + elem);
}
