//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RspDataForAddToListResponse {
  /// Returns a new [RspDataForAddToListResponse] instance.
  RspDataForAddToListResponse({
    @required this.ok,
    @required this.err,
  });

  AddToListResponse ok;

  RspErr err;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RspDataForAddToListResponse &&
     other.ok == ok &&
     other.err == err;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (ok == null ? 0 : ok.hashCode) +
    (err == null ? 0 : err.hashCode);

  @override
  String toString() => 'RspDataForAddToListResponse[ok=$ok, err=$err]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'ok'] = ok;
      json[r'err'] = err;
    return json;
  }

  /// Returns a new [RspDataForAddToListResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RspDataForAddToListResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return RspDataForAddToListResponse(
        ok: AddToListResponse.fromJson(json[r'ok']),
        err: RspErr.fromJson(json[r'err']),
      );
    }
    return null;
  }

  static List<RspDataForAddToListResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(RspDataForAddToListResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <RspDataForAddToListResponse>[];

  static Map<String, RspDataForAddToListResponse> mapFromJson(dynamic json) {
    final map = <String, RspDataForAddToListResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = RspDataForAddToListResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of RspDataForAddToListResponse-objects as value to a dart map
  static Map<String, List<RspDataForAddToListResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<RspDataForAddToListResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = RspDataForAddToListResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

