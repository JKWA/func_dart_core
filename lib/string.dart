import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

/// StringEq is a concrete implementation of Eq for Strings.
class StringEq extends Eq<String> {
  /// Defines the equivalence of two String values
  @override
  bool equals(String x, String y) => x == y;
}

/// StringOrd is a concrete implementation of Ord for Strings.
class StringOrd extends Ord<String> {
  /// Creates a StringOrd, which will compare Strings by using their inherent order.
  StringOrd() : super((String x, String y) => x.compareTo(y));
}

/// SemigroupConcat is a concrete implementation of a Semigroup for Strings.
class SemigroupConcat extends BaseSemigroup<String> {
  /// Defines the operation of combining two String values
  @override
  String concat(String first, String second) => first + second;
}

/// MonoidConcat is a concrete implementation of a Monoid for Strings.
class MonoidConcat extends BaseMonoid<String> {
  /// Defines the identity element for the operation of this Monoid
  @override
  String get empty => '';

  /// Defines the operation of combining two String values
  @override
  String concat(String first, String second) => first + second;
}

/// Provides the instance of Eq for Strings
final Eq<String> eqString = StringEq();

/// Provides the instance of Ord for Strings
final Ord<String> ordString = StringOrd();

/// Provides the instance of Semigroup for Strings
final BaseSemigroup<String> semigroupConcat = SemigroupConcat();

/// Provides the instance of Monoid for Strings
final BaseMonoid<String> monoidConcat = MonoidConcat();

/// Converts a String to upper case
String toUpperCase(String s) => s.toUpperCase();

/// Converts a String to lower case
String toLowerCase(String s) => s.toLowerCase();

/// Replaces first occurrence of a substring within a String
String replace(String searchValue, String replaceValue, String s) =>
    s.replaceFirst(RegExp(searchValue), replaceValue);

/// Trims whitespace from both ends of a String
String trim(String s) => s.trim();

/// Trims whitespace from the start of a String
String trimLeft(String s) => s.trimLeft();

/// Trims whitespace from the end of a String
String trimRight(String s) => s.trimRight();

/// Returns a section of a String
String slice(int start, int end, String s) => s.substring(start, end);

/// Checks if a String is empty
bool isEmpty(String s) => s.isEmpty;

/// Returns the size of a String
int size(String s) => s.length;

/// Splits a String by a separator
List<String> split(String separator, String s) {
  final result = s.split(separator);
  return result.isEmpty ? [''] : result; // Dart split can return an empty list.
}

/// Checks if a String includes a substring
bool includes(String searchString, String s, [int? position]) =>
    s.contains(searchString, position ?? 0);

/// Checks if a String starts with a substring
bool startsWith(String searchString, String s, [int? position]) =>
    s.startsWith(searchString, position ?? 0);

/// Checks if a String ends with a substring
bool endsWith(String searchString, String s, [int? position]) =>
    s.endsWith(searchString);
