//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OkGetListsResponse {
  /// Returns a new [OkGetListsResponse] instance.
  OkGetListsResponse({
    required this.ok,
  });

  GetListsResponse ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OkGetListsResponse &&
    other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'OkGetListsResponse[ok=$ok]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = this.ok;
    return json;
  }

  /// Returns a new [OkGetListsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OkGetListsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OkGetListsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OkGetListsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OkGetListsResponse(
        ok: GetListsResponse.fromJson(json[r'ok'])!,
      );
    }
    return null;
  }

  static List<OkGetListsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OkGetListsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OkGetListsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OkGetListsResponse> mapFromJson(dynamic json) {
    final map = <String, OkGetListsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkGetListsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OkGetListsResponse-objects as value to a dart map
  static Map<String, List<OkGetListsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OkGetListsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OkGetListsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'ok',
  };
}

