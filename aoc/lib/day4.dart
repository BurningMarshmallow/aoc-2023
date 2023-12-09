import 'dart:io';
import 'dart:math';
import 'utils.dart';
import 'package:collection/collection.dart';

final cardRegex = RegExp(r'Card\s+\d+: (.*)');

void solve(String fileName) {
  easy(fileName);
  hard(fileName);
}

void easy(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var total = lines.fold(0, (prev, x) => prev + getCardPoints(x));

  print(total);
}

int getCardPoints(String line) {
  var myWinningNumbers = getMyWinningNumbers(line);
  if (myWinningNumbers.isNotEmpty) {
    return pow(2, myWinningNumbers.length - 1).toInt();
  }
  return 0;
}

void hard(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var n = lines.length;
  var cards = List.filled(n, 1);
  for (var i = 0; i < n; i++) {
    var numOfCardsToGet = getMyWinningNumbers(lines[i]).length;
    for (var j = i + 1; j < min(i + 1 + numOfCardsToGet, n); j++) {
      cards[j] += cards[i];
    }
  }

  print(cards.sum);
}

Set<String> getMyWinningNumbers(String line) {
  var card = cardRegex.firstMatch(line)!;
  var [winningNumbers, myNumbers] =
      card[1]!.split(' | ').map((x) => x.splitNotEmpty().toSet()).toList();

  return winningNumbers.intersection(myNumbers);
}
