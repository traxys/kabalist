//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SearchAccountResponse {
  /// Returns a new [SearchAccountResponse] instance.
  SearchAccountResponse({
    @required this.id,
  });

  String id;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SearchAccountResponse &&
     other.id == id;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode);

  @override
  String toString() => 'SearchAccountResponse[id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    return json;
  }

  /// Returns a new [SearchAccountResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SearchAccountResponse fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return SearchAccountResponse(
        id: mapValueOfType<String>(json, r'id'),
      );
    }
    return null;
  }

  static List<SearchAccountResponse> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(SearchAccountResponse.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <SearchAccountResponse>[];

  static Map<String, SearchAccountResponse> mapFromJson(dynamic json) {
    final map = <String, SearchAccountResponse>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = SearchAccountResponse.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of SearchAccountResponse-objects as value to a dart map
  static Map<String, List<SearchAccountResponse>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<SearchAccountResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = SearchAccountResponse.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

