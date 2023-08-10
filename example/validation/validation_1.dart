import 'package:func_dart_core/either.dart';
import 'package:func_dart_core/function.dart';
import 'package:func_dart_core/predicate.dart' as p;

typedef Error = String;

/*
 * Benefits of using Either for validation:
 * - Clear distinction between success (Right) and error (Left) cases.
 * - Treat errors as first-class entities.
 * - Encourages immutability and pure functions.
 */
typedef Validator<T> = Either<Error, T> Function(T p1);

// Validation functions
bool isZero(int value) => value == 0;
bool isEven(int value) => value % 2 == 0;

// Creating a validator from a predicate with an associated error message
Validator<T> Function(String) validate<T>(p.Predicate<T> predicate) =>
    (String errorMsg) => (T value) =>
        predicate(value) ? Right<Error, T>(value) : Left<Error, T>(errorMsg);

// Specific Validators
final validateIsEven = validate(isEven)("Must be even");
final validateNotZero = validate(p.not(isZero))("Must not be zero");

// Convert Either type to a string for easy display
final parseToString =
    match((left) => 'Fail: $left', (right) => 'Success: $right');

// Pipelines: Linking validation logic and formatting
final parseEven = flow2(validateIsEven, parseToString);
final parseNotZero = flow2(validateNotZero, parseToString);

void main() {
  // Demo of each validator
  print(parseEven(1)); // Fail: Must be even
  print(parseEven(2)); // Success: 2

  print(parseNotZero(0)); // Fail: Must not be zero
  print(parseNotZero(-1)); // Success: -1
}
