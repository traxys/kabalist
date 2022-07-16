//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OkAddToListResponse {
  /// Returns a new [OkAddToListResponse] instance.
  OkAddToListResponse({
    required this.ok,
  });

  AddToListResponse ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OkAddToListResponse &&
     other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'OkAddToListResponse[ok=$ok]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'ok'] = ok;
    return _json;
  }

  /// Returns a new [OkAddToListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OkAddToListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OkAddToListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OkAddToListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OkAddToListResponse(
        ok: AddToListResponse.fromJson(json[r'ok'])!,
      );
    }
    return null;
  }

  static List<OkAddToListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OkAddToListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OkAddToListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OkAddToListResponse> mapFromJson(dynamic json) {
    final map = <String, OkAddToListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkAddToListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OkAddToListResponse-objects as value to a dart map
  static Map<String, List<OkAddToListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OkAddToListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OkAddToListResponse.listFromJson(entry.value, growable: growable,);
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

