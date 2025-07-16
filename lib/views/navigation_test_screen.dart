import 'package:flutter/material.dart';
import '../widgets/wakahouse_bottom_navigation.dart';
import '../services/navigation_state.dart';

/// Test screen to verify bottom navigation touch responsiveness
/// This screen helps identify and fix touch target issues
class NavigationTestScreen extends StatefulWidget {
  const NavigationTestScreen({super.key});

  @override
  State<NavigationTestScreen> createState() => _NavigationTestScreenState();
}

class _NavigationTestScreenState extends State<NavigationTestScreen> {
  int _tapCount = 0;
  int _lastTappedIndex = -1;
  String _lastTappedLabel = '';
  bool _debugMode = false;
  final List<int> _tapHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Navigation Touch Test'),
        backgroundColor: const Color(0xFF7CB342),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_debugMode ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () {
              setState(() {
                _debugMode = !_debugMode;
              });
            },
            tooltip: 'Toggle Debug Mode',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test Results Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Touch Test Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTestResult('Total Taps', _tapCount.toString()),
                      _buildTestResult('Last Tapped', _lastTappedLabel.isEmpty 
                          ? 'None' 
                          : '$_lastTappedLabel (Index $_lastTappedIndex)'),
                      _buildTestResult('Debug Mode', _debugMode ? 'ON' : 'OFF'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Instructions Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInstruction('1. Tap each navigation icon multiple times'),
                      _buildInstruction('2. Try tapping near the edges of each icon'),
                      _buildInstruction('3. Verify the correct tab is always selected'),
                      _buildInstruction('4. Enable debug mode to see touch boundaries'),
                      _buildInstruction('5. Check that no wrong tabs are triggered'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tap History
              if (_tapHistory.isNotEmpty) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Tap History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _tapHistory.reversed.take(10).map((index) {
                            final labels = ['Home', 'Search', 'Favorites', 'Profile'];
                            return Chip(
                              label: Text(labels[index]),
                              backgroundColor: const Color(0xFF7CB342).withValues(alpha: 0.1),
                              labelStyle: const TextStyle(
                                color: Color(0xFF7CB342),
                                fontSize: 12,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Clear History Button
              if (_tapHistory.isNotEmpty)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _tapHistory.clear();
                        _tapCount = 0;
                        _lastTappedIndex = -1;
                        _lastTappedLabel = '';
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB342),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

              const Spacer(),

              // Status Indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _debugMode 
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _debugMode ? Colors.orange : Colors.green,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _debugMode ? Icons.bug_report : Icons.check_circle,
                      color: _debugMode ? Colors.orange : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _debugMode 
                          ? 'Debug mode active - Touch boundaries visible'
                          : 'Normal mode - Test touch responsiveness',
                      style: TextStyle(
                        color: _debugMode ? Colors.orange[700] : Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: WakaHouseBottomNavigation(
        debugMode: _debugMode,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildTestResult(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        instruction,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF7F8C8D),
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    final labels = ['Home', 'Search', 'Favorites', 'Profile'];
    
    setState(() {
      _tapCount++;
      _lastTappedIndex = index;
      _lastTappedLabel = labels[index];
      _tapHistory.add(index);
      
      // Keep only last 20 taps
      if (_tapHistory.length > 20) {
        _tapHistory.removeAt(0);
      }
    });

    // Update global navigation state
    SimpleNavigationService.state.setSelectedIndex(index);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: ${labels[index]} (Index: $index)'),
        duration: const Duration(milliseconds: 1000),
        backgroundColor: const Color(0xFF7CB342),
      ),
    );
  }
}
