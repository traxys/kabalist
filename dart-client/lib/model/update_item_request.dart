//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateItemRequest {
  /// Returns a new [UpdateItemRequest] instance.
  UpdateItemRequest({
    this.name,
    this.amount,
  });

  String? name;

  String? amount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateItemRequest &&
     other.name == name &&
     other.amount == amount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (amount == null ? 0 : amount!.hashCode);

  @override
  String toString() => 'UpdateItemRequest[name=$name, amount=$amount]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
    if (name != null) {
      _json[r'name'] = name;
    }
    if (amount != null) {
      _json[r'amount'] = amount;
    }
    return _json;
  }

  /// Returns a new [UpdateItemRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateItemRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateItemRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateItemRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateItemRequest(
        name: mapValueOfType<String>(json, r'name'),
        amount: mapValueOfType<String>(json, r'amount'),
      );
    }
    return null;
  }

  static List<UpdateItemRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateItemRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateItemRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateItemRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateItemRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateItemRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateItemRequest-objects as value to a dart map
  static Map<String, List<UpdateItemRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateItemRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateItemRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

