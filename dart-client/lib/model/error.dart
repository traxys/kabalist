//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class Error {
  /// Instantiate a new enum with the provided [value].
  const Error._(this.value);

  /// The underlying value of this enum member.
  final num value;

  @override
  String toString() => value.toString();

  num toJson() => value;

  static const n0 = Error._('0');
  static const n1 = Error._('1');
  static const n2 = Error._('2');
  static const n3 = Error._('3');
  static const n4 = Error._('4');
  static const n5 = Error._('5');
  static const n6 = Error._('6');
  static const n7 = Error._('7');
  static const n8 = Error._('8');
  static const n10 = Error._('10');
  static const n9 = Error._('9');

  /// List of all possible values in this [enum][Error].
  static const values = <Error>[
    n0,
    n1,
    n2,
    n3,
    n4,
    n5,
    n6,
    n7,
    n8,
    n10,
    n9,
  ];

  static Error? fromJson(dynamic value) => ErrorTypeTransformer().decode(value);

  static List<Error>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Error>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Error.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [Error] to num,
/// and [decode] dynamic data back to [Error].
class ErrorTypeTransformer {
  factory ErrorTypeTransformer() => _instance ??= const ErrorTypeTransformer._();

  const ErrorTypeTransformer._();

  num encode(Error data) => data.value;

  /// Decodes a [dynamic value][data] to a Error.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  Error? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data.toString()) {
        case '0': return Error.n0;
        case '1': return Error.n1;
        case '2': return Error.n2;
        case '3': return Error.n3;
        case '4': return Error.n4;
        case '5': return Error.n5;
        case '6': return Error.n6;
        case '7': return Error.n7;
        case '8': return Error.n8;
        case '10': return Error.n10;
        case '9': return Error.n9;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ErrorTypeTransformer] instance.
  static ErrorTypeTransformer? _instance;
}

