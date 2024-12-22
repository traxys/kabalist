//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/default_api.dart';
part 'api/list_api.dart';
part 'api/pantry_api.dart';
part 'api/share_api.dart';

part 'model/add_to_list_request.dart';
part 'model/add_to_list_response.dart';
part 'model/add_to_pantry_request.dart';
part 'model/create_list_request.dart';
part 'model/create_list_response.dart';
part 'model/edit_pantry_item_request.dart';
part 'model/err_response.dart';
part 'model/error.dart';
part 'model/get_account_name_response.dart';
part 'model/get_history_response.dart';
part 'model/get_lists_response.dart';
part 'model/get_pantry_response.dart';
part 'model/get_shares_response.dart';
part 'model/item.dart';
part 'model/list_info.dart';
part 'model/list_status.dart';
part 'model/login_request.dart';
part 'model/login_response.dart';
part 'model/ok_response.dart';
part 'model/pantry_item.dart';
part 'model/read_list_response.dart';
part 'model/recover_password_request.dart';
part 'model/recovery_info_response.dart';
part 'model/register_request.dart';
part 'model/search_account_response.dart';
part 'model/share_list_request.dart';
part 'model/update_item_request.dart';
part 'model/user_error.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
