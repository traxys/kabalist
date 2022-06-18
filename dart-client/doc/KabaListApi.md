# kabalist_client.api.KabaListApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addList**](KabaListApi.md#addlist) | **POST** /list/{id} | 
[**createList**](KabaListApi.md#createlist) | **POST** /list | 
[**deleteItem**](KabaListApi.md#deleteitem) | **DELETE** /list/{list}/{item} | 
[**deleteList**](KabaListApi.md#deletelist) | **DELETE** /list/{id} | 
[**deleteShares**](KabaListApi.md#deleteshares) | **DELETE** /share/{id} | 
[**getAccountName**](KabaListApi.md#getaccountname) | **GET** /account/{id}/name | 
[**getPublicList**](KabaListApi.md#getpubliclist) | **GET** /public/{id} | 
[**getShares**](KabaListApi.md#getshares) | **GET** /share/{id} | 
[**historySearch**](KabaListApi.md#historysearch) | **GET** /history/{list} | 
[**listLists**](KabaListApi.md#listlists) | **GET** /list | 
[**login**](KabaListApi.md#login) | **POST** /login | 
[**readList**](KabaListApi.md#readlist) | **GET** /list/{id} | 
[**recoverPassword**](KabaListApi.md#recoverpassword) | **POST** /recover/{id} | 
[**recoveryInfo**](KabaListApi.md#recoveryinfo) | **GET** /recover/{id} | 
[**register**](KabaListApi.md#register) | **POST** /register/{id} | 
[**removePublic**](KabaListApi.md#removepublic) | **DELETE** /public/{id} | 
[**searchAccount**](KabaListApi.md#searchaccount) | **GET** /search/account/{name} | 
[**searchList**](KabaListApi.md#searchlist) | **GET** /search/list/{name} | 
[**setPublic**](KabaListApi.md#setpublic) | **PUT** /public/{id} | 
[**shareList**](KabaListApi.md#sharelist) | **PUT** /share/{id} | 
[**unshare**](KabaListApi.md#unshare) | **DELETE** /share/{list}/{account} | 
[**updateItem**](KabaListApi.md#updateitem) | **PATCH** /list/{list}/{item} | 


# **addList**
> RspDataForAddToListResponse addList(id, addToListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final addToListRequest = AddToListRequest(); // AddToListRequest | 

try {
    final result = api_instance.addList(id, addToListRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->addList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **addToListRequest** | [**AddToListRequest**](AddToListRequest.md)|  | 

### Return type

[**RspDataForAddToListResponse**](RspDataForAddToListResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createList**
> RspDataForCreateListResponse createList(createListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final createListRequest = CreateListRequest(); // CreateListRequest | 

try {
    final result = api_instance.createList(createListRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->createList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createListRequest** | [**CreateListRequest**](CreateListRequest.md)|  | 

### Return type

[**RspDataForCreateListResponse**](RspDataForCreateListResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteItem**
> RspDataForEmpty deleteItem(list, item)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final item = 56; // int | 

try {
    final result = api_instance.deleteItem(list, item);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->deleteItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **list** | **String**|  | 
 **item** | **int**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteList**
> RspDataForEmpty deleteList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteList(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->deleteList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteShares**
> RspDataForEmpty deleteShares(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.deleteShares(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->deleteShares: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccountName**
> RspDataForGetAccountNameResponse getAccountName(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getAccountName(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->getAccountName: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForGetAccountNameResponse**](RspDataForGetAccountNameResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPublicList**
> String getPublicList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getPublicList(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->getPublicList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getShares**
> RspDataForGetSharesResponse getShares(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getShares(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->getShares: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForGetSharesResponse**](RspDataForGetSharesResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **historySearch**
> RspDataForGetHistoryResponse historySearch(list, search)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final search = search_example; // String | 

try {
    final result = api_instance.historySearch(list, search);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->historySearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **list** | **String**|  | 
 **search** | **String**|  | 

### Return type

[**RspDataForGetHistoryResponse**](RspDataForGetHistoryResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listLists**
> RspDataForGetListsResponse listLists()



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();

try {
    final result = api_instance.listLists();
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->listLists: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RspDataForGetListsResponse**](RspDataForGetListsResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> RspDataForLoginResponse login(loginRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = KabaListApi();
final loginRequest = LoginRequest(); // LoginRequest | 

try {
    final result = api_instance.login(loginRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**RspDataForLoginResponse**](RspDataForLoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readList**
> RspDataForReadListResponse readList(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.readList(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->readList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForReadListResponse**](RspDataForReadListResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoverPassword**
> RspDataForEmpty recoverPassword(id, recoverPasswordRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final recoverPasswordRequest = RecoverPasswordRequest(); // RecoverPasswordRequest | 

try {
    final result = api_instance.recoverPassword(id, recoverPasswordRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->recoverPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **recoverPasswordRequest** | [**RecoverPasswordRequest**](RecoverPasswordRequest.md)|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoveryInfo**
> RspDataForRecoveryInfoResponse recoveryInfo(id)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.recoveryInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->recoveryInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForRecoveryInfoResponse**](RspDataForRecoveryInfoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **register**
> RspDataForEmpty register(id, registerRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final registerRequest = RegisterRequest(); // RegisterRequest | 

try {
    final result = api_instance.register(id, registerRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->register: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removePublic**
> RspDataForEmpty removePublic(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.removePublic(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->removePublic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAccount**
> RspDataForSearchAccountResponse searchAccount(name)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final name = name_example; // String | 

try {
    final result = api_instance.searchAccount(name);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->searchAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 

### Return type

[**RspDataForSearchAccountResponse**](RspDataForSearchAccountResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchList**
> RspDataForGetListsResponse searchList(name)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final name = name_example; // String | 

try {
    final result = api_instance.searchList(name);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->searchList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**|  | 

### Return type

[**RspDataForGetListsResponse**](RspDataForGetListsResponse.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setPublic**
> RspDataForEmpty setPublic(id)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.setPublic(id);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->setPublic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareList**
> RspDataForEmpty shareList(id, shareListRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final shareListRequest = ShareListRequest(); // ShareListRequest | 

try {
    final result = api_instance.shareList(id, shareListRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->shareList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **shareListRequest** | [**ShareListRequest**](ShareListRequest.md)|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unshare**
> RspDataForEmpty unshare(list, account)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final account = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.unshare(list, account);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->unshare: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **list** | **String**|  | 
 **account** | **String**|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateItem**
> RspDataForEmpty updateItem(list, item, updateItemRequest)



### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: JWT
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('JWT').setAccessToken(yourTokenGeneratorFunction);

final api_instance = KabaListApi();
final list = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final item = 56; // int | 
final updateItemRequest = UpdateItemRequest(); // UpdateItemRequest | 

try {
    final result = api_instance.updateItem(list, item, updateItemRequest);
    print(result);
} catch (e) {
    print('Exception when calling KabaListApi->updateItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **list** | **String**|  | 
 **item** | **int**|  | 
 **updateItemRequest** | [**UpdateItemRequest**](UpdateItemRequest.md)|  | 

### Return type

[**RspDataForEmpty**](RspDataForEmpty.md)

### Authorization

[JWT](../README.md#JWT)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

