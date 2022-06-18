//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateListRequest {
  /// Returns a new [CreateListRequest] instance.
  CreateListRequest({
    @required this.name,
  });

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateListRequest &&
     other.name == name;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (name == null ? 0 : name.hashCode);

  @override
  String toString() => 'CreateListRequest[name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = name;
    return json;
  }

  /// Returns a new [CreateListRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateListRequest fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return CreateListRequest(
        name: mapValueOfType<String>(json, r'name'),
      );
    }
    return null;
  }

  static List<CreateListRequest> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(CreateListRequest.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <CreateListRequest>[];

  static Map<String, CreateListRequest> mapFromJson(dynamic json) {
    final map = <String, CreateListRequest>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = CreateListRequest.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of CreateListRequest-objects as value to a dart map
  static Map<String, List<CreateListRequest>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<CreateListRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = CreateListRequest.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

