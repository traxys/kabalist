//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ListApi {
  ListApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/list/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [AddToListRequest] addToListRequest (required):
  Future<Response> addListWithHttpInfo(String id, AddToListRequest addToListRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = addToListRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [AddToListRequest] addToListRequest (required):
  Future<OkAddToListResponse?> addList(String id, AddToListRequest addToListRequest,) async {
    final response = await addListWithHttpInfo(id, addToListRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkAddToListResponse',) as OkAddToListResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/list' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [CreateListRequest] createListRequest (required):
  Future<Response> createListWithHttpInfo(CreateListRequest createListRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list';

    // ignore: prefer_final_locals
    Object? postBody = createListRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [CreateListRequest] createListRequest (required):
  Future<OkLoginResponse?> createList(CreateListRequest createListRequest,) async {
    final response = await createListWithHttpInfo(createListRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkLoginResponse',) as OkLoginResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /api/list/{id}/{item}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  Future<Response> deleteItemWithHttpInfo(String id, int item,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}/{item}'
      .replaceAll('{id}', id)
      .replaceAll('{item}', item.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  Future<OkDeleteItemResponse?> deleteItem(String id, int item,) async {
    final response = await deleteItemWithHttpInfo(id, item,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkDeleteItemResponse',) as OkDeleteItemResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /api/list/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> deleteListWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<OkDeleteListResponse?> deleteList(String id,) async {
    final response = await deleteListWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkDeleteListResponse',) as OkDeleteListResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/list/{id}/public' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> getPublicListWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}/public'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<String?> getPublicList(String id,) async {
    final response = await getPublicListWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/list' operation and returns the [Response].
  Future<Response> listListsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/list';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<OkGetListsResponse?> listLists() async {
    final response = await listListsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkGetListsResponse',) as OkGetListsResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/list/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> readListWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<OkReadListResponse?> readList(String id,) async {
    final response = await readListWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkReadListResponse',) as OkReadListResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /api/list/{id}/public' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> removePublicWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}/public'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<OkRemovePublicResponse?> removePublic(String id,) async {
    final response = await removePublicWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkRemovePublicResponse',) as OkRemovePublicResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /api/list/{id}/public' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> setPublicWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}/public'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<OkSetPublicResponse?> setPublic(String id,) async {
    final response = await setPublicWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkSetPublicResponse',) as OkSetPublicResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PATCH /api/list/{id}/{item}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  ///
  /// * [UpdateItemRequest] updateItemRequest (required):
  Future<Response> updateItemWithHttpInfo(String id, int item, UpdateItemRequest updateItemRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/list/{id}/{item}'
      .replaceAll('{id}', id)
      .replaceAll('{item}', item.toString());

    // ignore: prefer_final_locals
    Object? postBody = updateItemRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  ///
  /// * [UpdateItemRequest] updateItemRequest (required):
  Future<OkUpdateItemResponse?> updateItem(String id, int item, UpdateItemRequest updateItemRequest,) async {
    final response = await updateItemWithHttpInfo(id, item, updateItemRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkUpdateItemResponse',) as OkUpdateItemResponse;
    
    }
    return null;
  }
}
