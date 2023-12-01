import 'dart:convert';
import 'dart:io';

const numbers = {
  "one": "1",
  "two": "2",
  "three": "3",
  "four": "4",
  "five": "5",
  "six": "6",
  "seven": "7",
  "eight": "8",
  "nine": "9"
};

final numberRegex = RegExp(r'[0-9]|' + numbers.keys.join('|'));

void solve() {
  solveInternal();
}

Future<void> solveInternal() async {
  final lines = utf8.decoder
      .bind(File("input.txt").openRead())
      .transform(const LineSplitter());
  var total = await lines.fold(
      0, (prev, element) => prev + getCalibrationValue(element));

  print(total);
}

int getCalibrationValue(String strValue) {
  var firstIndex = strValue.indexOf(numberRegex);
  var lastIndex = strValue.lastIndexOf(numberRegex);

  var firstNumber = parseNumberByIndex(strValue, firstIndex);
  var lastNumber = parseNumberByIndex(strValue, lastIndex);

  return int.parse(firstNumber + lastNumber);
}

String parseNumberByIndex(String str, int index) {
  for (var number in numbers.keys) {
    if (index + number.length <= str.length) {
      if (str.substring(index, index + number.length) == number) {
        return numbers[number]!;
      }
    }
  }
  return str[index];
}
