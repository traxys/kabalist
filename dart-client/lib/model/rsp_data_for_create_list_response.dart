//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForCreateListResponse {
  /// Returns a new [RspDataForCreateListResponse] instance.
  RspDataForCreateListResponse({
    required this.ok,
    required this.err,
  });

  CreateListResponse ok;

  RspErr err;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForCreateListResponse &&
     other.ok == ok &&
     other.err == err;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode) +
    (err.hashCode);

  @override
  String toString() => 'RspDataForCreateListResponse[ok=$ok, err=$err]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'ok'] = ok;
      _json[r'err'] = err;
    return _json;
  }

  /// Returns a new [RspDataForCreateListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForCreateListResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RspDataForCreateListResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RspDataForCreateListResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RspDataForCreateListResponse(
        ok: CreateListResponse.fromJson(json[r'ok'])!,
        err: RspErr.fromJson(json[r'err'])!,
      );
    }
    return null;
  }

  static List<RspDataForCreateListResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RspDataForCreateListResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RspDataForCreateListResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RspDataForCreateListResponse> mapFromJson(dynamic json) {
    final map = <String, RspDataForCreateListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForCreateListResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RspDataForCreateListResponse-objects as value to a dart map
  static Map<String, List<RspDataForCreateListResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RspDataForCreateListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForCreateListResponse.listFromJson(entry.value, growable: growable,);
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
    'err',
  };
}

