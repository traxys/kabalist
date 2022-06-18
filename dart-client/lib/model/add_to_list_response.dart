//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddToListResponse {
  /// Returns a new [AddToListResponse] instance.
  AddToListResponse({
    required this.id,
  });

  int id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddToListResponse &&
     other.id == id;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode);

  @override
  String toString() => 'AddToListResponse[id=$id]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'id'] = id;
    return _json;
  }

  /// Returns a new [AddToListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddToListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AddToListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AddToListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AddToListResponse(
        id: mapValueOfType<int>(json, r'id')!,
      );
    }
    return null;
  }

  static List<AddToListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddToListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddToListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddToListResponse> mapFromJson(dynamic json) {
    final map = <String, AddToListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddToListResponse-objects as value to a dart map
  static Map<String, List<AddToListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddToListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToListResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

