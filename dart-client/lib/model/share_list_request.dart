//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ShareListRequest {
  /// Returns a new [ShareListRequest] instance.
  ShareListRequest({
    @required this.shareWith,
    @required this.readonly,
  });

  String shareWith;

  bool readonly;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ShareListRequest &&
     other.shareWith == shareWith &&
     other.readonly == readonly;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (shareWith == null ? 0 : shareWith.hashCode) +
    (readonly == null ? 0 : readonly.hashCode);

  @override
  String toString() => 'ShareListRequest[shareWith=$shareWith, readonly=$readonly]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'share_with'] = shareWith;
      json[r'readonly'] = readonly;
    return json;
  }

  /// Returns a new [ShareListRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ShareListRequest fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return ShareListRequest(
        shareWith: mapValueOfType<String>(json, r'share_with'),
        readonly: mapValueOfType<bool>(json, r'readonly'),
      );
    }
    return null;
  }

  static List<ShareListRequest> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(ShareListRequest.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <ShareListRequest>[];

  static Map<String, ShareListRequest> mapFromJson(dynamic json) {
    final map = <String, ShareListRequest>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = ShareListRequest.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of ShareListRequest-objects as value to a dart map
  static Map<String, List<ShareListRequest>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<ShareListRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = ShareListRequest.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

