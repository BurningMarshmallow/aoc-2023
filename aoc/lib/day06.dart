import 'dart:io';
import 'dart:math';
import 'utils.dart';

void solve(String fileName) {
  easy(fileName);
  hard(fileName);
}

void easy(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var times = lines[0].splitNotEmpty().skip(1).map(int.parse).toList();
  var distances = lines[1].splitNotEmpty().skip(1).map(int.parse).toList();

  var total = Iterable<int>.generate(times.length)
      .fold(1, (prev, i) => prev * getNumberOfWays(times[i], distances[i]));

  print(total);
}

void hard(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var time = int.parse(lines[0].splitNotEmpty().skip(1).join(""));
  var distance = int.parse(lines[1].splitNotEmpty().skip(1).join(""));

  var total = getNumberOfWays(time, distance);
  print(total);
}

// x^2 - time*x + distance < 0
int getNumberOfWays(int time, int distance) {
  var A = 1;
  var B = -time;
  var C = distance;
  var D = B * B - 4 * A * C;
  var p1 = - B / 2.0 / A;
  var p2 = sqrt(D.abs()) / 2.0 / A;
  const eps = 0.0000001;
  var x1 = p1 - p2;
  var x2 = p1 + p2;
  var lowest = (x1 + eps).ceil();
  var highest = (x2 - eps).floor();

  return highest - lowest + 1;
}
