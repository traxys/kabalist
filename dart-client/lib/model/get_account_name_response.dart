//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetAccountNameResponse {
  /// Returns a new [GetAccountNameResponse] instance.
  GetAccountNameResponse({
    @required this.username,
  });

  String username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetAccountNameResponse &&
     other.username == username;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (username == null ? 0 : username.hashCode);

  @override
  String toString() => 'GetAccountNameResponse[username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'username'] = username;
    return json;
  }

  /// Returns a new [GetAccountNameResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetAccountNameResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return GetAccountNameResponse(
        username: mapValueOfType<String>(json, r'username'),
      );
    }
    return null;
  }

  static List<GetAccountNameResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(GetAccountNameResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <GetAccountNameResponse>[];

  static Map<String, GetAccountNameResponse> mapFromJson(dynamic json) {
    final map = <String, GetAccountNameResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = GetAccountNameResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of GetAccountNameResponse-objects as value to a dart map
  static Map<String, List<GetAccountNameResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<GetAccountNameResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = GetAccountNameResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

