//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddToListRequest {
  /// Returns a new [AddToListRequest] instance.
  AddToListRequest({
    this.amount,
    required this.name,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? amount;

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddToListRequest &&
     other.amount == amount &&
     other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amount == null ? 0 : amount!.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'AddToListRequest[amount=$amount, name=$name]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
    if (amount != null) {
      _json[r'amount'] = amount;
    }
      _json[r'name'] = name;
    return _json;
  }

  /// Returns a new [AddToListRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddToListRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AddToListRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AddToListRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AddToListRequest(
        amount: mapValueOfType<String>(json, r'amount'),
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<AddToListRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddToListRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddToListRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddToListRequest> mapFromJson(dynamic json) {
    final map = <String, AddToListRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToListRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddToListRequest-objects as value to a dart map
  static Map<String, List<AddToListRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddToListRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToListRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

