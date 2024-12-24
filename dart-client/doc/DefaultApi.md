# kabalist_client.api.DefaultApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**historySearch**](DefaultApi.md#historysearch) | **GET** /api/history/{list} | 
[**searchAccount**](DefaultApi.md#searchaccount) | **GET** /api/search/account/{name} | 
[**searchList**](DefaultApi.md#searchlist) | **GET** /api/search/list/{name} | 


# **historySearch**
> OkGetHistoryResponse historySearch(list, search)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = DefaultApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | List ID
final search = search_example; // String | Substring Search

try {
    final result = api_instance.historySearch(list, search);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->historySearch: $e\n');
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

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAccount**
> OkSearchAccountResponse searchAccount(name)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = DefaultApi();
final name = name_example; // String | Account name

try {
    final result = api_instance.searchAccount(name);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->searchAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Account name | 

### Return type

[**OkSearchAccountResponse**](OkSearchAccountResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchList**
> OkGetListsResponse searchList(name)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = DefaultApi();
final name = name_example; // String | Part of the list name

try {
    final result = api_instance.searchList(name);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->searchList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| Part of the list name | 

### Return type

[**OkGetListsResponse**](OkGetListsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

