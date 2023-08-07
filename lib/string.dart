import "eq.dart";
import 'monoid.dart';
import 'ord.dart';
import 'semigroup.dart';

/// Provides equality comparisons for strings.
class StringEq extends Eq<String> {
  /// Checks if two strings are equal.
  ///
  /// ```dart
  /// final eq = StringEq();
  /// print(eq.equals('hello', 'hello')); // Outputs: true
  /// ```
  @override
  bool equals(String x, String y) => x == y;
}

/// Provides ordering for strings.
class StringOrd extends Ord<String> {
  /// Initialize a new StringOrd.
  ///
  /// ```dart
  /// final ord = StringOrd();
  /// print(ord.compare('b', 'a')); // Outputs: 1
  /// ```
  StringOrd() : super((String x, String y) => x.compareTo(y));
}

/// Provides string concatenation.
class SemigroupConcat extends BaseSemigroup<String> {
  /// Concatenates two strings.
  ///
  /// ```dart
  /// final sg = SemigroupConcat();
  /// print(sg.concat('Hello, ', 'world!')); // Outputs: 'Hello, world!'
  /// ```
  @override
  String concat(String first, String second) => first + second;
}

/// Provides string concatenation with a neutral element (empty string).
class MonoidConcat extends BaseMonoid<String> {
  /// Returns the identity element for string concatenation.
  ///
  /// ```dart
  /// final m = MonoidConcat();
  /// print(m.empty); // Outputs: ''
  /// ```
  @override
  String get empty => '';

  /// Concatenates two strings.
  ///
  /// ```dart
  /// final m = MonoidConcat();
  /// print(m.concat('Hello, ', 'world!')); // Outputs: 'Hello, world!'
  /// ```
  @override
  String concat(String first, String second) => first + second;
}

/// Singleton instances
final Eq<String> eqString = StringEq();
final Ord<String> ordString = StringOrd();
final BaseSemigroup<String> semigroupConcat = SemigroupConcat();
final BaseMonoid<String> monoidConcat = MonoidConcat();

/// Convert a string to upper case.
///
/// ```dart
/// print(toUpperCase('hello')); // Outputs: 'HELLO'
/// ```
String toUpperCase(String s) => s.toUpperCase();

/// Convert a string to lower case.
///
/// ```dart
/// print(toLowerCase('HELLO')); // Outputs: 'hello'
/// ```
String toLowerCase(String s) => s.toLowerCase();

/// Replaces the first occurrence of a substring.
///
/// ```dart
/// print(replace('l', 'w', 'hello')); // Outputs: 'hewlo'
/// ```
String replace(String searchValue, String replaceValue, String s) =>
    s.replaceFirst(RegExp(searchValue), replaceValue);

/// Removes whitespace from both ends of a string.
///
/// ```dart
/// print(trim(' hello ')); // Outputs: 'hello'
/// ```
String trim(String s) => s.trim();

/// Removes whitespace from the start of a string.
///
/// ```dart
/// print(trimLeft(' hello ')); // Outputs: 'hello '
/// ```
String trimLeft(String s) => s.trimLeft();

/// Removes whitespace from the end of a string.
///
/// ```dart
/// print(trimRight(' hello ')); // Outputs: ' hello'
/// ```
String trimRight(String s) => s.trimRight();

/// Returns a substring.
///
/// ```dart
/// print(slice(0, 2, 'hello')); // Outputs: 'he'
/// ```
String slice(int start, int end, String s) => s.substring(start, end);

/// Checks if a string is empty.
///
/// ```dart
/// print(isEmpty('')); // Outputs: true
/// ```
bool isEmpty(String s) => s.isEmpty;

/// Returns the length of a string.
///
/// ```dart
/// print(size('hello')); // Outputs: 5
/// ```
int size(String s) => s.length;

/// Splits a string by a separator.
///
/// ```dart
/// print(split(',', 'hello,world')); // Outputs: ['hello', 'world']
/// ```
List<String> split(String separator, String s) {
  final result = s.split(separator);
  return result.isEmpty ? [''] : result; // Dart split can return an empty list.
}

/// Checks if a string includes a substring.
///
/// ```dart
/// print(includes('ell', 'hello')); // Outputs: true
/// ```
bool includes(String searchString, String s, [int? position]) =>
    s.contains(searchString, position ?? 0);

/// Checks if a string starts with a substring.
///
/// ```dart
/// print(startsWith('hel', 'hello')); // Outputs: true
/// ```
bool startsWith(String searchString, String s, [int? position]) =>
    s.startsWith(searchString, position ?? 0);

/// Checks if a string ends with a substring.
///
/// ```dart
/// print(endsWith('lo', 'hello')); // Outputs: true
/// ```
bool endsWith(String searchString, String s, [int? position]) =>
    s.endsWith(searchString);
