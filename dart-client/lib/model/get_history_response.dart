//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetHistoryResponse {
  /// Returns a new [GetHistoryResponse] instance.
  GetHistoryResponse({
    this.matches = const [],
  });

  List<String> matches;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetHistoryResponse &&
     other.matches == matches;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (matches == null ? 0 : matches.hashCode);

  @override
  String toString() => 'GetHistoryResponse[matches=$matches]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'matches'] = matches;
    return json;
  }

  /// Returns a new [GetHistoryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetHistoryResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return GetHistoryResponse(
        matches: json[r'matches'] is List
          ? (json[r'matches'] as List).cast<String>()
          : null,
      );
    }
    return null;
  }

  static List<GetHistoryResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(GetHistoryResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <GetHistoryResponse>[];

  static Map<String, GetHistoryResponse> mapFromJson(dynamic json) {
    final map = <String, GetHistoryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = GetHistoryResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of GetHistoryResponse-objects as value to a dart map
  static Map<String, List<GetHistoryResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<GetHistoryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = GetHistoryResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

