import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

void solve(String fileName) {
  easy(fileName);
  hard(fileName);
}

void easy(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var seeds = lines[0].substring(7).split(" ").map(int.parse).toList();
  var maps = lines
      .skip(2)
      .where((line) => line != "")
      .splitBefore((value) => value.contains("map"))
      .toList();

  print(seeds.map((seed) => getLocation(seed, maps)).reduce(min));
}

int getLocation(int seed, List<List<String>> maps) {
  var curr = seed;
  for (var map in maps) {
    for (var range in map.skip(1)) {
      var [destStart, sourceStart, len] =
          range.split(" ").map(int.parse).toList();
      if (sourceStart <= curr && curr <= sourceStart + len) {
        curr += destStart - sourceStart;
        break;
      }
    }
  }
  return curr;
}

void hard(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var inputRanges = lines[0]
      .substring(7)
      .split(" ")
      .map(int.parse)
      .slices(2)
      .map((pair) => Range(pair[0], pair[1]))
      .toList();

  var transforms = lines
      .skip(2)
      .where((line) => line != "")
      .splitBefore((value) => value.contains("map"))
      .map((x) => Transform(x.skip(1).map(parseMapping).toList()))
      .toList();

  print(getMinimalTransformedNumber(inputRanges, transforms));
}

int getMinimalTransformedNumber(
    List<Range> inputRanges, List<Transform> transforms) {
  var transformedRanges = transforms.fold(inputRanges,
      (currRanges, transform) => transform.applyTo(currRanges));
  return transformedRanges.map((x) => x.start).reduce(min);
}

class Range {
  Range(this.start, this.length);
  final int start, length;

  int get end => start + length;

  Range? intersectWith(Range range) {
    var startIntersect = max(start, range.start);
    var endIntersect = min(end, range.end);
    return startIntersect < endIntersect
        ? Range(startIntersect, endIntersect - startIntersect)
        : null;
  }
  
  Range addOffset(int offset) {
    return Range(start + offset, length);
  }
  
  Iterable<Range> excludeAll(Iterable<Range> rangesToExclude) sync*
    {
        var current = this;
        for (var rangeToExclude in rangesToExclude.sorted((x, y) => x.start.compareTo(y.start)))
        {
            var (prefix, suffix) = current.exclude(rangeToExclude);
            if (prefix != null) yield prefix;
            if (suffix == null) return;
            current = suffix;
        }
        yield current;
    }
    
    (Range? left, Range? right) exclude(Range rangeToExclude)
    {
        Range? left, right;
        if (start < rangeToExclude.start) {
          left = fromStartEnd(start, min(rangeToExclude.start, end));
        }
        if (end > rangeToExclude.end) {
          right = fromStartEnd(max(rangeToExclude.end, start), end);
        }
        return (left, right);
    }
    
    Range fromStartEnd(int start, int endExclusive) => Range(start, endExclusive - start);
}

class Mapping {
  Mapping(this.source, this.offset);
  final Range source;
  final int offset;
}

class Transform {
  Transform(this.mappings);
  final List<Mapping> mappings;

  List<Range> applyToSingle(Range range) {
    var mapped = mappings
        .map((m) => m.source.intersectWith(range)?.addOffset(m.offset))
        .where((element) => element != null)
        .cast<Range>()
        .toList();

    var mappingSourceRanges = mappings.map((m) => m.source);
    var unchanged = range.excludeAll(mappingSourceRanges).toList();

    return mapped + unchanged;
  }

  List<Range> applyTo(List<Range> ranges) {
    return ranges.map(applyToSingle).flattened.toList();
  }
}

Mapping parseMapping(String line) {
  var parts = line.split(" ").map(int.parse).toList();
  var offset = parts[0] - parts[1];
  return Mapping(Range(parts[1], parts[2]), offset);
}
