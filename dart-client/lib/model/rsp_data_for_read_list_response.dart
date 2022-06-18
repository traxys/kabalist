//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForReadListResponse {
  /// Returns a new [RspDataForReadListResponse] instance.
  RspDataForReadListResponse({
    @required this.ok,
    @required this.err,
  });

  ReadListResponse ok;

  RspErr err;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForReadListResponse &&
     other.ok == ok &&
     other.err == err;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (ok == null ? 0 : ok.hashCode) +
    (err == null ? 0 : err.hashCode);

  @override
  String toString() => 'RspDataForReadListResponse[ok=$ok, err=$err]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = ok;
      json[r'err'] = err;
    return json;
  }

  /// Returns a new [RspDataForReadListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForReadListResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RspDataForReadListResponse(
        ok: ReadListResponse.fromJson(json[r'ok']),
        err: RspErr.fromJson(json[r'err']),
      );
    }
    return null;
  }

  static List<RspDataForReadListResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RspDataForReadListResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RspDataForReadListResponse>[];

  static Map<String, RspDataForReadListResponse> mapFromJson(dynamic json) {
    final map = <String, RspDataForReadListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RspDataForReadListResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RspDataForReadListResponse-objects as value to a dart map
  static Map<String, List<RspDataForReadListResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RspDataForReadListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RspDataForReadListResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

