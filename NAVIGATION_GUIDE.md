# WakaHouse Navigation System Guide

## 🎯 Overview

The WakaHouse app features a comprehensive, user-friendly navigation system that provides smooth transitions, consistent behavior, and intuitive user flows throughout the real estate application.

## 🏗️ Architecture

### Navigation Service (`lib/services/navigation_service.dart`)

Centralized navigation service that provides:
- **Consistent Transitions**: Standardized animations for different navigation types
- **Type Safety**: Generic methods with proper type handling
- **Reusability**: Common navigation patterns used across the app

#### Available Transition Types:

1. **Slide from Bottom** - Used for search screen
2. **Slide from Right** - Used for profile screen  
3. **Fade Transition** - Used for detail screens
4. **Scale Transition** - Used for modal screens

### Bottom Navigation Mixin

Provides consistent bottom navigation behavior across main screens:
- Standardized animation timing (200ms)
- Consistent active/inactive states
- Proper state management

## 📱 Screen Navigation Patterns

### Main App Screens (With Bottom Navigation)

#### Home Screen (`home_screen.dart`)
- **Navigation To**: Search, Profile, Notification, Listing Details
- **Bottom Nav Index**: 0 (Home)
- **Special Features**: 
  - Notification icon in header
  - Property card navigation to details
  - Smooth transitions to all connected screens

#### Search Screen (`search_screen.dart`)
- **Navigation To**: Home (back), Profile
- **Bottom Nav Index**: 1 (Search)
- **Special Features**:
  - Google Maps integration
  - Real map background
  - Location-based search UI

#### Profile Screen (`profile_screen.dart`)
- **Navigation To**: Home (back), Search, Transaction Details
- **Bottom Nav Index**: 3 (Profile)
- **Special Features**:
  - Transaction history navigation
  - Property listings management

### Secondary Screens (No Bottom Navigation)

#### Notification Screen (`notification_screen.dart`)
- **Navigation**: Back to previous screen, Message screen
- **Features**: Swipe-to-delete, tab switching

#### Message Screen (`message_screen.dart`)
- **Navigation**: Back to previous screen, Audio Call
- **Features**: Real-time messaging UI, call integration

#### Listing Details Screen (`listing_details_screen.dart`)
- **Navigation**: Back to previous screen
- **Features**: Image gallery, property information, map integration

#### Audio Call Screen (`audio_call_screen.dart`)
- **Navigation**: Back to previous screen (end call)
- **Features**: Call controls, mute/speaker toggles

#### Transaction Details Screen (`transaction_details_screen.dart`)
- **Navigation**: Back to previous screen
- **Features**: Transaction information, review functionality

### Auth Flow Screens

#### Splash Screen → Onboarding Flow → Auth Intro → Sign In/Up → Home
- **Transition Type**: Fade transitions for smooth auth flow
- **Final Navigation**: Clear navigation stack and go to home

## 🎨 Design Consistency

### Bottom Navigation
- **Height**: 80px consistent across all screens
- **Animation**: 200ms easeInOut curve
- **Active Color**: #7CB342 (Green theme)
- **Inactive Color**: #9CA3AF (Gray)
- **Background**: White with subtle shadow

### Transitions
- **Search Screen**: Bottom slide (300ms)
- **Profile Screen**: Right slide (300ms)
- **Detail Screens**: Fade (250ms)
- **Modal Screens**: Scale + Fade (300ms)

### Icons
- **Home**: `Icons.home` (filled when active)
- **Search**: `Icons.search`
- **Favorites**: `Icons.favorite_border`
- **Profile**: `Icons.person_outline` / `Icons.person` (filled when active)

## 🔧 Usage Examples

### Using Navigation Service

```dart
// Navigate to search screen
NavigationService.navigateToSearch(context, const SearchScreen());

// Navigate to profile screen
NavigationService.navigateToProfile(context, const ProfileScreen());

// Navigate to detail screen
NavigationService.navigateToDetail(context, detailScreen);

// Clear stack and navigate (for auth completion)
NavigationService.clearAndNavigateTo(context, const HomeScreen());
```

### Bottom Navigation Implementation

```dart
// Using the mixin
class MyScreen extends StatefulWidget with BottomNavigationMixin {
  // Implementation with standardized bottom nav
}
```

## 🧪 Testing

### Navigation Test Utility (`lib/utils/navigation_test.dart`)

Comprehensive testing utility that verifies:
- All navigation flows work correctly
- Consistent behavior across screens
- Proper state management
- No broken navigation links

### Running Tests

```dart
// Test all navigation flows
context.testCurrentScreenNavigation();

// Generate navigation report
context.generateNavigationReport();
```

## 📊 Navigation Flow Diagram

```
Splash Screen
    ↓
Onboarding Flow
    ↓
Auth Intro Screen
    ↓
Sign In/Up Screen
    ↓
Home Screen ←→ Search Screen
    ↓              ↓
Profile Screen ←→ [Connected]
    ↓
Transaction Details

Secondary Flows:
Home → Notification → Message → Audio Call
Home → Listing Details
```

## ✅ Best Practices

1. **Always use NavigationService** for consistent transitions
2. **Maintain bottom nav state** when navigating between main screens
3. **Use appropriate transition types** for different screen categories
4. **Test navigation flows** regularly using the test utility
5. **Follow the established icon patterns** for consistency

## 🎯 Benefits

- **Consistent User Experience**: Standardized animations and behaviors
- **Maintainable Code**: Centralized navigation logic
- **Type Safety**: Generic methods prevent navigation errors
- **Performance**: Optimized transitions and state management
- **Scalability**: Easy to add new screens with consistent patterns

## 🔄 Future Enhancements

- Deep linking support
- Navigation analytics
- Gesture-based navigation
- Advanced transition customization
- Navigation state persistence

---

*This navigation system ensures WakaHouse provides a smooth, intuitive, and professional user experience that matches modern real estate app expectations.*
