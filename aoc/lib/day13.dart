import 'dart:io';
import 'package:matrix2d/matrix2d.dart';

List<(String, String)> zipLists(List<String> first, List<String> second) {
  var minLength = first.length < second.length ? first.length : second.length;
  return List.generate(
      minLength, (i) => (first[i], second[i]));
}

Iterable zipStrings(String first, String second) {
  var minLength = first.length < second.length ? first.length : second.length;
  return Iterable.generate(minLength, (i) => (first[i], second[i]));
}

void solve(String fileName) {
  var input = File(fileName).readAsStringSync();
  var patterns = input.split("\n\n").map((x) => x.split("\n")).toList();

  var totalEasy = patterns.fold(0, (prev, x) => prev + getScore(x));
  var totalHard = patterns.fold(0, (prev, x) => prev + getScore(x, 1));

  print(totalEasy);
  print(totalHard);
}

int getScore(List<String> pattern, [int smudges = 0]) {
  return 100 * horizontal(pattern, smudges) + vertical(pattern, smudges);
}

int vertical(List<String> pattern, [int smudges = 0]) {
  return horizontal(
      pattern.transpose.map((e) => List<String>.from(e).join("")).toList(),
      smudges);
}

int horizontal(List<String> pattern, [int smudges = 0]) {
  for (var i = 0; i < pattern.length; i++) {
    if (i + 1 == pattern.length) {
      return 0;
    }

    var reversed = List<String>.from(pattern.sublist(0, i + 1).reversed);
    var pairsToCheck = [
      for (var (line1, line2) in zipLists(reversed, pattern.sublist(i + 1)))
        for (var (c1, c2) in zipStrings(line1, line2)) (c1, c2)
    ];

    var samePairs = pairsToCheck.where((x) => x.$1 == x.$2).toList();
    if (samePairs.length == pairsToCheck.length - smudges) {
      return i + 1;
    }
  }

  return -1;
}
