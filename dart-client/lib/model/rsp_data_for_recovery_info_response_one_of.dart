//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForRecoveryInfoResponseOneOf {
  /// Returns a new [RspDataForRecoveryInfoResponseOneOf] instance.
  RspDataForRecoveryInfoResponseOneOf({
    required this.ok,
  });

  RecoveryInfoResponse ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForRecoveryInfoResponseOneOf &&
     other.ok == ok;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode);

  @override
  String toString() => 'RspDataForRecoveryInfoResponseOneOf[ok=$ok]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'ok'] = ok;
    return _json;
  }

  /// Returns a new [RspDataForRecoveryInfoResponseOneOf] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForRecoveryInfoResponseOneOf? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RspDataForRecoveryInfoResponseOneOf[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RspDataForRecoveryInfoResponseOneOf[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RspDataForRecoveryInfoResponseOneOf(
        ok: RecoveryInfoResponse.fromJson(json[r'ok'])!,
      );
    }
    return null;
  }

  static List<RspDataForRecoveryInfoResponseOneOf>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RspDataForRecoveryInfoResponseOneOf>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RspDataForRecoveryInfoResponseOneOf.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RspDataForRecoveryInfoResponseOneOf> mapFromJson(dynamic json) {
    final map = <String, RspDataForRecoveryInfoResponseOneOf>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForRecoveryInfoResponseOneOf.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RspDataForRecoveryInfoResponseOneOf-objects as value to a dart map
  static Map<String, List<RspDataForRecoveryInfoResponseOneOf>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RspDataForRecoveryInfoResponseOneOf>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForRecoveryInfoResponseOneOf.listFromJson(entry.value, growable: growable,);
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

