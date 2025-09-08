# Authentication Flow Implementation

## Overview
This implementation provides a seamless authentication flow that automatically redirects users based on their login status without showing a custom splash screen.

## Key Components

### 1. AuthWrapper (`features/auth/presentation/pages/auth_wrapper.dart`)
- **Purpose**: Acts as the initial route that checks authentication status
- **Functionality**: 
  - Checks if user is logged in using `StorageService().isLoggedIn()`
  - Shows a simple loading indicator instead of custom splash
  - Redirects to main page if logged in, login page if not logged in

### 2. StorageService (`core/local_storage/storage_service.dart`)
- **Purpose**: Manages local storage for authentication data
- **Key Methods**:
  - `isLoggedIn()`: Returns boolean indicating login status
  - `setLoggedIn(bool value)`: Sets login status
  - `saveUserToken(String token)`: Saves user authentication token
  - `getUserToken()`: Retrieves stored token

### 3. AuthCubit (`features/auth/presentation/cubit/auth_cubit.dart`)
- **Purpose**: Manages authentication state and API calls
- **Key Methods**:
  - `verifyOtp()`: Handles OTP verification and sets login status
  - `completeSignUp()`: Handles new user signup and sets login status
  - `logout()`: Clears authentication data
  - `isUserLoggedIn()`: Checks and loads user data from storage

## Flow Diagram

```
App Start
    ↓
AuthWrapper
    ↓
Check Login Status
    ↓
┌─────────────────┬─────────────────┐
│   Logged In     │  Not Logged In  │
│        ↓        │        ↓        │
│   Main Page     │   Login Page    │
└─────────────────┴─────────────────┘
```

## Implementation Details

### Route Configuration
- **Initial Route**: `AppRoutes.splashPage` now points to `AuthWrapper`
- **Login Success**: Redirects to `AppRoutes.mainPage`
- **Signup Success**: Redirects to `AppRoutes.mainPage`

### Storage Keys
- `DBKeys.isLoggedInKey`: Boolean flag for login status
- `DBKeys.userTokenKey`: User authentication token
- `DBKeys.user`: User data object

### Navigation
- **Login Page**: Uses `Navigator.pushNamedAndRemoveUntil()` to clear navigation stack
- **Signup Page**: Uses `BlocListener` for proper state management
- **AuthWrapper**: Uses `Navigator.pushReplacementNamed()` for seamless transitions

## Usage

### For Developers
1. The app automatically handles authentication flow on startup
2. No need to manually check login status in individual pages
3. Use `AuthCubit` methods for authentication operations
4. Use `StorageService` for direct storage access

### For Testing
1. Clear app data to test login flow
2. Use `AuthCubit.logout()` to test logout functionality
3. Check `StorageService.isLoggedIn()` for current status

## Benefits
- ✅ No custom splash screen delay
- ✅ Automatic authentication check
- ✅ Seamless user experience
- ✅ Proper state management
- ✅ Error handling
- ✅ Loading states 