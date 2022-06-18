//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateListResponse {
  /// Returns a new [CreateListResponse] instance.
  CreateListResponse({
    @required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateListResponse &&
     other.id == id;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode);

  @override
  String toString() => 'CreateListResponse[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    return json;
  }

  /// Returns a new [CreateListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateListResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return CreateListResponse(
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<CreateListResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(CreateListResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <CreateListResponse>[];

  static Map<String, CreateListResponse> mapFromJson(dynamic json) {
    final map = <String, CreateListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = CreateListResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of CreateListResponse-objects as value to a dart map
  static Map<String, List<CreateListResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<CreateListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = CreateListResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

