//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ShareListRequest {
  /// Returns a new [ShareListRequest] instance.
  ShareListRequest({
    required this.readonly,
    required this.shareWith,
  });

  bool readonly;

  String shareWith;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ShareListRequest &&
    other.readonly == readonly &&
    other.shareWith == shareWith;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (readonly.hashCode) +
    (shareWith.hashCode);

  @override
  String toString() => 'ShareListRequest[readonly=$readonly, shareWith=$shareWith]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'readonly'] = this.readonly;
      json[r'share_with'] = this.shareWith;
    return json;
  }

  /// Returns a new [ShareListRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ShareListRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ShareListRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ShareListRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ShareListRequest(
        readonly: mapValueOfType<bool>(json, r'readonly')!,
        shareWith: mapValueOfType<String>(json, r'share_with')!,
      );
    }
    return null;
  }

  static List<ShareListRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ShareListRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ShareListRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ShareListRequest> mapFromJson(dynamic json) {
    final map = <String, ShareListRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ShareListRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ShareListRequest-objects as value to a dart map
  static Map<String, List<ShareListRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ShareListRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ShareListRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'readonly',
    'share_with',
  };
}

