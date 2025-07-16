import 'package:flutter/material.dart';

/// Global navigation state manager to ensure consistent bottom navigation
/// across all screens in the WakaHouse app
class NavigationState extends ChangeNotifier {
  static final NavigationState _instance = NavigationState._internal();
  factory NavigationState() => _instance;
  NavigationState._internal();

  int _selectedBottomNavIndex = 0;

  /// Current selected bottom navigation index
  int get selectedBottomNavIndex => _selectedBottomNavIndex;

  /// Update the selected bottom navigation index
  void setSelectedIndex(int index) {
    if (_selectedBottomNavIndex != index) {
      _selectedBottomNavIndex = index;
      notifyListeners();
    }
  }

  /// Reset to home tab (index 0)
  void resetToHome() {
    setSelectedIndex(0);
  }

  /// Set to search tab (index 1)
  void setToSearch() {
    setSelectedIndex(1);
  }

  /// Set to favorites tab (index 2)
  void setToFavorites() {
    setSelectedIndex(2);
  }

  /// Set to profile tab (index 3)
  void setToProfile() {
    setSelectedIndex(3);
  }

  /// Check if current index is home
  bool get isHome => _selectedBottomNavIndex == 0;

  /// Check if current index is search
  bool get isSearch => _selectedBottomNavIndex == 1;

  /// Check if current index is favorites
  bool get isFavorites => _selectedBottomNavIndex == 2;

  /// Check if current index is profile
  bool get isProfile => _selectedBottomNavIndex == 3;
}

/// Mixin for screens that need bottom navigation state management
mixin NavigationStateMixin<T extends StatefulWidget> on State<T> {
  late NavigationState _navigationState;

  @override
  void initState() {
    super.initState();
    _navigationState = NavigationState();
    _navigationState.addListener(_onNavigationStateChanged);
  }

  @override
  void dispose() {
    _navigationState.removeListener(_onNavigationStateChanged);
    super.dispose();
  }

  /// Called when navigation state changes
  void _onNavigationStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Get current navigation state
  NavigationState get navigationState => _navigationState;

  /// Get current selected index
  int get selectedBottomNavIndex => _navigationState.selectedBottomNavIndex;

  /// Check if given index is selected
  bool isNavIndexSelected(int index) => selectedBottomNavIndex == index;

  /// Handle bottom navigation tap with proper state management
  void handleBottomNavTap(
    int index, {
    VoidCallback? onHome,
    VoidCallback? onSearch,
    VoidCallback? onFavorites,
    VoidCallback? onProfile,
  }) {
    if (selectedBottomNavIndex != index) {
      _navigationState.setSelectedIndex(index);

      switch (index) {
        case 0:
          onHome?.call();
          break;
        case 1:
          onSearch?.call();
          break;
        case 2:
          onFavorites?.call();
          break;
        case 3:
          onProfile?.call();
          break;
      }
    }
  }

  /// Standard bottom navigation item builder with global state
  Widget buildNavItem(
    IconData icon,
    int index, {
    Color? activeColor,
    Color? inactiveColor,
    required VoidCallback onTap,
  }) {
    bool isSelected = isNavIndexSelected(index);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (activeColor ?? const Color(0xFF7CB342))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (inactiveColor ?? const Color(0xFF9CA3AF)),
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Standard bottom navigation bar builder with global state
  Widget buildBottomNavigationBar({
    required List<IconData> icons,
    required Function(int) onTap,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons.asMap().entries.map((entry) {
          int index = entry.key;
          IconData icon = entry.value;
          return buildNavItem(
            icon,
            index,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onTap: () => onTap(index),
          );
        }).toList(),
      ),
    );
  }
}

/// Simple navigation service with global state management
class SimpleNavigationService {
  static final NavigationState _navigationState = NavigationState();

  /// Get the global navigation state
  static NavigationState get state => _navigationState;

  /// Navigate to search screen with modern directional transition
  static Future<T?> navigateToSearch<T extends Object?>(
    BuildContext context,
    Widget searchScreen,
  ) {
    final int currentIndex = _navigationState.selectedBottomNavIndex;
    final int targetIndex = 1; // Search index
    _navigationState.setToSearch();

    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => searchScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Determine slide direction based on tab order
          final bool slideLeft = targetIndex > currentIndex;
          final begin = slideLeft
              ? const Offset(1.0, 0.0)
              : const Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve =
              Curves.easeInOutCubicEmphasized; // Material Design 3 curve

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 250,
        ), // Consistent timing
      ),
    );
  }

  /// Navigate to profile screen with modern directional transition
  static Future<T?> navigateToProfile<T extends Object?>(
    BuildContext context,
    Widget profileScreen,
  ) {
    final int currentIndex = _navigationState.selectedBottomNavIndex;
    final int targetIndex = 3; // Profile index
    _navigationState.setToProfile();

    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => profileScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Determine slide direction based on tab order
          final bool slideLeft = targetIndex > currentIndex;
          final begin = slideLeft
              ? const Offset(1.0, 0.0)
              : const Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve =
              Curves.easeInOutCubicEmphasized; // Material Design 3 curve

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 250,
        ), // Consistent timing
      ),
    );
  }

  /// Navigate to favorites screen with modern directional transition
  static Future<T?> navigateToFavorites<T extends Object?>(
    BuildContext context,
    Widget favoritesScreen,
  ) {
    final int currentIndex = _navigationState.selectedBottomNavIndex;
    final int targetIndex = 2; // Favorites index
    _navigationState.setToFavorites();

    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            favoritesScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Determine slide direction based on tab order
          final bool slideLeft = targetIndex > currentIndex;
          final begin = slideLeft
              ? const Offset(1.0, 0.0)
              : const Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve =
              Curves.easeInOutCubicEmphasized; // Material Design 3 curve

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 250,
        ), // Consistent timing
      ),
    );
  }

  /// Navigate back and reset to appropriate state
  static void navigateBack(BuildContext context, {int? resetToIndex}) {
    Navigator.pop(context);
    if (resetToIndex != null) {
      _navigationState.setSelectedIndex(resetToIndex);
    }
  }

  /// Navigate to home and update state
  static void navigateToHome(BuildContext context) {
    _navigationState.resetToHome();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Build standard navigation item
  static Widget buildNavItem(
    IconData icon,
    int index,
    VoidCallback onTap, {
    Color? activeColor,
    Color? inactiveColor,
  }) {
    bool isSelected = _navigationState.selectedBottomNavIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (activeColor ?? const Color(0xFF7CB342))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (inactiveColor ?? const Color(0xFF9CA3AF)),
            size: 24,
          ),
        ),
      ),
    );
  }

  /// Handle bottom navigation tap
  static void handleBottomNavTap(
    int index, {
    VoidCallback? onHome,
    VoidCallback? onSearch,
    VoidCallback? onFavorites,
    VoidCallback? onProfile,
  }) {
    if (_navigationState.selectedBottomNavIndex != index) {
      _navigationState.setSelectedIndex(index);

      switch (index) {
        case 0:
          onHome?.call();
          break;
        case 1:
          onSearch?.call();
          break;
        case 2:
          onFavorites?.call();
          break;
        case 3:
          onProfile?.call();
          break;
      }
    }
  }
}
