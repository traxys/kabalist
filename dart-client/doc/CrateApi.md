# kabalist_client.api.CrateApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**historySearch**](CrateApi.md#historysearch) | **GET** /history/{list} | 
[**searchAccount**](CrateApi.md#searchaccount) | **GET** /search/account/{name} | 
[**searchList**](CrateApi.md#searchlist) | **GET** /search/list/{name} | 


# **historySearch**
> OkGetHistoryResponse historySearch(list, search)





### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CrateApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final search = search_example; // String | Substring Search

try {
    final result = api_instance.historySearch(list, search);
    print(result);
} catch (e) {
    print('Exception when calling CrateApi->historySearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **list** | **String**| List ID | 
 **search** | **String**| Substring Search | [optional] 

### Return type

[**OkGetHistoryResponse**](OkGetHistoryResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAccount**
> OkSearchAccountResponse searchAccount(name)





### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CrateApi();
final name = name_example; // String | Account name

try {
    final result = api_instance.searchAccount(name);
    print(result);
} catch (e) {
    print('Exception when calling CrateApi->searchAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Account name | 

### Return type

[**OkSearchAccountResponse**](OkSearchAccountResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchList**
> OkGetListsResponse searchList(name)





### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CrateApi();
final name = name_example; // String | Part of the list name

try {
    final result = api_instance.searchList(name);
    print(result);
} catch (e) {
    print('Exception when calling CrateApi->searchList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Part of the list name | 

### Return type

[**OkGetListsResponse**](OkGetListsResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

