//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddToListResponse {
  /// Returns a new [AddToListResponse] instance.
  AddToListResponse({
    @required this.id,
  });

  int id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddToListResponse &&
     other.id == id;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode);

  @override
  String toString() => 'AddToListResponse[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    return json;
  }

  /// Returns a new [AddToListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddToListResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return AddToListResponse(
        id: mapValueOfType<int>(json, r'id'),
      );
    }
    return null;
  }

  static List<AddToListResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(AddToListResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <AddToListResponse>[];

  static Map<String, AddToListResponse> mapFromJson(dynamic json) {
    final map = <String, AddToListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = AddToListResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of AddToListResponse-objects as value to a dart map
  static Map<String, List<AddToListResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<AddToListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = AddToListResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

