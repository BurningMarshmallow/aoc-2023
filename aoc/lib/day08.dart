import 'dart:io';
import 'package:dart_numerics/dart_numerics.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var instructions = lines[0];

  var network = <String, Neighbours>{};
  for (var line in lines.skip(2)) {
    var [from, to] = line.split(" = ");
    var parts = to.split(", ");
    var left = parts[0].substring(1);
    var right = parts[1].substring(0, parts[1].length - 1);

    network[from] = Neighbours(left, right);
  }

  easy(fileName, instructions, network);
  hard(fileName, instructions, network);
}

void easy(String fileName, String instructions, Map<String, Neighbours> network) {
  print(getNumberOfSteps(instructions, network, "AAA", (node) => node == "ZZZ"));
}

void hard(String fileName, String instructions, Map<String, Neighbours> network) {
  var startNodes = network.keys.where((e) => e.endsWith("A"));
  var cycles = startNodes.map((e) =>
      getNumberOfSteps(instructions, network, e, (node) => node.endsWith("Z")));
  print(cycles.reduce((value, element) => leastCommonMultiple(value, element)));
}

int getNumberOfSteps(String instructions, Map<String, Neighbours> network,
    String start, bool Function(String node) isOver) {
  var steps = 0;

  var currNode = start;
  while (true) {
    for (var dir in instructions.split("")) {
      var neighbours = network[currNode]!;
      currNode = dir == "L" ? neighbours.left : neighbours.right;
      steps++;

      if (isOver(currNode)) {
        return steps;
      }
    }
  }
}

class Neighbours {
  Neighbours(this.left, this.right);
  final String left, right;
}
