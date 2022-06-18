//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Item {
  /// Returns a new [Item] instance.
  Item({
    @required this.id,
    @required this.name,
    this.amount,
  });

  int id;

  String name;

  String amount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Item &&
     other.id == id &&
     other.name == name &&
     other.amount == amount;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (name == null ? 0 : name.hashCode) +
    (amount == null ? 0 : amount.hashCode);

  @override
  String toString() => 'Item[id=$id, name=$name, amount=$amount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
      json[r'name'] = name;
    if (amount != null) {
      json[r'amount'] = amount;
    }
    return json;
  }

  /// Returns a new [Item] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Item fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Item(
        id: mapValueOfType<int>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        amount: mapValueOfType<String>(json, r'amount'),
      );
    }
    return null;
  }

  static List<Item> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Item.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Item>[];

  static Map<String, Item> mapFromJson(dynamic json) {
    final map = <String, Item>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Item.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Item-objects as value to a dart map
  static Map<String, List<Item>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<Item>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Item.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

