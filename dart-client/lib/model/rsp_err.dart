//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspErr {
  /// Returns a new [RspErr] instance.
  RspErr({
    @required this.code,
    @required this.description,
  });

  // minimum: 0
  int code;

  String description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspErr &&
     other.code == code &&
     other.description == description;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (code == null ? 0 : code.hashCode) +
    (description == null ? 0 : description.hashCode);

  @override
  String toString() => 'RspErr[code=$code, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'code'] = code;
      json[r'description'] = description;
    return json;
  }

  /// Returns a new [RspErr] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspErr fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RspErr(
        code: mapValueOfType<int>(json, r'code'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<RspErr> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RspErr.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RspErr>[];

  static Map<String, RspErr> mapFromJson(dynamic json) {
    final map = <String, RspErr>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RspErr.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RspErr-objects as value to a dart map
  static Map<String, List<RspErr>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RspErr>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RspErr.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

