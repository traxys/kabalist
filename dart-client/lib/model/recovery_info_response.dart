//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecoveryInfoResponse {
  /// Returns a new [RecoveryInfoResponse] instance.
  RecoveryInfoResponse({
    required this.username,
  });

  String username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecoveryInfoResponse &&
     other.username == username;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (username.hashCode);

  @override
  String toString() => 'RecoveryInfoResponse[username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [RecoveryInfoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecoveryInfoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecoveryInfoResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecoveryInfoResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecoveryInfoResponse(
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<RecoveryInfoResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecoveryInfoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecoveryInfoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecoveryInfoResponse> mapFromJson(dynamic json) {
    final map = <String, RecoveryInfoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecoveryInfoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecoveryInfoResponse-objects as value to a dart map
  static Map<String, List<RecoveryInfoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecoveryInfoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecoveryInfoResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'username',
  };
}

