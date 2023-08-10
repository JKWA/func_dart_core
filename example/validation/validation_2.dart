import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/predicate.dart' as p;

typedef Error = String;
typedef Validator<T> = Either<Error, T> Function(T p1);

// Direct validation functions
bool isNegative(int value) => value < 0;
bool isZero(int value) => value == 0;
bool isEven(int value) => value % 2 == 0;

// Predicate-based validation functions (combining other validations)
p.Predicate<int> isPositive = p.and<int>(p.not(isNegative))(p.not(isZero));
p.Predicate<int> isLessThan(int upperBound) =>
    (int value) => value < upperBound;

// Creating a validator from a predicate with an associated error message
Validator<T> Function(String) validate<T>(p.Predicate<T> predicate) =>
    (String errorMsg) => (T value) =>
        predicate(value) ? Right<Error, T>(value) : Left<Error, T>(errorMsg);

// Specific Validators
final validateIsEven = validate(isEven)("Must be even");
final validateIsOdd = validate(p.not(isEven))("Must be odd");
final validatePositive = validate(isPositive)("Must be positive");
final validatePositiveLessThan100 = validate(
    p.and(isPositive)(isLessThan(100)))("Must be positive but less than 100");

// Convert Either type to a string for easy display
final parseToString =
    match((left) => 'Fail: $left', (right) => 'Success: $right');

// Pipelines: Linking validation logic and formatting
final parseOdd = flow2(validateIsEven, parseToString);
final parseEven = flow2(validateIsOdd, parseToString);
final parsePositive = flow2(validatePositive, parseToString);
final parsePositiveLessThan100 =
    flow2(validatePositiveLessThan100, parseToString);

void main() {
  // Demo of each validator
  print(parseOdd(1)); // Fail: Must be even
  print(parseOdd(2)); // Success: 2

  print(parseEven(1)); // Success: 1
  print(parseEven(2)); // Fail: Must be odd

  print(parsePositive(-1)); // Fail: Must be positive
  print(parsePositive(1)); // Success: 1

  print(parsePositiveLessThan100(99)); // Success: 99
  print(parsePositiveLessThan100(
      100)); // Fail: Must be positive but less than 100
}
