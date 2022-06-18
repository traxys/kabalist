//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetListsResponse {
  /// Returns a new [GetListsResponse] instance.
  GetListsResponse({
    this.results = const {},
  });

  Map<String, ListInfo> results;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetListsResponse &&
     other.results == results;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (results.hashCode);

  @override
  String toString() => 'GetListsResponse[results=$results]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'results'] = results;
    return _json;
  }

  /// Returns a new [GetListsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetListsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetListsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetListsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetListsResponse(
        results: ListInfo.mapFromJson(json[r'results'!,
      );
    }
    return null;
  }

  static List<GetListsResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetListsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetListsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetListsResponse> mapFromJson(dynamic json) {
    final map = <String, GetListsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetListsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetListsResponse-objects as value to a dart map
  static Map<String, List<GetListsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetListsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetListsResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'results',
  };
}

