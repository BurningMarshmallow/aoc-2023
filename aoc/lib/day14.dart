import 'dart:io';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  easy(lines);
  hard(lines);
}

void easy(List<String> lines) {
  var totalEasy = 0;

  for (var (j, _) in lines[0].split("").indexed) {
    var currLoad = lines.length;
    var numOfRocksBefore = 0;
    for (var (i, line) in lines.indexed) {
      if (line[j] == "O") {
        totalEasy += currLoad - numOfRocksBefore;
        numOfRocksBefore++;
      }
      if (line[j] == "#") {
        currLoad = (lines.length - (i + 1));
        numOfRocksBefore = 0;
      }
    }
  }
  print(totalEasy);
}

List<String> rotateClockwise(List<String> lines) {
  var newLines = <String>[];
  for (var j = lines[0].length - 1; j >= 0; j--) {
    newLines.add(lines.map((line) => line[j]).join(""));
  }

  return newLines;
}

List<String> rotate180(List<String> lines) {
  return rotateClockwise(rotateClockwise(lines));
}

void hard(List<String> lines) {
  var platforms = <String, int>{};
  var curr = lines;
  var times = 1000000000;
  for (var cycle = 0; cycle < times; cycle++) {
    curr = spinCycle(curr);

    // Good for storing in dict
    var platformFlattened = curr.join("");
    if (platforms.containsKey(platformFlattened)) {
      var diffFromPeriodStart = cycle - platforms[platformFlattened]!;
      times = (times - cycle) % diffFromPeriodStart - 1;
      break;
    }
    platforms[platformFlattened] = cycle;
  }

  for (var cycle = 0; cycle < times; cycle++) {
    curr = spinCycle(curr);
  }

  print(totalLoad(curr));
}

List<String> spinCycle(List<String> curr) {
  for (var tiltTimes = 0; tiltTimes < 4; tiltTimes++) {
    var newLines = <String>[];
    curr = rotateClockwise(curr);
    for (var line in curr) {
      var newLine = StringBuffer();
      var numOfRocksBefore = 0;
      var numOfSpacesBefore = 0;

      for (var ch in line.split("")) {
        switch (ch) {
          case "O":
            numOfRocksBefore++;
            break;
          case ".":
            numOfSpacesBefore++;
            break;
          case "#":
            var rocks = "O" * numOfRocksBefore;
            var spaces = "." * numOfSpacesBefore;
            newLine.write("$rocks$spaces");
            newLine.write("#");
            numOfRocksBefore = 0;
            numOfSpacesBefore = 0;
            break;
          default:
            throw UnimplementedError("Unknown character");
        }
      }

      var rocks = "O" * numOfRocksBefore;
      var spaces = "." * numOfSpacesBefore;
      newLine.write("$rocks$spaces");

      newLines.add(newLine.toString());
    }

    curr = rotate180(newLines);
  }
  return curr;
}

int totalLoad(List<String> lines) {
  var totalLoad = 0;
  for (var (i, line) in lines.indexed) {
    for (var ch in line.split("")) {
      if (ch == "O") {
        totalLoad += lines.length - i;
      }
    }
  }

  return totalLoad;
}
