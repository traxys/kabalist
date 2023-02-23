//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OkDeleteListResponse {
  /// Returns a new [OkDeleteListResponse] instance.
  OkDeleteListResponse({
    required this.ok,
  });

  Object ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OkDeleteListResponse &&
     other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'OkDeleteListResponse[ok=$ok]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = this.ok;
    return json;
  }

  /// Returns a new [OkDeleteListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OkDeleteListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OkDeleteListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OkDeleteListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OkDeleteListResponse(
        ok: mapValueOfType<Object>(json, r'ok')!,
      );
    }
    return null;
  }

  static List<OkDeleteListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OkDeleteListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OkDeleteListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OkDeleteListResponse> mapFromJson(dynamic json) {
    final map = <String, OkDeleteListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkDeleteListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OkDeleteListResponse-objects as value to a dart map
  static Map<String, List<OkDeleteListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OkDeleteListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkDeleteListResponse.listFromJson(entry.value, growable: growable,);
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

