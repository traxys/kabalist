//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OkReadListResponse {
  /// Returns a new [OkReadListResponse] instance.
  OkReadListResponse({
    required this.ok,
  });

  ReadListResponse ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OkReadListResponse &&
    other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'OkReadListResponse[ok=$ok]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = this.ok;
    return json;
  }

  /// Returns a new [OkReadListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OkReadListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OkReadListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OkReadListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OkReadListResponse(
        ok: ReadListResponse.fromJson(json[r'ok'])!,
      );
    }
    return null;
  }

  static List<OkReadListResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OkReadListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OkReadListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OkReadListResponse> mapFromJson(dynamic json) {
    final map = <String, OkReadListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkReadListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OkReadListResponse-objects as value to a dart map
  static Map<String, List<OkReadListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OkReadListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OkReadListResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ok',
  };
}

