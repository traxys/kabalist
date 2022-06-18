//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForLoginResponseOneOf1 {
  /// Returns a new [RspDataForLoginResponseOneOf1] instance.
  RspDataForLoginResponseOneOf1({
    @required this.err,
  });

  RspErr err;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForLoginResponseOneOf1 &&
     other.err == err;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (err == null ? 0 : err.hashCode);

  @override
  String toString() => 'RspDataForLoginResponseOneOf1[err=$err]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'err'] = err;
    return json;
  }

  /// Returns a new [RspDataForLoginResponseOneOf1] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForLoginResponseOneOf1 fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RspDataForLoginResponseOneOf1(
        err: RspErr.fromJson(json[r'err']),
      );
    }
    return null;
  }

  static List<RspDataForLoginResponseOneOf1> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RspDataForLoginResponseOneOf1.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RspDataForLoginResponseOneOf1>[];

  static Map<String, RspDataForLoginResponseOneOf1> mapFromJson(dynamic json) {
    final map = <String, RspDataForLoginResponseOneOf1>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RspDataForLoginResponseOneOf1.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RspDataForLoginResponseOneOf1-objects as value to a dart map
  static Map<String, List<RspDataForLoginResponseOneOf1>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RspDataForLoginResponseOneOf1>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RspDataForLoginResponseOneOf1.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

