//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReadListResponse {
  /// Returns a new [ReadListResponse] instance.
  ReadListResponse({
    this.items = const [],
    required this.readonly,
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
    (items.hashCode) +
    (readonly.hashCode);

  @override
  String toString() => 'ReadListResponse[items=$items, readonly=$readonly]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'items'] = this.items;
      json[r'readonly'] = this.readonly;
    return json;
  }

  /// Returns a new [ReadListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReadListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReadListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReadListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReadListResponse(
        items: Item.listFromJson(json[r'items'])!,
        readonly: mapValueOfType<bool>(json, r'readonly')!,
      );
    }
    return null;
  }

  static List<ReadListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReadListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReadListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReadListResponse> mapFromJson(dynamic json) {
    final map = <String, ReadListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReadListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReadListResponse-objects as value to a dart map
  static Map<String, List<ReadListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReadListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReadListResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'items',
    'readonly',
  };
}

