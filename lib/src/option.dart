abstract class Option<T> {
  factory Option.of(T value) {
    if (value == null) {
      return None();
    } else {
      return Some(value);
    }
  }

  /// unwrap function mimics the match pattern of Some(x) and None in Rust.
  /// If the result from an Option is a Some, then the [some] function is executed,
  /// if not, the [none] function is executed.
  /// Example usage:
  /// ```dart
  /// functionThatReturnsOption()
  ///   .match((some) {/* Some branch with value T*/}, () {/* None branch */})
  /// ```
  void match(Function(T) some, Function() none);

  /// Indicates if the Option is as Some or None.
  bool get isNone;
}

class Some<T> implements Option<T> {
  final T value;
  const Some(this.value);

  @override
  bool get isNone => false;

  @override
  void match(Function(T some) some, Function() none) {
    some(value);
  }
}

class None<_> implements Option<_> {
  const None();

  @override
  bool get isNone => true;

  @override
  void match(Function(_ some) some, Function() none) {
    none();
  }
}
