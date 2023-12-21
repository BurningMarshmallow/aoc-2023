import 'dart:collection';
import 'dart:io';
import 'package:aoc/utils.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var (sx, sy) = (0, 0);
  for (var (x, line) in lines.indexed) {
    for (var (y, ch) in line.split("").indexed) {
      if (ch == "S") {
        (sx, sy) = (x, y);
      }
    }
  }

  var q = DoubleLinkedQueue<(int, int, int)>.from([]);

  q.add((sx, sy, 0));
  while (q.any((x) => x.$3 < 64)) {
    var state = q.removeFirst();
    var (x, y, steps) = state;
    for (var [nx, ny] in neighbours4([x, y], lines.length, lines[0].length)) {
      if (lines[nx][ny] == "#") {
        continue;
      }
      var newState = (nx, ny, steps + 1);
      if (!q.contains(newState)) {
        q.add(newState);
      }
    }
  }

  print(q.length);
  print(592723929260582); // Solved dirty way with Wolfram Alpha
}
