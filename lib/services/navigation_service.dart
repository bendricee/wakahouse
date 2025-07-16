import 'package:flutter/material.dart';

/// Centralized navigation service for consistent navigation patterns
/// across the WakaHouse app
class NavigationService {
  /// Standard slide transition from bottom (for search screen)
  static Route<T> slideFromBottom<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Standard slide transition from right (for profile screen)
  static Route<T> slideFromRight<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Standard fade transition (for general navigation)
  static Route<T> fadeTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// Standard scale transition (for modal-like screens)
  static Route<T> scaleTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: 0.8, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Navigate to search screen with bottom slide animation
  static Future<T?> navigateToSearch<T extends Object?>(
    BuildContext context,
    Widget searchScreen,
  ) {
    return Navigator.push<T>(
      context,
      slideFromBottom<T>(searchScreen),
    );
  }

  /// Navigate to profile screen with right slide animation
  static Future<T?> navigateToProfile<T extends Object?>(
    BuildContext context,
    Widget profileScreen,
  ) {
    return Navigator.push<T>(
      context,
      slideFromRight<T>(profileScreen),
    );
  }

  /// Navigate to detail screen with fade animation
  static Future<T?> navigateToDetail<T extends Object?>(
    BuildContext context,
    Widget detailScreen,
  ) {
    return Navigator.push<T>(
      context,
      fadeTransition<T>(detailScreen),
    );
  }

  /// Navigate to modal screen with scale animation
  static Future<T?> navigateToModal<T extends Object?>(
    BuildContext context,
    Widget modalScreen,
  ) {
    return Navigator.push<T>(
      context,
      scaleTransition<T>(modalScreen),
    );
  }

  /// Standard back navigation with proper state reset
  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Replace current screen (for auth flow)
  static Future<T?> replaceWith<T extends Object?>(
    BuildContext context,
    Widget newScreen,
  ) {
    return Navigator.pushReplacement<T, Object?>(
      context,
      fadeTransition<T>(newScreen),
    );
  }

  /// Clear navigation stack and go to new screen (for auth completion)
  static Future<T?> clearAndNavigateTo<T extends Object?>(
    BuildContext context,
    Widget newScreen,
  ) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      fadeTransition<T>(newScreen),
      (route) => false,
    );
  }
}

/// Mixin for consistent bottom navigation behavior
mixin BottomNavigationMixin<T extends StatefulWidget> on State<T> {
  int selectedBottomNavIndex = 0;

  /// Standard bottom navigation handler
  void handleBottomNavTap(int index, {
    required VoidCallback? onHome,
    required VoidCallback? onSearch,
    required VoidCallback? onFavorites,
    required VoidCallback? onProfile,
  }) {
    if (selectedBottomNavIndex != index) {
      setState(() {
        selectedBottomNavIndex = index;
      });

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

  /// Standard bottom navigation item builder
  Widget buildNavItem(IconData icon, int index, {
    Color? activeColor,
    Color? inactiveColor,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedBottomNavIndex == index;
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

  /// Standard bottom navigation bar builder
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
