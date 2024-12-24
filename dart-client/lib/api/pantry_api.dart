//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PantryApi {
  PantryApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/pantry/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [AddToPantryRequest] addToPantryRequest (required):
  Future<Response> addToPantryWithHttpInfo(String id, AddToPantryRequest addToPantryRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pantry/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = addToPantryRequest;

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
  /// * [AddToPantryRequest] addToPantryRequest (required):
  Future<OkAddToPantryResponse?> addToPantry(String id, AddToPantryRequest addToPantryRequest,) async {
    final response = await addToPantryWithHttpInfo(id, addToPantryRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkAddToPantryResponse',) as OkAddToPantryResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /api/pantry/{id}/{item}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  Future<Response> deletePantryItemWithHttpInfo(String id, int item,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pantry/{id}/{item}'
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
  Future<OkDeletePantryItemResponse?> deletePantryItem(String id, int item,) async {
    final response = await deletePantryItemWithHttpInfo(id, item,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkDeletePantryItemResponse',) as OkDeletePantryItemResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/pantry/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> getPantryWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pantry/{id}'
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
  Future<OkGetPantryResponse?> getPantry(String id,) async {
    final response = await getPantryWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkGetPantryResponse',) as OkGetPantryResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/pantry/{id}/refill' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  Future<Response> refillPantryWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pantry/{id}/refill'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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
  Future<OkRefillPantryResponse?> refillPantry(String id,) async {
    final response = await refillPantryWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkRefillPantryResponse',) as OkRefillPantryResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PATCH /api/pantry/{id}/{item}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   List ID
  ///
  /// * [int] item (required):
  ///   Item ID
  ///
  /// * [EditPantryItemRequest] editPantryItemRequest (required):
  Future<Response> setPantryItemWithHttpInfo(String id, int item, EditPantryItemRequest editPantryItemRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/pantry/{id}/{item}'
      .replaceAll('{id}', id)
      .replaceAll('{item}', item.toString());

    // ignore: prefer_final_locals
    Object? postBody = editPantryItemRequest;

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
  /// * [EditPantryItemRequest] editPantryItemRequest (required):
  Future<OkEditPantryItemResponse?> setPantryItem(String id, int item, EditPantryItemRequest editPantryItemRequest,) async {
    final response = await setPantryItemWithHttpInfo(id, item, editPantryItemRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OkEditPantryItemResponse',) as OkEditPantryItemResponse;
    
    }
    return null;
  }
}
