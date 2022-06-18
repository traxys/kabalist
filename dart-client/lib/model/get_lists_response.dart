//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetListsResponse {
  /// Returns a new [GetListsResponse] instance.
  GetListsResponse({
    this.results = const {},
  });

  Map<String, ListInfo> results;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetListsResponse &&
     other.results == results;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (results == null ? 0 : results.hashCode);

  @override
  String toString() => 'GetListsResponse[results=$results]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'results'] = results;
    return json;
  }

  /// Returns a new [GetListsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetListsResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return GetListsResponse(
        results: mapValueOfType<Map<String, ListInfo>>(json, r'results'),
      );
    }
    return null;
  }

  static List<GetListsResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(GetListsResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <GetListsResponse>[];

  static Map<String, GetListsResponse> mapFromJson(dynamic json) {
    final map = <String, GetListsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = GetListsResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of GetListsResponse-objects as value to a dart map
  static Map<String, List<GetListsResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<GetListsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = GetListsResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

