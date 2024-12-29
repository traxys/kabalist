//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListInfo {
  /// Returns a new [ListInfo] instance.
  ListInfo({
    required this.name,
    required this.owner,
    required this.public,
    required this.status,
  });

  String name;

  String owner;

  bool public;

  ListStatus status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListInfo &&
    other.name == name &&
    other.owner == owner &&
    other.public == public &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (owner.hashCode) +
    (public.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'ListInfo[name=$name, owner=$owner, public=$public, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'owner'] = this.owner;
      json[r'public'] = this.public;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [ListInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ListInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ListInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ListInfo(
        name: mapValueOfType<String>(json, r'name')!,
        owner: mapValueOfType<String>(json, r'owner')!,
        public: mapValueOfType<bool>(json, r'public')!,
        status: ListStatus.fromJson(json[r'status'])!,
      );
    }
    return null;
  }

  static List<ListInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListInfo> mapFromJson(dynamic json) {
    final map = <String, ListInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListInfo-objects as value to a dart map
  static Map<String, List<ListInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'owner',
    'public',
    'status',
  };
}

