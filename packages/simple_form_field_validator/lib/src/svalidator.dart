import 'package:flutter/widgets.dart';

/// Simple validator helpers
class SValidator<T> {
  SValidator(this.validators);

  SValidator.singleton(FormFieldValidator<T> validator) : this([validator]);

  final List<FormFieldValidator<T>> validators;

  static final _phoneMatcher = RegExp(r'^\+?[\d ]+$');
  static final _numberMatcher = RegExp(r'^[\d]+$');

  static FormFieldValidator<T> combine<T>(List<FormFieldValidator<T>> validators) {
    return SValidator(validators);
  }

  SValidator<T> operator +(SValidator<T> other) {
    return SValidator(validators + other.validators);
  }

  static SValidator<T> isTrue<T>(bool predicate(T val), String errorMessage, {bool ignoreNull = true}) =>
      SValidator.singleton((T val) {
        if (ignoreNull) {
          if (val == null) {
            return null;
          }
          if (val is String && val.isEmpty) {
            return null;
          }
        }
        if (!predicate(val)) {
          return errorMessage;
        }
        return null;
      });

  static SValidator<T> required<T>({String msg = 'Bitte einen Wert eingeben'}) =>
      isTrue<T>((val) => val != null, msg, ignoreNull: false);

  static SValidator<String> notEmpty({String msg = 'Darf nicht leer sein.'}) =>
      isTrue((String val) => val != null && val.trim().isNotEmpty, msg, ignoreNull: false);

  static SValidator<String> email({String msg = 'Bitte eine gültige E-Mail Adresse angeben.'}) =>
      isTrue((val) => val.contains('@'), msg);

  static SValidator<String> phone() =>
      isTrue((val) => _phoneMatcher.hasMatch(val), 'Bitte eine gültige Telefonnummer angeben.');

  static SValidator<String> number() =>
      isTrue<String>((val) => _numberMatcher.hasMatch(val), 'Bitte eine ganze Zahl eingeben.');

  static SValidator<String> numberIsInRange(
          {int minValue, int maxValue, String message = 'Bitte eine gültige Zahl eingeben.'}) =>
      isTrue<String>((val) => _isInRange(int.parse(val), minValue: minValue, maxValue: maxValue), message);

  /// make one specific value invalid, typical example having a server side "Invalid Password" error message.
  static SValidator<T> invalidValue<T>({T Function() invalidValue, String message}) =>
      isTrue<T>((val) => val != invalidValue(), message);

  String call(T val) {
    for (var validate in validators) {
      final ret = validate(val);
      if (ret != null) {
        return ret;
      }
    }
    return null;
  }

  static bool _isInRange(int val, {int minValue, int maxValue}) {
    assert(minValue == null || maxValue == null || minValue < maxValue);
    if (minValue != null && minValue > val) {
      return false;
    }
    if (maxValue != null && maxValue < val) {
      return false;
    }
    return true;
  }
}
