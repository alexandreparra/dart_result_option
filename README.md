## Dart Result Option

Dart Result and Option are example implementations from Rust Option and Result:

```dart
Result<int, String> sumPositive(int n1, int n2) {
  if (n1 + n2 < 0) {
    // If the sum is not positive, we return a String wrapped on an Err
    // that will be treated as an error.
    return Err("The sum between $n1 + $n2 is not bigger than 0");
  }

  // If everything goes well we wrap the sum with an Ok.
  return Ok(n1 + n2);
}

sumPositive(5, 5).match(
      (ok) => print("Successfully returned, the sum is $ok"),
      (err) => print(err));
```

```dart
Option<int> testOption(int value) {
  if (value <= 2) {
    return None();
  } else {
    return Some(value * value);
  }
}

testOption(5).match((some) {
  print("value is $some");
}, () {
  print("Value is less than 2");
});
```

These constructs can be used to handle errors and possible null values, you can look inside `example`
and `tests` folders for a better idea on how to use them.

For more in-depth explanations go to:
- [Dart Option](https://github.com/ccovenant/dart_result_option/blob/main/readme_option.md)
- [Dart Result](https://github.com/ccovenant/dart_result_option/blob/main/readme_result.md)