import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

class StringEq extends Eq<String> {
  @override
  bool equals(String x, String y) => x == y;
}

class StringOrd extends Ord<String> {
  StringOrd() : super((String x, String y) => x.compareTo(y));
}

class SemigroupConcat extends BaseSemigroup<String> {
  @override
  String concat(String x, String y) => x + y;
}

class MonoidConcat extends BaseMonoid<String> {
  @override
  String get empty => '';

  @override
  String concat(String x, String y) => x + y;
}

final Eq<String> eqString = StringEq();
final Ord<String> ordString = StringOrd();
final BaseSemigroup<String> semigroupConcat = SemigroupConcat();
final BaseMonoid<String> monoidConcat = MonoidConcat();

String toUpperCase(String s) => s.toUpperCase();

String toLowerCase(String s) => s.toLowerCase();

String replace(String searchValue, String replaceValue, String s) =>
    s.replaceFirst(RegExp(searchValue), replaceValue);

String trim(String s) => s.trim();

String trimLeft(String s) => s.trimLeft();

String trimRight(String s) => s.trimRight();

String slice(int start, int end, String s) => s.substring(start, end);

bool isEmpty(String s) => s.isEmpty;

int size(String s) => s.length;

List<String> split(String separator, String s) {
  final result = s.split(separator);
  return result.isEmpty ? [''] : result; // Dart split can return an empty list.
}

bool includes(String searchString, String s, [int? position]) =>
    s.contains(searchString, position ?? 0);

bool startsWith(String searchString, String s, [int? position]) =>
    s.startsWith(searchString, position ?? 0);

bool endsWith(String searchString, String s, [int? position]) =>
    s.endsWith(searchString);
