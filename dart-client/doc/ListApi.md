# kabalist_client.api.ListApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addList**](ListApi.md#addlist) | **POST** /api/list/{id} | 
[**createList**](ListApi.md#createlist) | **POST** /api/list | 
[**deleteItem**](ListApi.md#deleteitem) | **DELETE** /api/list/{id}/{item} | 
[**deleteList**](ListApi.md#deletelist) | **DELETE** /api/list/{id} | 
[**getPublicList**](ListApi.md#getpubliclist) | **GET** /api/list/{id}/public | 
[**listLists**](ListApi.md#listlists) | **GET** /api/list | 
[**readList**](ListApi.md#readlist) | **GET** /api/list/{id} | 
[**removePublic**](ListApi.md#removepublic) | **DELETE** /api/list/{id}/public | 
[**setPublic**](ListApi.md#setpublic) | **PUT** /api/list/{id}/public | 
[**updateItem**](ListApi.md#updateitem) | **PATCH** /api/list/{id}/{item} | 


# **addList**
> OkAddToListResponse addList(id, addToListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final addToListRequest = AddToListRequest(); // AddToListRequest | 

try {
    final result = api_instance.addList(id, addToListRequest);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->addList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **addToListRequest** | [**AddToListRequest**](AddToListRequest.md)|  | 

### Return type

[**OkAddToListResponse**](OkAddToListResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createList**
> OkLoginResponse createList(createListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final createListRequest = CreateListRequest(); // CreateListRequest | 

try {
    final result = api_instance.createList(createListRequest);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->createList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createListRequest** | [**CreateListRequest**](CreateListRequest.md)|  | 

### Return type

[**OkLoginResponse**](OkLoginResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteItem**
> OkDeleteItemResponse deleteItem(id, item)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final item = 56; // int | Item ID

try {
    final result = api_instance.deleteItem(id, item);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->deleteItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **item** | **int**| Item ID | 

### Return type

[**OkDeleteItemResponse**](OkDeleteItemResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteList**
> OkDeleteListResponse deleteList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.deleteList(id);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->deleteList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkDeleteListResponse**](OkDeleteListResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPublicList**
> String getPublicList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.getPublicList(id);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->getPublicList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/html, text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLists**
> OkGetListsResponse listLists()



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();

try {
    final result = api_instance.listLists();
    print(result);
} catch (e) {
    print('Exception when calling ListApi->listLists: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OkGetListsResponse**](OkGetListsResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readList**
> OkReadListResponse readList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.readList(id);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->readList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkReadListResponse**](OkReadListResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removePublic**
> OkRemovePublicResponse removePublic(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.removePublic(id);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->removePublic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkRemovePublicResponse**](OkRemovePublicResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setPublic**
> OkSetPublicResponse setPublic(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.setPublic(id);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->setPublic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkSetPublicResponse**](OkSetPublicResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateItem**
> OkUpdateItemResponse updateItem(id, item, updateItemRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final item = 56; // int | Item ID
final updateItemRequest = UpdateItemRequest(); // UpdateItemRequest | 

try {
    final result = api_instance.updateItem(id, item, updateItemRequest);
    print(result);
} catch (e) {
    print('Exception when calling ListApi->updateItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **item** | **int**| Item ID | 
 **updateItemRequest** | [**UpdateItemRequest**](UpdateItemRequest.md)|  | 

### Return type

[**OkUpdateItemResponse**](OkUpdateItemResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

