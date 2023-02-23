//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OkUnshareResponse {
  /// Returns a new [OkUnshareResponse] instance.
  OkUnshareResponse({
    required this.ok,
  });

  Object ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OkUnshareResponse &&
     other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'OkUnshareResponse[ok=$ok]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = this.ok;
    return json;
  }

  /// Returns a new [OkUnshareResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OkUnshareResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OkUnshareResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OkUnshareResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OkUnshareResponse(
        ok: mapValueOfType<Object>(json, r'ok')!,
      );
    }
    return null;
  }

  static List<OkUnshareResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OkUnshareResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OkUnshareResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OkUnshareResponse> mapFromJson(dynamic json) {
    final map = <String, OkUnshareResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkUnshareResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OkUnshareResponse-objects as value to a dart map
  static Map<String, List<OkUnshareResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OkUnshareResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkUnshareResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ok',
  };
}

