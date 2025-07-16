import 'package:flutter/material.dart';
import '../services/navigation_state.dart';
import '../services/bottom_navigation_service.dart';

/// Professional, reusable bottom navigation widget for WakaHouse real estate app
///
/// Features:
/// - Consistent design with WakaHouse color scheme
/// - Smooth animations with 200ms timing
/// - Integration with global navigation state
/// - Professional styling with shadows and rounded corners
/// - Responsive touch feedback
class WakaHouseBottomNavigation extends StatefulWidget {
  /// Callback function when a navigation item is tapped
  final Function(int index) onTap;

  /// Optional custom active color (defaults to WakaHouse green #7CB342)
  final Color? activeColor;

  /// Optional custom inactive color (defaults to gray #9CA3AF)
  final Color? inactiveColor;

  /// Optional custom background color (defaults to white)
  final Color? backgroundColor;

  /// Optional custom height (defaults to 80)
  final double? height;

  /// Debug mode to show touch boundaries (defaults to false)
  final bool debugMode;

  const WakaHouseBottomNavigation({
    super.key,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.height,
    this.debugMode = false,
  });

  @override
  State<WakaHouseBottomNavigation> createState() =>
      _WakaHouseBottomNavigationState();
}

class _WakaHouseBottomNavigationState extends State<WakaHouseBottomNavigation>
    with TickerProviderStateMixin {
  late NavigationState _navigationState;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  // Navigation items configuration
  static const List<IconData> _navigationIcons = [
    Icons.home, // Home
    Icons.search, // Search
    Icons.favorite_border, // Favorites
    Icons.person_outline, // Profile
  ];

  static const List<String> _navigationLabels = [
    'Home',
    'Search',
    'Favorites',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _navigationState = NavigationState();
    _navigationState.addListener(_onNavigationStateChanged);

    // Initialize animation controllers for each navigation item
    _animationControllers = List.generate(
      _navigationIcons.length,
      (index) => AnimationController(
        duration: const Duration(
          milliseconds: 250,
        ), // Consistent with navigation transitions
        vsync: this,
      ),
    );

    // Initialize scale animations with Material Design 3 curves
    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.05, // Subtle scale for modern feel
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutCubicEmphasized, // Material Design 3 curve
        ),
      );
    }).toList();

    // Initialize fade animations for smooth transitions
    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.6, // Start with some opacity for better UX
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutCubicEmphasized,
        ),
      );
    }).toList();

    // Set initial animation state
    _updateAnimations();
  }

  @override
  void dispose() {
    _navigationState.removeListener(_onNavigationStateChanged);
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onNavigationStateChanged() {
    if (mounted) {
      setState(() {});
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      if (_navigationState.selectedBottomNavIndex == i) {
        _animationControllers[i].forward();
      } else {
        _animationControllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _navigationIcons.length,
            (index) => _buildNavigationItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(int index) {
    final bool isSelected = _navigationState.selectedBottomNavIndex == index;
    final Color activeColor = widget.activeColor ?? const Color(0xFF7CB342);
    final Color inactiveColor = widget.inactiveColor ?? const Color(0xFF9CA3AF);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Debug logging for touch events
            if (widget.debugMode) {
              print(
                'WakaHouse Navigation: Tapped index $index (${_navigationLabels[index]})',
              );
            }

            // Add haptic feedback for better touch response
            // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
            widget.onTap(index);
          },
          child: Container(
            // Ensure minimum touch target size (48x48 as per Material Design)
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            // Debug mode: show touch boundaries
            decoration: widget.debugMode
                ? BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with background and modern animations
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _scaleAnimations[index],
                    _fadeAnimations[index],
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOutCubicEmphasized,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? activeColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          // Add subtle shadow for active state
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: activeColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          _navigationIcons[index],
                          color: isSelected ? Colors.white : inactiveColor,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 2),

                // Label with fade animation
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1.0 : 0.6,
                  child: Text(
                    _navigationLabels[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to provide easy access to WakaHouse bottom navigation
extension WakaHouseBottomNavigationExtension on Widget {
  /// Wraps the widget with WakaHouse bottom navigation
  Widget withWakaHouseBottomNavigation({
    required Function(int index) onTap,
    Color? activeColor,
    Color? inactiveColor,
    Color? backgroundColor,
    double? height,
    bool debugMode = false,
  }) {
    return Column(
      children: [
        Expanded(child: this),
        WakaHouseBottomNavigation(
          onTap: onTap,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          backgroundColor: backgroundColor,
          height: height,
          debugMode: debugMode,
        ),
      ],
    );
  }
}
