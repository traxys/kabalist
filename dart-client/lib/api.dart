//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

part 'api/kaba_list_api.dart';

part 'model/add_to_list_request.dart';
part 'model/add_to_list_response.dart';
part 'model/create_list_request.dart';
part 'model/create_list_response.dart';
part 'model/get_account_name_response.dart';
part 'model/get_history_response.dart';
part 'model/get_lists_response.dart';
part 'model/get_shares_response.dart';
part 'model/item.dart';
part 'model/list_info.dart';
part 'model/list_status.dart';
part 'model/login_request.dart';
part 'model/login_response.dart';
part 'model/read_list_response.dart';
part 'model/recover_password_request.dart';
part 'model/recovery_info_response.dart';
part 'model/register_request.dart';
part 'model/rsp_data_for_add_to_list_response.dart';
part 'model/rsp_data_for_add_to_list_response_one_of.dart';
part 'model/rsp_data_for_create_list_response.dart';
part 'model/rsp_data_for_create_list_response_one_of.dart';
part 'model/rsp_data_for_empty.dart';
part 'model/rsp_data_for_empty_one_of.dart';
part 'model/rsp_data_for_get_account_name_response.dart';
part 'model/rsp_data_for_get_account_name_response_one_of.dart';
part 'model/rsp_data_for_get_history_response.dart';
part 'model/rsp_data_for_get_history_response_one_of.dart';
part 'model/rsp_data_for_get_lists_response.dart';
part 'model/rsp_data_for_get_lists_response_one_of.dart';
part 'model/rsp_data_for_get_shares_response.dart';
part 'model/rsp_data_for_get_shares_response_one_of.dart';
part 'model/rsp_data_for_login_response.dart';
part 'model/rsp_data_for_login_response_one_of.dart';
part 'model/rsp_data_for_login_response_one_of1.dart';
part 'model/rsp_data_for_read_list_response.dart';
part 'model/rsp_data_for_read_list_response_one_of.dart';
part 'model/rsp_data_for_recovery_info_response.dart';
part 'model/rsp_data_for_recovery_info_response_one_of.dart';
part 'model/rsp_data_for_search_account_response.dart';
part 'model/rsp_data_for_search_account_response_one_of.dart';
part 'model/rsp_err.dart';
part 'model/search_account_response.dart';
part 'model/share_list_request.dart';
part 'model/update_item_request.dart';


const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ApiClient defaultApiClient = ApiClient();
