//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspErr {
  /// Returns a new [RspErr] instance.
  RspErr({
    required this.code,
    required this.description,
  });

  /// Minimum value: 0
  int code;

  String description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspErr &&
     other.code == code &&
     other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (code.hashCode) +
    (description.hashCode);

  @override
  String toString() => 'RspErr[code=$code, description=$description]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'code'] = code;
      _json[r'description'] = description;
    return _json;
  }

  /// Returns a new [RspErr] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspErr? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RspErr[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RspErr[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RspErr(
        code: mapValueOfType<int>(json, r'code')!,
        description: mapValueOfType<String>(json, r'description')!,
      );
    }
    return null;
  }

  static List<RspErr>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RspErr>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RspErr.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RspErr> mapFromJson(dynamic json) {
    final map = <String, RspErr>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspErr.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RspErr-objects as value to a dart map
  static Map<String, List<RspErr>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RspErr>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspErr.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'description',
  };
}

