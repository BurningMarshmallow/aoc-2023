import 'dart:io';
import 'dart:math';

final gameRegex = RegExp(r'Game (\d+): (.*)');
final redRegex = RegExp(r'(\d+) red');
final greenRegex = RegExp(r'(\d+) green');
final blueRegex = RegExp(r'(\d+) blue');

void solve(String fileName) {
  easy(fileName);
  hard(fileName);
}

void easy(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var total = lines.fold(0, (prev, x) => prev + getIdIfPossible(x));

  print(total);
}

int getIdIfPossible(String line) {
  var gameMatch = gameRegex.firstMatch(line)!;
  var gameId = gameMatch[1]!;
  var cubeSets = parseCubeSets(gameMatch[2]!);

  if (cubeSets.any((cubeSet) => cubeSet.isImpossible())) {
    return 0;
  }
  return int.parse(gameId);
}

void hard(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var total = lines.fold(0, (prev, x) => prev + getPower(x));

  print(total);
}

int getPower(String line) {
  var gameMatch = gameRegex.firstMatch(line)!;
  var cubeSets = parseCubeSets(gameMatch[2]!);

  var maxRed = cubeSets.map((x) => x.red).reduce(max);
  var maxGreen = cubeSets.map((x) => x.green).reduce(max);
  var maxBlue = cubeSets.map((x) => x.blue).reduce(max);

  return maxRed * maxGreen * maxBlue;
}

List<CubeSet> parseCubeSets(String value) {
  List<CubeSet> cubeSets = [];

  for (var cubeSetStr in value.split('; ')) {
    var red = parseIntByRegex(cubeSetStr, redRegex);
    var green = parseIntByRegex(cubeSetStr, greenRegex);
    var blue = parseIntByRegex(cubeSetStr, blueRegex);
    cubeSets.add(CubeSet(red, green, blue));
  }

  return cubeSets;
}

int parseIntByRegex(String value, RegExp regex) {
  var match = regex.firstMatch(value);
  return match != null ? int.parse(match[1]!) : 0;
}

class CubeSet {
  CubeSet(this.red, this.green, this.blue);
  final int red, green, blue;

  bool isImpossible() =>
      red > expected().red ||
      green > expected().green ||
      blue > expected().blue;

  CubeSet expected() => CubeSet(12, 13, 14);
}
