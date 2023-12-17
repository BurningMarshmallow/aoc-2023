import 'dart:io';
import 'dart:math';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();

  var galaxies = [[]];
  galaxies.removeLast();
  for (var (x, line) in lines.indexed) {
    for (var (y, ch) in line.split("").indexed) {
      if (ch == "#") {
        galaxies.add([x, y]);
      }
    }
  }

  var emptyRows = <int>[];
  var emptyColumns = <int>{};

  for (var (i, _) in lines.indexed) {
    if (noGalaxiesInRow(lines, i)) {
      emptyRows.add(i);
    }
  }
  for (var j = 0; j < lines[0].length; j++) {
    if (noGalaxiesInColumn(lines, j)) {
      emptyColumns.add(j);
    }
  }

  print(sumDist(galaxies, emptyRows, emptyColumns, 2));
  print(sumDist(galaxies, emptyRows, emptyColumns, 1000000));
}

num sumDist(List<List<dynamic>> galaxies, List<int> emptyRows,
    Set<int> emptyColumns, int increase) {
  num sumDist = 0;
  increase--;
  for (var i = 0; i < galaxies.length; i++) {
    for (var j = i + 1; j < galaxies.length; j++) {
      sumDist += (galaxies[i][0] - galaxies[j][0]).abs() +
          (galaxies[i][1] - galaxies[j][1]).abs();
      for (var x in emptyRows) {
        num left = galaxies[i][0];
        num right = galaxies[j][0];
        if (min(left, right) < x && x < max(left, right)) {
          sumDist += increase;
        }
      }

      for (var y in emptyColumns.toList()) {
        num left = galaxies[i][1];
        num right = galaxies[j][1];
        if (min(left, right) < y && y < max(left, right)) {
          sumDist += increase;
        }
      }
    }
  }
  return sumDist;
}

bool noGalaxiesInRow(List<String> lines, int i) {
  return !lines[i].contains("#");
}

bool noGalaxiesInColumn(List<String> lines, int j) {
  for (var line in lines) {
    if (line[j] == "#") {
      return false;
    }
  }
  return true;
}
