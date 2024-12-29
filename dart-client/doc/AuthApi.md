# kabalist_client.api.AuthApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAccountName**](AuthApi.md#getaccountname) | **GET** /api/account/{id}/name | 


# **getAccountName**
> OkGetAccountNameResponse getAccountName(id)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = AuthApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Account ID

try {
    final result = api_instance.getAccountName(id);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->getAccountName: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Account ID | 

### Return type

[**OkGetAccountNameResponse**](OkGetAccountNameResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

