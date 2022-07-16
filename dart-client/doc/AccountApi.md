# kabalist_client.api.AccountApi

## Load the API package
```dart
import 'package:kabalist_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAccountName**](AccountApi.md#getaccountname) | **GET** /account/{id}/name | 
[**login**](AccountApi.md#login) | **POST** /account/login | Generate a JWT in order to use the other routes
[**recoverPassword**](AccountApi.md#recoverpassword) | **POST** /account/recover/{id} | 
[**recoveryInfo**](AccountApi.md#recoveryinfo) | **GET** /account/recover/{id} | 
[**register**](AccountApi.md#register) | **POST** /account/register/{id} | 


# **getAccountName**
> OkGetAccountNameResponse getAccountName(id)





### Example
```dart
import 'package:kabalist_client/api.dart';
// TODO Configure HTTP Bearer authorization: token
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('token').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AccountApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Account ID

try {
    final result = api_instance.getAccountName(id);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->getAccountName: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Account ID | 

### Return type

[**OkGetAccountNameResponse**](OkGetAccountNameResponse.md)

### Authorization

[token](../README.md#token)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> OkLoginResponse login(loginRequest)

Generate a JWT in order to use the other routes

Generate a JWT in order to use the other routes 

### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = AccountApi();
final loginRequest = LoginRequest(); // LoginRequest | 

try {
    final result = api_instance.login(loginRequest);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**OkLoginResponse**](OkLoginResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoverPassword**
> OkRecoverPasswordResponse recoverPassword(id, recoverPasswordRequest)





### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = AccountApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Recovery ID
final recoverPasswordRequest = RecoverPasswordRequest(); // RecoverPasswordRequest | 

try {
    final result = api_instance.recoverPassword(id, recoverPasswordRequest);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->recoverPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Recovery ID | 
 **recoverPasswordRequest** | [**RecoverPasswordRequest**](RecoverPasswordRequest.md)|  | 

### Return type

[**OkRecoverPasswordResponse**](OkRecoverPasswordResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recoveryInfo**
> OkRecoveryInfoResponse recoveryInfo(id)





### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = AccountApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Recovery ID

try {
    final result = api_instance.recoveryInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->recoveryInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Recovery ID | 

### Return type

[**OkRecoveryInfoResponse**](OkRecoveryInfoResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **register**
> OkRegisterResponse register(id, registerRequest)





### Example
```dart
import 'package:kabalist_client/api.dart';

final api_instance = AccountApi();
final id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Registration ID
final registerRequest = RegisterRequest(); // RegisterRequest | 

try {
    final result = api_instance.register(id, registerRequest);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->register: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Registration ID | 
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**OkRegisterResponse**](OkRegisterResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

