import 'dart:io';
import 'utils.dart';

final numRegex = RegExp(r'\d+');

void solve(String fileName) {
  var engine = File(fileName).readAsLinesSync();
  var [n, m] = [engine.length, engine[0].length];
  
  var sumEasy = 0;
  var gears = <(int, int), Set<int>>{};
  for (var (x, line) in engine.indexed) {
    for (var match in numRegex.allMatches(line)) {
      var [l, r] = [match.start, match.end];
      var num = int.parse(match.group(0)!);
      var isPartNumber = false;
      for (var y = l; y < r; y++) {
        for (var [nx, ny] in neighbours8([x, y], n, m)) {
          var ch = engine[nx][ny];
          if (ch != "." && !numRegex.hasMatch(ch)) {
            isPartNumber = true;
          }
          if (ch == "*") {
            if (!gears.containsKey((nx, ny))) {
              gears[(nx, ny)] = {};
            }
            gears[(nx, ny)]!.add(num);
          }
        }
      }

      if (isPartNumber) {
        sumEasy += num;
      }
    }
  }
  print(sumEasy);

  var sumHard = 0;
  for (var numbers in gears.values) {
    if (numbers.length == 2) {
      sumHard += numbers.reduce((value, element) => value * element);
    }
  }
  print(sumHard);
}
