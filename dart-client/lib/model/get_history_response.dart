//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetHistoryResponse {
  /// Returns a new [GetHistoryResponse] instance.
  GetHistoryResponse({
    this.matches = const [],
  });

  List<String> matches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetHistoryResponse &&
     other.matches == matches;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (matches.hashCode);

  @override
  String toString() => 'GetHistoryResponse[matches=$matches]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'matches'] = matches;
    return _json;
  }

  /// Returns a new [GetHistoryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetHistoryResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetHistoryResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetHistoryResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetHistoryResponse(
        matches: json[r'matches'] is List
            ? (json[r'matches'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }

  static List<GetHistoryResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetHistoryResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetHistoryResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetHistoryResponse> mapFromJson(dynamic json) {
    final map = <String, GetHistoryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetHistoryResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetHistoryResponse-objects as value to a dart map
  static Map<String, List<GetHistoryResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetHistoryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetHistoryResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'matches',
  };
}

