import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertyVirtualTourScreen extends StatefulWidget {
  final String propertyName;
  final String propertyLocation;
  final String propertyPrice;
  final double propertyRating;

  const PropertyVirtualTourScreen({
    super.key,
    this.propertyName = 'Modern Villa',
    this.propertyLocation = 'Yaoundé, Centre Region',
    this.propertyPrice = '200,000 FCFA/month',
    this.propertyRating = 4.8,
  });

  @override
  State<PropertyVirtualTourScreen> createState() =>
      _PropertyVirtualTourScreenState();
}

class _PropertyVirtualTourScreenState extends State<PropertyVirtualTourScreen>
    with TickerProviderStateMixin {
  String currentRoom = 'Living Room';
  bool showRoomInfo = true;
  bool showControls = true;
  bool isFullscreen = false;
  double rotationAngle = 0.0;

  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> rooms = [
    {
      'name': 'Living Room',
      'image': 'assets/images/living_room_360.jpg',
      'description': 'Spacious living area with modern furniture',
      'features': ['Smart TV', 'Air Conditioning', 'Large Windows'],
    },
    {
      'name': 'Kitchen',
      'image': 'assets/images/kitchen_360.jpg',
      'description': 'Fully equipped modern kitchen',
      'features': [
        'Island Counter',
        'Built-in Appliances',
        'Granite Countertops',
      ],
    },
    {
      'name': 'Master Bedroom',
      'image': 'assets/images/bedroom_360.jpg',
      'description': 'Luxurious master bedroom with ensuite',
      'features': ['King Size Bed', 'Walk-in Closet', 'Ensuite Bathroom'],
    },
    {
      'name': 'Bathroom',
      'image': 'assets/images/bathroom_360.jpg',
      'description': 'Modern bathroom with premium fixtures',
      'features': ['Rain Shower', 'Double Vanity', 'Heated Floors'],
    },
    {
      'name': 'Balcony',
      'image': 'assets/images/balcony_360.jpg',
      'description': 'Private balcony with city views',
      'features': ['City View', 'Outdoor Seating', 'Garden Access'],
    },
  ];

  Map<String, dynamic> get currentRoomData {
    return rooms.firstWhere(
      (room) => room['name'] == currentRoom,
      orElse: () => rooms[0],
    );
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    // Auto-hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
    if (isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _changeRoom(String roomName) {
    setState(() {
      currentRoom = roomName;
      showRoomInfo = true;
    });
    _fadeController.reset();
    _fadeController.forward();

    // Auto-hide room info after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showRoomInfo = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // 360° Room View
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: rotationAngle,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(currentRoomData['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Interactive Hotspots
            ..._buildInteractiveHotspots(),

            // Top Controls
            if (showControls) _buildTopControls(),

            // Room Information Panel
            if (showRoomInfo) _buildRoomInfoPanel(),

            // Bottom Room Navigation
            if (showControls) _buildBottomRoomNavigation(),

            // 360° Control Indicator
            if (showControls) _build360Controls(),

            // Property Info Overlay
            if (showControls) _buildPropertyInfoOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            const Spacer(),

            // Property Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Text(
                widget.propertyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            // Fullscreen Toggle
            GestureDetector(
              onTap: _toggleFullscreen,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomInfoPanel() {
    return Positioned(
      top: 120,
      left: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: showRoomInfo ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7CB342),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currentRoom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showRoomInfo = false;
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currentRoomData['description'],
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (currentRoomData['features'] as List<String>).map((
                  feature,
                ) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF7CB342)),
                    ),
                    child: Text(
                      feature,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomRoomNavigation() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final isSelected = room['name'] == currentRoom;
            return GestureDetector(
              onTap: () => _changeRoom(room['name']),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7CB342)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF7CB342)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    room['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _build360Controls() {
    return Positioned(
      right: 20,
      top: MediaQuery.of(context).size.height / 2 - 60,
      child: Column(
        children: [
          // Rotation Control
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                rotationAngle += details.delta.dx * 0.01;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.threesixty,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Reset View
          GestureDetector(
            onTap: () {
              setState(() {
                rotationAngle = 0.0;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyInfoOverlay() {
    return Positioned(
      top: 80,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.propertyPrice,
              style: const TextStyle(
                color: Color(0xFF7CB342),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.propertyLocation,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.propertyRating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInteractiveHotspots() {
    return [
      // Kitchen Hotspot
      Positioned(
        top: 200,
        left: 100,
        child: _buildHotspot('Kitchen', () => _changeRoom('Kitchen')),
      ),
      // Bedroom Hotspot
      Positioned(
        top: 300,
        right: 120,
        child: _buildHotspot(
          'Master Bedroom',
          () => _changeRoom('Master Bedroom'),
        ),
      ),
      // Bathroom Hotspot
      Positioned(
        bottom: 200,
        left: 80,
        child: _buildHotspot('Bathroom', () => _changeRoom('Bathroom')),
      ),
      // Balcony Hotspot
      Positioned(
        top: 150,
        right: 60,
        child: _buildHotspot('Balcony', () => _changeRoom('Balcony')),
      ),
    ];
  }

  Widget _buildHotspot(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
