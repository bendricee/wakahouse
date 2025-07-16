import 'package:flutter/material.dart';
import 'navigation_state.dart';

/// Transition types available for bottom navigation
enum TransitionType {
  slideHorizontal, // Slide left/right based on tab order
  fadeThrough, // Material Design 3 fade through
  sharedAxis, // Shared axis transition
  fadeScale, // Fade with subtle scale
}

/// Enhanced bottom navigation service with consistent, beautiful transitions
/// for all tab switches in the WakaHouse app
class BottomNavigationService {
  static final NavigationState _navigationState = NavigationState();

  /// Get the global navigation state
  static NavigationState get state => _navigationState;

  /// Current transition type (can be changed app-wide)
  static TransitionType _currentTransitionType = TransitionType.slideHorizontal;

  /// Set the global transition type for bottom navigation
  static void setTransitionType(TransitionType type) {
    _currentTransitionType = type;
  }

  /// Navigate between bottom navigation tabs with consistent transitions
  static Future<T?> navigateToTab<T extends Object?>(
    BuildContext context,
    Widget screen,
    int targetIndex, {
    TransitionType? overrideTransition,
  }) {
    final int currentIndex = _navigationState.selectedBottomNavIndex;
    final TransitionType transitionType =
        overrideTransition ?? _currentTransitionType;

    // Update navigation state
    _navigationState.setSelectedIndex(targetIndex);

    return Navigator.pushReplacement<T, Object?>(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(
            animation,
            secondaryAnimation,
            child,
            currentIndex,
            targetIndex,
            transitionType,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  /// Build the appropriate transition based on type
  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    int currentIndex,
    int targetIndex,
    TransitionType type,
  ) {
    switch (type) {
      case TransitionType.slideHorizontal:
        return _buildSlideHorizontalTransition(
          animation,
          secondaryAnimation,
          child,
          currentIndex,
          targetIndex,
        );
      case TransitionType.fadeThrough:
        return _buildFadeThroughTransition(
          animation,
          secondaryAnimation,
          child,
        );
      case TransitionType.sharedAxis:
        return _buildSharedAxisTransition(
          animation,
          secondaryAnimation,
          child,
          currentIndex,
          targetIndex,
        );
      case TransitionType.fadeScale:
        return _buildFadeScaleTransition(animation, child);
    }
  }

  /// Horizontal slide transition with directional logic
  static Widget _buildSlideHorizontalTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    int currentIndex,
    int targetIndex,
  ) {
    // Determine slide direction based on tab order
    final bool slideLeft = targetIndex > currentIndex;
    final begin = slideLeft ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
    const end = Offset.zero;

    // Primary animation (incoming screen)
    final slideAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    // Secondary animation (outgoing screen)
    final slideOutAnimation =
        Tween(
          begin: Offset.zero,
          end: slideLeft ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        );

    return Stack(
      children: [
        SlideTransition(
          position: slideOutAnimation,
          child: Container(), // Placeholder for outgoing screen
        ),
        SlideTransition(position: slideAnimation, child: child),
      ],
    );
  }

  /// Material Design 3 fade through transition
  static Widget _buildFadeThroughTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const double fadeInStart = 0.35;
    const double fadeOutEnd = 0.35;

    final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(fadeInStart, 1.0, curve: Curves.easeInOut),
      ),
    );

    final scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    return FadeTransition(
      opacity: fadeIn,
      child: ScaleTransition(scale: scaleIn, child: child),
    );
  }

  /// Shared axis transition (vertical movement)
  static Widget _buildSharedAxisTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    int currentIndex,
    int targetIndex,
  ) {
    final bool slideUp = targetIndex > currentIndex;
    final begin = slideUp ? const Offset(0.0, 0.3) : const Offset(0.0, -0.3);
    const end = Offset.zero;

    final slideAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(opacity: fadeAnimation, child: child),
    );
  }

  /// Fade with subtle scale transition
  static Widget _buildFadeScaleTransition(
    Animation<double> animation,
    Widget child,
  ) {
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

    final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubicEmphasized,
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }

  /// Convenience methods for specific tabs
  static Future<T?> navigateToHome<T extends Object?>(
    BuildContext context,
    Widget homeScreen,
  ) {
    return navigateToTab<T>(context, homeScreen, 0);
  }

  static Future<T?> navigateToSearch<T extends Object?>(
    BuildContext context,
    Widget searchScreen,
  ) {
    return navigateToTab<T>(context, searchScreen, 1);
  }

  static Future<T?> navigateToFavorites<T extends Object?>(
    BuildContext context,
    Widget favoritesScreen,
  ) {
    return navigateToTab<T>(context, favoritesScreen, 2);
  }

  static Future<T?> navigateToProfile<T extends Object?>(
    BuildContext context,
    Widget profileScreen,
  ) {
    return navigateToTab<T>(context, profileScreen, 3);
  }

  /// Handle bottom navigation tap with unified transitions
  static void handleBottomNavTap(
    BuildContext context,
    int index, {
    required Widget Function() getHomeScreen,
    required Widget Function() getSearchScreen,
    required Widget Function() getFavoritesScreen,
    required Widget Function() getProfileScreen,
  }) {
    if (_navigationState.selectedBottomNavIndex != index) {
      switch (index) {
        case 0:
          navigateToHome(context, getHomeScreen());
          break;
        case 1:
          navigateToSearch(context, getSearchScreen());
          break;
        case 2:
          navigateToFavorites(context, getFavoritesScreen());
          break;
        case 3:
          navigateToProfile(context, getProfileScreen());
          break;
      }
    }
  }
}
