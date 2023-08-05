/// Defines a function that takes a value of type A and returns a boolean.
typedef Predicate<A> = bool Function(A value);

/// Creates a new predicate that is the logical disjunction of two given predicates.
Predicate<A> Function(Predicate<A>) or<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) || second(value);
    };
  };
}

/// Creates a new predicate that is the logical conjunction of two given predicates.
Predicate<A> Function(Predicate<A>) and<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) && second(value);
    };
  };
}

/// Creates a new predicate that is the logical negation of a given predicate.
Predicate<A> not<A>(Predicate<A> predicate) {
  return (A value) {
    return !predicate(value);
  };
}

/// Transforms a predicate using a function.
Predicate<B> Function(Predicate<A>) contramap<B, A>(A Function(B) f) {
  return (Predicate<A> p) {
    return (B value) => p(f(value));
  };
}

/// Matches a value against a predicate and returns a function.
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
