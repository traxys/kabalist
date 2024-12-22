//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetSharesResponse {
  /// Returns a new [GetSharesResponse] instance.
  GetSharesResponse({
    this.publicLink,
    this.sharedWith = const {},
  });

  String? publicLink;

  Map<String, bool> sharedWith;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetSharesResponse &&
    other.publicLink == publicLink &&
    _deepEquality.equals(other.sharedWith, sharedWith);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (publicLink == null ? 0 : publicLink!.hashCode) +
    (sharedWith.hashCode);

  @override
  String toString() => 'GetSharesResponse[publicLink=$publicLink, sharedWith=$sharedWith]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.publicLink != null) {
      json[r'public_link'] = this.publicLink;
    } else {
      json[r'public_link'] = null;
    }
      json[r'shared_with'] = this.sharedWith;
    return json;
  }

  /// Returns a new [GetSharesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetSharesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetSharesResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetSharesResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetSharesResponse(
        publicLink: mapValueOfType<String>(json, r'public_link'),
        sharedWith: mapCastOfType<String, bool>(json, r'shared_with')!,
      );
    }
    return null;
  }

  static List<GetSharesResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetSharesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetSharesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetSharesResponse> mapFromJson(dynamic json) {
    final map = <String, GetSharesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetSharesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetSharesResponse-objects as value to a dart map
  static Map<String, List<GetSharesResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetSharesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetSharesResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'shared_with',
  };
}

