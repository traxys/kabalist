//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReadListResponse {
  /// Returns a new [ReadListResponse] instance.
  ReadListResponse({
    this.items = const [],
    @required this.readonly,
  });

  List<Item> items;

  bool readonly;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReadListResponse &&
     other.items == items &&
     other.readonly == readonly;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (items == null ? 0 : items.hashCode) +
    (readonly == null ? 0 : readonly.hashCode);

  @override
  String toString() => 'ReadListResponse[items=$items, readonly=$readonly]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = items;
      json[r'readonly'] = readonly;
    return json;
  }

  /// Returns a new [ReadListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReadListResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return ReadListResponse(
        items: Item.listFromJson(json[r'items']),
        readonly: mapValueOfType<bool>(json, r'readonly'),
      );
    }
    return null;
  }

  static List<ReadListResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(ReadListResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <ReadListResponse>[];

  static Map<String, ReadListResponse> mapFromJson(dynamic json) {
    final map = <String, ReadListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = ReadListResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of ReadListResponse-objects as value to a dart map
  static Map<String, List<ReadListResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<ReadListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = ReadListResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

