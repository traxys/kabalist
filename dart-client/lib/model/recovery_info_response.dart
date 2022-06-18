//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecoveryInfoResponse {
  /// Returns a new [RecoveryInfoResponse] instance.
  RecoveryInfoResponse({
    @required this.username,
  });

  String username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecoveryInfoResponse &&
     other.username == username;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (username == null ? 0 : username.hashCode);

  @override
  String toString() => 'RecoveryInfoResponse[username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'username'] = username;
    return json;
  }

  /// Returns a new [RecoveryInfoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecoveryInfoResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RecoveryInfoResponse(
        username: mapValueOfType<String>(json, r'username'),
      );
    }
    return null;
  }

  static List<RecoveryInfoResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RecoveryInfoResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RecoveryInfoResponse>[];

  static Map<String, RecoveryInfoResponse> mapFromJson(dynamic json) {
    final map = <String, RecoveryInfoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RecoveryInfoResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RecoveryInfoResponse-objects as value to a dart map
  static Map<String, List<RecoveryInfoResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RecoveryInfoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RecoveryInfoResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

