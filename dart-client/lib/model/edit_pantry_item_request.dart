//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EditPantryItemRequest {
  /// Returns a new [EditPantryItemRequest] instance.
  EditPantryItemRequest({
    this.amount,
    this.target,
  });

  int? amount;

  int? target;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EditPantryItemRequest &&
    other.amount == amount &&
    other.target == target;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amount == null ? 0 : amount!.hashCode) +
    (target == null ? 0 : target!.hashCode);

  @override
  String toString() => 'EditPantryItemRequest[amount=$amount, target=$target]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
    if (this.target != null) {
      json[r'target'] = this.target;
    } else {
      json[r'target'] = null;
    }
    return json;
  }

  /// Returns a new [EditPantryItemRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EditPantryItemRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EditPantryItemRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EditPantryItemRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EditPantryItemRequest(
        amount: mapValueOfType<int>(json, r'amount'),
        target: mapValueOfType<int>(json, r'target'),
      );
    }
    return null;
  }

  static List<EditPantryItemRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EditPantryItemRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EditPantryItemRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EditPantryItemRequest> mapFromJson(dynamic json) {
    final map = <String, EditPantryItemRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EditPantryItemRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EditPantryItemRequest-objects as value to a dart map
  static Map<String, List<EditPantryItemRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EditPantryItemRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EditPantryItemRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

