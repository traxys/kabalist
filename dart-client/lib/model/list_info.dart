//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListInfo {
  /// Returns a new [ListInfo] instance.
  ListInfo({
    @required this.id,
    @required this.status,
    @required this.public,
  });

  String id;

  ListStatus status;

  bool public;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListInfo &&
     other.id == id &&
     other.status == status &&
     other.public == public;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (status == null ? 0 : status.hashCode) +
    (public == null ? 0 : public.hashCode);

  @override
  String toString() => 'ListInfo[id=$id, status=$status, public=$public]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
      json[r'status'] = status;
      json[r'public'] = public;
    return json;
  }

  /// Returns a new [ListInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListInfo fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return ListInfo(
        id: mapValueOfType<String>(json, r'id'),
        status: ListStatus.fromJson(json[r'status']),
        public: mapValueOfType<bool>(json, r'public'),
      );
    }
    return null;
  }

  static List<ListInfo> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(ListInfo.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <ListInfo>[];

  static Map<String, ListInfo> mapFromJson(dynamic json) {
    final map = <String, ListInfo>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = ListInfo.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of ListInfo-objects as value to a dart map
  static Map<String, List<ListInfo>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<ListInfo>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = ListInfo.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

