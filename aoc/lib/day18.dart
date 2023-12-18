import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();

  easy(lines);
  getLavaHold(lines, true);
}

void easy(List<String> lines) {
  var vis = <(int, int)>{};

  var (x, y) = (0, 0);
  for (var line in lines) {
    var [dir, value, _] = line.split(" ");
    var num = int.parse(value);

    var (dx, dy) = getDir(dir);
    for (var i = 0; i < num; i++) {
      x += dx;
      y += dy;
      vis.add((x, y));
    }
  }

  var bigNum = 10000;
  var (lx, rx, ly, ry) = (bigNum, -bigNum, bigNum, -bigNum);
  for (var t in vis) {
    lx = min(lx, t.$1);
    ly = min(ly, t.$2);
    rx = max(rx, t.$1);
    ry = max(ry, t.$2);
  }

  var tilesCount = 0;
  for (var i = lx; i <= rx; i++) {
    var norths = 0;
    for (var j = ly; j <= ry; j++) {
      if (vis.contains((i, j))) {
        if (vis.contains((i - 1, j))) {
          norths++;
        }
        continue;
      }

      // Odd-even rule
      if (norths % 2 == 1) {
        tilesCount++;
      }
    }
  }

  print(tilesCount + vis.length);
}

// Easy part can be solved with withExtraction = false
void getLavaHold(List<String> lines, bool withExtraction) {
  var pos = Point(0, 0);
  var points = [pos];
  var perimeter = 0;

  for (var line in lines) {
    var [dir, value, color] = line.split(" ");
    var num = int.parse(value);
    if (withExtraction) {
      var colorValue = color.substring(2, color.length - 1);
      dir = "RDLU"[int.parse(colorValue[colorValue.length - 1])];
      num = int.parse(colorValue.substring(0, 5), radix: 16);
    }
    perimeter += num;

    var (dx, dy) = getDir(dir);
    pos = Point(pos.x + dx * num, pos.y + dy * num);
    points.add(pos);
  }

  var area = 0;
  points.reverseRange(0, points.length - 1);
  for (var (i, _) in points.indexed) {
    if (i == points.length - 1) {
      break;
    }

    // Shoelace formula
    area += (points[i].y + points[i + 1].y) * (points[i].x - points[i + 1].x);
  }

  print(perimeter ~/ 2 + area ~/ 2 + 1);
}

(int, int) getDir(String dir) {
  switch (dir) {
    case "U":
      return (-1, 0);
    case "D":
      return (1, 0);
    case "R":
      return (0, 1);
    default:
      return (0, -1);
  }
}
