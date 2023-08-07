/// Defines a function that takes a value of type A and returns a boolean.
typedef Predicate<A> = bool Function(A value);

/// Creates a new predicate that is the logical disjunction of two given predicates.
/// ```
/// Example usage:
///
/// ```dart
/// Predicate<int> isEven = (int n) => n % 2 == 0;
/// Predicate<int> isPositive = (int n) => n > 0;
/// Predicate<int> isEvenOrPositive = or(isEven)(isPositive);
///
/// print(isEvenOrPositive(2));  // Prints: true
/// print(isEvenOrPositive(-1)); // Prints: false
/// print(isEvenOrPositive(1));  // Prints: true
/// ```
Predicate<A> Function(Predicate<A>) or<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) || second(value);
    };
  };
}

/// Creates a new predicate that is the logical conjunction of two given predicates.
/// ```
/// Example usage:
///
/// ```dart
/// Predicate<int> isEven = (int n) => n % 2 == 0;
/// Predicate<int> isPositive = (int n) => n > 0;
/// Predicate<int> isEvenAndPositive = and(isEven)(isPositive);
///
/// print(isEvenAndPositive(2));  // Prints: true
/// print(isEvenAndPositive(-2)); // Prints: false
/// print(isEvenAndPositive(1));  // Prints: false
/// ```
Predicate<A> Function(Predicate<A>) and<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) && second(value);
    };
  };
}

/// Creates a new predicate that is the logical negation of a given predicate.
/// ```
/// Example usage:
///
/// ```dart
/// Predicate<int> isEven = (int n) => n % 2 == 0;
/// Predicate<int> isOdd = not(isEven);
///
/// print(isOdd(2));  // Prints: false
/// print(isOdd(1));  // Prints: true
/// ```
Predicate<A> not<A>(Predicate<A> predicate) {
  return (A value) {
    return !predicate(value);
  };
}

/// Transforms a predicate using a function.
/// ```
/// Example usage:
///
/// ```dart
/// Predicate<String> isStringLengthGreaterThan5 = (String s) => s.length > 5;
/// Predicate<List<String>> isAnyStringInListLengthGreaterThan5 = contramap((List<String> list) => list.firstWhere((s) => s.length > 5, orElse: () => ''))(isStringLengthGreaterThan5);
///
/// print(isAnyStringInListLengthGreaterThan5(['abc', 'abcdefg']));  // Prints: true
/// print(isAnyStringInListLengthGreaterThan5(['abc', 'def']));  // Prints: false
/// ```
Predicate<B> Function(Predicate<A>) contramap<B, A>(A Function(B) f) {
  return (Predicate<A> p) {
    return (B value) => p(f(value));
  };
}

/// Matches a value against a predicate and returns a function.
/// ```
/// Example usage:
///
/// ```dart
/// Predicate<int> isEven = (int n) => n % 2 == 0;
/// String Function(int) evenOrOdd = match(() => 'Even', () => 'Odd')(isEven);
///
/// print(evenOrOdd(2));  // Prints: 'Even'
/// print(evenOrOdd(1));  // Prints: 'Odd'
/// ```
B Function(A) Function(Predicate<A>) match<A, B>(
  B Function() onTrue,
  B Function() onFalse,
) {
  return (Predicate<A> predicate) {
    return (A value) {
      return predicate(value) ? onTrue() : onFalse();
    };
  };
}
