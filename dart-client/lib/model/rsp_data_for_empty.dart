//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForEmpty {
  /// Returns a new [RspDataForEmpty] instance.
  RspDataForEmpty({
    required this.ok,
    required this.err,
  });

  Object ok;

  RspErr err;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForEmpty &&
     other.ok == ok &&
     other.err == err;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (ok.hashCode) +
    (err.hashCode);

  @override
  String toString() => 'RspDataForEmpty[ok=$ok, err=$err]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
      _json[r'ok'] = ok;
      _json[r'err'] = err;
    return _json;
  }

  /// Returns a new [RspDataForEmpty] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForEmpty? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RspDataForEmpty[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RspDataForEmpty[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RspDataForEmpty(
        ok: mapValueOfType<Object>(json, r'ok')!,
        err: RspErr.fromJson(json[r'err'])!,
      );
    }
    return null;
  }

  static List<RspDataForEmpty>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RspDataForEmpty>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RspDataForEmpty.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RspDataForEmpty> mapFromJson(dynamic json) {
    final map = <String, RspDataForEmpty>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForEmpty.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RspDataForEmpty-objects as value to a dart map
  static Map<String, List<RspDataForEmpty>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RspDataForEmpty>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RspDataForEmpty.listFromJson(entry.value, growable: growable,);
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

