//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PantryItem {
  /// Returns a new [PantryItem] instance.
  PantryItem({
    required this.amount,
    required this.id,
    required this.name,
    required this.target,
  });

  int amount;

  int id;

  String name;

  int target;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PantryItem &&
    other.amount == amount &&
    other.id == id &&
    other.name == name &&
    other.target == target;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (amount.hashCode) +
    (id.hashCode) +
    (name.hashCode) +
    (target.hashCode);

  @override
  String toString() => 'PantryItem[amount=$amount, id=$id, name=$name, target=$target]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'amount'] = this.amount;
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'target'] = this.target;
    return json;
  }

  /// Returns a new [PantryItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PantryItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PantryItem[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PantryItem[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PantryItem(
        amount: mapValueOfType<int>(json, r'amount')!,
        id: mapValueOfType<int>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        target: mapValueOfType<int>(json, r'target')!,
      );
    }
    return null;
  }

  static List<PantryItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PantryItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PantryItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PantryItem> mapFromJson(dynamic json) {
    final map = <String, PantryItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PantryItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PantryItem-objects as value to a dart map
  static Map<String, List<PantryItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PantryItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PantryItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'amount',
    'id',
    'name',
    'target',
  };
}

