//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ListStatus {
  /// Instantiate a new enum with the provided [value].
  const ListStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const owned = ListStatus._(r'owned');
  static const sharedWrite = ListStatus._(r'shared_write');
  static const sharedRead = ListStatus._(r'shared_read');

  /// List of all possible values in this [enum][ListStatus].
  static const values = <ListStatus>[
    owned,
    sharedWrite,
    sharedRead,
  ];

  static ListStatus? fromJson(dynamic value) => ListStatusTypeTransformer().decode(value);

  static List<ListStatus>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ListStatus] to String,
/// and [decode] dynamic data back to [ListStatus].
class ListStatusTypeTransformer {
  factory ListStatusTypeTransformer() => _instance ??= const ListStatusTypeTransformer._();

  const ListStatusTypeTransformer._();

  String encode(ListStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a ListStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ListStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data.toString()) {
        case r'owned': return ListStatus.owned;
        case r'shared_write': return ListStatus.sharedWrite;
        case r'shared_read': return ListStatus.sharedRead;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ListStatusTypeTransformer] instance.
  static ListStatusTypeTransformer? _instance;
}

