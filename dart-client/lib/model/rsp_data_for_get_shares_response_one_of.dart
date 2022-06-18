//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForGetSharesResponseOneOf {
  /// Returns a new [RspDataForGetSharesResponseOneOf] instance.
  RspDataForGetSharesResponseOneOf({
    @required this.ok,
  });

  GetSharesResponse ok;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForGetSharesResponseOneOf &&
     other.ok == ok;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (ok == null ? 0 : ok.hashCode);

  @override
  String toString() => 'RspDataForGetSharesResponseOneOf[ok=$ok]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = ok;
    return json;
  }

  /// Returns a new [RspDataForGetSharesResponseOneOf] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForGetSharesResponseOneOf fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RspDataForGetSharesResponseOneOf(
        ok: GetSharesResponse.fromJson(json[r'ok']),
      );
    }
    return null;
  }

  static List<RspDataForGetSharesResponseOneOf> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RspDataForGetSharesResponseOneOf.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RspDataForGetSharesResponseOneOf>[];

  static Map<String, RspDataForGetSharesResponseOneOf> mapFromJson(dynamic json) {
    final map = <String, RspDataForGetSharesResponseOneOf>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RspDataForGetSharesResponseOneOf.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RspDataForGetSharesResponseOneOf-objects as value to a dart map
  static Map<String, List<RspDataForGetSharesResponseOneOf>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RspDataForGetSharesResponseOneOf>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RspDataForGetSharesResponseOneOf.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

