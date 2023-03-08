# Option
This is an example implementation of the [Rust Option](https://doc.rust-lang.org/std/option/) in Dart.

It's not meant to be production ready, but if you want, you can copy the file on `lib/option.dart` and put into your project.

# Usage
An Option can represent a value `Some` or no value `None`.

```dart
Option<int> optionFunc(int value) {
  if (value > 5) {
    return Some<int>(value);
  } else {
    return None();
  }
}
```

You can define a function to be executed if the return is Some or None.
```dart
// In this case the Some branch will be executed.
optionFunc(10).match((some) {
  print('Some value branch executed with value $some');
}, () {
  print('None value branch executed');
});
```

You can also use a boolean value to determine if the current Option is a None value or not.
```dart
if (optionFunc(2).isNone) {
  // value is None do something
} 
```