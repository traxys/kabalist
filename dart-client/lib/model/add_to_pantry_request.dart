//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddToPantryRequest {
  /// Returns a new [AddToPantryRequest] instance.
  AddToPantryRequest({
    required this.name,
    required this.target,
  });

  String name;

  int target;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddToPantryRequest &&
     other.name == name &&
     other.target == target;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (target.hashCode);

  @override
  String toString() => 'AddToPantryRequest[name=$name, target=$target]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'name'] = name;
      _json[r'target'] = target;
    return _json;
  }

  /// Returns a new [AddToPantryRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddToPantryRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AddToPantryRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AddToPantryRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AddToPantryRequest(
        name: mapValueOfType<String>(json, r'name')!,
        target: mapValueOfType<int>(json, r'target')!,
      );
    }
    return null;
  }

  static List<AddToPantryRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddToPantryRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddToPantryRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddToPantryRequest> mapFromJson(dynamic json) {
    final map = <String, AddToPantryRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToPantryRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddToPantryRequest-objects as value to a dart map
  static Map<String, List<AddToPantryRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddToPantryRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToPantryRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'target',
  };
}

