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

final numberRegex = RegExp(r'[0-9]');
final numberHardRegex = RegExp(r'[0-9]|' + numbers.keys.join('|'));

void solve(String fileName) {
  solveInternal(fileName);
}

void solveInternal(String fileName) {
  var lines = File(fileName).readAsLinesSync();
      
  var totalEasy = lines.fold(
      0, (prev, element) => prev + getCalibrationValue(element));

  print(totalEasy);

  var totalHard = lines.fold(
      0, (prev, element) => prev + getCalibrationValueHard(element));

  print(totalHard);
}

int getCalibrationValue(String strValue) {
  var firstIndex = strValue.indexOf(numberRegex);
  var lastIndex = strValue.lastIndexOf(numberRegex);

  var firstNumber = firstIndex != -1 ? strValue[firstIndex] : "0";
  var lastNumber = lastIndex != -1 ? strValue[lastIndex] : "0";

  return int.parse(firstNumber + lastNumber);
}

int getCalibrationValueHard(String strValue) {
  var firstIndex = strValue.indexOf(numberHardRegex);
  var lastIndex = strValue.lastIndexOf(numberHardRegex);

  var firstNumber = parseNumberByIndexHard(strValue, firstIndex);
  var lastNumber = parseNumberByIndexHard(strValue, lastIndex);

  return int.parse(firstNumber + lastNumber);
}

String parseNumberByIndexHard(String str, int index) {
  for (var number in numbers.keys) {
    if (index + number.length <= str.length) {
      if (str.substring(index, index + number.length) == number) {
        return numbers[number]!;
      }
    }
  }
  return str[index];
}
