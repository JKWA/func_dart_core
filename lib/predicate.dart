typedef Predicate<A> = bool Function(A value);

Predicate<A> Function(Predicate<A>) or<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) || second(value);
    };
  };
}

Predicate<A> Function(Predicate<A>) and<A>(Predicate<A> first) {
  return (Predicate<A> second) {
    return (A value) {
      return first(value) && second(value);
    };
  };
}

Predicate<A> not<A>(Predicate<A> predicate) {
  return (A value) {
    return !predicate(value);
  };
}

Predicate<B> Function(Predicate<A>) contramap<B, A>(A Function(B) f) {
  return (Predicate<A> p) {
    return (B value) => p(f(value));
  };
}

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
