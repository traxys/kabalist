# kabalist_client.api.PantryApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addToPantry**](PantryApi.md#addtopantry) | **POST** /api/pantry/{id} | 
[**deletePantryItem**](PantryApi.md#deletepantryitem) | **DELETE** /api/pantry/{id}/{item} | 
[**getPantry**](PantryApi.md#getpantry) | **GET** /api/pantry/{id} | 
[**refillPantry**](PantryApi.md#refillpantry) | **POST** /api/pantry/{id}/refill | 
[**setPantryItem**](PantryApi.md#setpantryitem) | **PATCH** /api/pantry/{id}/{item} | 


# **addToPantry**
> OkAddToPantryResponse addToPantry(id, addToPantryRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PantryApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final addToPantryRequest = AddToPantryRequest(); // AddToPantryRequest | 

try {
    final result = api_instance.addToPantry(id, addToPantryRequest);
    print(result);
} catch (e) {
    print('Exception when calling PantryApi->addToPantry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **addToPantryRequest** | [**AddToPantryRequest**](AddToPantryRequest.md)|  | 

### Return type

[**OkAddToPantryResponse**](OkAddToPantryResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePantryItem**
> OkDeletePantryItemResponse deletePantryItem(id, item)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PantryApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final item = 56; // int | Item ID

try {
    final result = api_instance.deletePantryItem(id, item);
    print(result);
} catch (e) {
    print('Exception when calling PantryApi->deletePantryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **item** | **int**| Item ID | 

### Return type

[**OkDeletePantryItemResponse**](OkDeletePantryItemResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPantry**
> OkGetPantryResponse getPantry(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PantryApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.getPantry(id);
    print(result);
} catch (e) {
    print('Exception when calling PantryApi->getPantry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkGetPantryResponse**](OkGetPantryResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refillPantry**
> OkRefillPantryResponse refillPantry(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PantryApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.refillPantry(id);
    print(result);
} catch (e) {
    print('Exception when calling PantryApi->refillPantry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkRefillPantryResponse**](OkRefillPantryResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setPantryItem**
> OkEditPantryItemResponse setPantryItem(id, item, editPantryItemRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PantryApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final item = 56; // int | Item ID
final editPantryItemRequest = EditPantryItemRequest(); // EditPantryItemRequest | 

try {
    final result = api_instance.setPantryItem(id, item, editPantryItemRequest);
    print(result);
} catch (e) {
    print('Exception when calling PantryApi->setPantryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **item** | **int**| Item ID | 
 **editPantryItemRequest** | [**EditPantryItemRequest**](EditPantryItemRequest.md)|  | 

### Return type

[**OkEditPantryItemResponse**](OkEditPantryItemResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

