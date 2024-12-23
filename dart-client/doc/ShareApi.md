# kabalist_client.api.ShareApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteShares**](ShareApi.md#deleteshares) | **DELETE** /api/share/{id} | 
[**getShares**](ShareApi.md#getshares) | **GET** /api/share/{id} | 
[**shareList**](ShareApi.md#sharelist) | **PUT** /api/share/{id} | 
[**unshare**](ShareApi.md#unshare) | **DELETE** /api/share/{id}/{account} | 


# **deleteShares**
> OkDeleteShareResponse deleteShares(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ShareApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.deleteShares(id);
    print(result);
} catch (e) {
    print('Exception when calling ShareApi->deleteShares: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkDeleteShareResponse**](OkDeleteShareResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getShares**
> OkGetSharesResponse getShares(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ShareApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID

try {
    final result = api_instance.getShares(id);
    print(result);
} catch (e) {
    print('Exception when calling ShareApi->getShares: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 

### Return type

[**OkGetSharesResponse**](OkGetSharesResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareList**
> OkShareListResponse shareList(id, shareListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ShareApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final shareListRequest = ShareListRequest(); // ShareListRequest | 

try {
    final result = api_instance.shareList(id, shareListRequest);
    print(result);
} catch (e) {
    print('Exception when calling ShareApi->shareList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **shareListRequest** | [**ShareListRequest**](ShareListRequest.md)|  | 

### Return type

[**OkShareListResponse**](OkShareListResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unshare**
> OkUnshareResponse unshare(id, account)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ShareApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final account = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Account ID

try {
    final result = api_instance.unshare(id, account);
    print(result);
} catch (e) {
    print('Exception when calling ShareApi->unshare: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| List ID | 
 **account** | **String**| Account ID | 

### Return type

[**OkUnshareResponse**](OkUnshareResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

