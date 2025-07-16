import 'package:flutter/material.dart';
import 'navigation_test_screen.dart';

/// Helper class to easily add navigation testing to any screen
class NavigationDebugHelper {
  /// Add a floating debug button to any screen for quick navigation testing
  static Widget addDebugButton(BuildContext context, {
    Alignment alignment = Alignment.topRight,
    EdgeInsets margin = const EdgeInsets.all(16),
  }) {
    return Positioned(
      top: alignment == Alignment.topRight || alignment == Alignment.topLeft ? margin.top : null,
      bottom: alignment == Alignment.bottomRight || alignment == Alignment.bottomLeft ? margin.bottom : null,
      left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? margin.left : null,
      right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? margin.right : null,
      child: FloatingActionButton.small(
        heroTag: "navigation_debug_${DateTime.now().millisecondsSinceEpoch}",
        onPressed: () => _openNavigationTest(context),
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.bug_report,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  /// Add debug button to app bar actions
  static Widget appBarDebugAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bug_report_outlined),
      onPressed: () => _openNavigationTest(context),
      tooltip: 'Test Navigation Touch',
    );
  }

  /// Open the navigation test screen
  static void _openNavigationTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NavigationTestScreen(),
      ),
    );
  }

  /// Quick test method to verify touch responsiveness
  static void quickTouchTest(BuildContext context, Function(int) onTap) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Touch Test'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tap each button to test touch responsiveness:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTestButton(context, 0, 'Home', onTap),
                _buildTestButton(context, 1, 'Search', onTap),
                _buildTestButton(context, 2, 'Favorites', onTap),
                _buildTestButton(context, 3, 'Profile', onTap),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openNavigationTest(context);
            },
            child: const Text('Full Test'),
          ),
        ],
      ),
    );
  }

  static Widget _buildTestButton(
    BuildContext context,
    int index,
    String label,
    Function(int) onTap,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            onTap(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped: $label'),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          icon: Icon(_getIconForIndex(index)),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF7CB342),
            foregroundColor: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  static IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.search;
      case 2:
        return Icons.favorite;
      case 3:
        return Icons.person;
      default:
        return Icons.help;
    }
  }
}

/// Extension to easily add debug capabilities to any widget
extension NavigationDebugExtension on Widget {
  /// Wrap any widget with a debug overlay
  Widget withNavigationDebug(BuildContext context, {
    bool showDebugButton = true,
    Alignment debugButtonAlignment = Alignment.topRight,
  }) {
    if (!showDebugButton) return this;
    
    return Stack(
      children: [
        this,
        NavigationDebugHelper.addDebugButton(
          context,
          alignment: debugButtonAlignment,
        ),
      ],
    );
  }
}

/// Mixin for screens that want easy debug access
mixin NavigationDebugMixin<T extends StatefulWidget> on State<T> {
  bool _debugMode = false;

  /// Toggle debug mode
  void toggleDebugMode() {
    setState(() {
      _debugMode = !_debugMode;
    });
  }

  /// Get current debug mode state
  bool get isDebugMode => _debugMode;

  /// Add debug action to app bar
  Widget get debugAppBarAction => NavigationDebugHelper.appBarDebugAction(context);

  /// Show quick test dialog
  void showQuickTest(Function(int) onTap) {
    NavigationDebugHelper.quickTouchTest(context, onTap);
  }

  /// Open full navigation test
  void openNavigationTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NavigationTestScreen(),
      ),
    );
  }
}
