//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateListResponse {
  /// Returns a new [CreateListResponse] instance.
  CreateListResponse({
    required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateListResponse &&
     other.id == id;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode);

  @override
  String toString() => 'CreateListResponse[id=$id]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'id'] = id;
    return _json;
  }

  /// Returns a new [CreateListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateListResponse(
        id: mapValueOfType<String>(json, r'id')!,
      );
    }
    return null;
  }

  static List<CreateListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateListResponse> mapFromJson(dynamic json) {
    final map = <String, CreateListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateListResponse-objects as value to a dart map
  static Map<String, List<CreateListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateListResponse.listFromJson(entry.value, growable: growable,);
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

