// Solution for easy part of https://adventofcode.com/2022/day/1
import 'dart:convert';
import 'dart:io';
import 'dart:math';

int calculate() {
  return 6 * 7;
}

void solve() {
  solveInternal();
}

Future<void> solveInternal() async {
  final lines = utf8.decoder
      .bind(File("input.txt").openRead())
      .transform(const LineSplitter());

  var maxSum = await lines.fold(
      (0, 0),
      (prev, element) => element == ""
          ? (max(prev.$1, prev.$2), 0)
          : (prev.$1, prev.$2 + int.parse(element)));
  print(maxSum);
}
