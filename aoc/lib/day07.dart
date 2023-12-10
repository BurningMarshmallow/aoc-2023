import 'dart:io';
import 'utils.dart';
import 'package:collection/collection.dart';

void solve(String fileName) {
  easy(fileName);
  hard(fileName);
}

void easy(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  lines.sort((a, b) => compareHands(a.split(' ')[0], b.split(' ')[0]));
  var total = lines.foldIndexed(
      0, (idx, prev, x) => prev + (idx + 1) * int.parse(x.split(' ')[1]));

  print(total);
}

int compareHands(String first, String second) {
  var firstType = getType(first);
  var secondType = getType(second);
  if (firstType < secondType) {
    return 1;
  }
  if (firstType > secondType) {
    return -1;
  }

  var alph = "23456789TJQKA";
  return first.compareToByChar(second, (x) => alph.indexOf(x));
}

int getType(String str) {
  var counter = <String, int>{};
  for (var char in str.split("")) {
    counter.update(char, (count) => count + 1, ifAbsent: () => 1);
  }

  return getTypeByCounter(counter).index;
}

void hard(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  lines.sort((a, b) => compareHandsHard(a.split(' ')[0], b.split(' ')[0]));
  var total = lines.foldIndexed(
      0, (idx, prev, x) => prev + (idx + 1) * int.parse(x.split(' ')[1]));

  print(total);
}

int compareHandsHard(String first, String second) {
  var firstType = getTypeHard(first);
  var secondType = getTypeHard(second);
  if (firstType < secondType) {
    return 1;
  }
  if (firstType > secondType) {
    return -1;
  }

  var alph = "J23456789TQKA";
  return first.compareToByChar(second, (x) => alph.indexOf(x));
}

int getTypeHard(String str) {
  var counter = <String, int>{};
  for (var char in str.split("")) {
    counter.update(char, (count) => count + 1, ifAbsent: () => 1);
  }

  var jokers = counter.remove("J") ?? 0;
  var mostPopularEntries =
      counter.entries.sorted((a, b) => a.value.compareTo(b.value));
  // JJJJJ
  if (mostPopularEntries.isEmpty) {
    return 0;
  }
  var mostPopularChar = mostPopularEntries[mostPopularEntries.length - 1].key;
  counter[mostPopularChar] = counter[mostPopularChar]! + jokers;

  return getTypeByCounter(counter).index;
}

HandType getTypeByCounter(Map<String, int> counter) {
  var counts = counter.values.sorted((a, b) => a.compareTo(b)).join("");
  switch (counts) {
    case "5":
      return HandType.fiveOfAKind;
    case "14":
      return HandType.fourOfAKind;
    case "23":
      return HandType.fullHouse;
    case "113":
      return HandType.threeOfAKind;
    case "122":
      return HandType.twoPair;
    case "1112":
      return HandType.onePair;
    default:
      return HandType.highCard;
  }
}

enum HandType {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard
}
