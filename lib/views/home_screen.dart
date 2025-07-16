import 'package:flutter/material.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'my_favorite_screen.dart';
import 'featured_estates_screen.dart';
import 'location_map_screen.dart';
import 'top_estate_agent_screen.dart'; // Now represents landlords
import 'search_results_screen.dart';
import '../services/navigation_service.dart';
import '../services/navigation_state.dart';
import '../services/bottom_navigation_service.dart';
import '../widgets/wakahouse_bottom_navigation.dart';
import 'listing_details_screen.dart';

// Custom clipper for diagonal rounded corners
class DiagonalRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left with rounded corner
    path.moveTo(12, 0);
    path.lineTo(size.width - 20, 0);

    // Top-right diagonal cut with curve
    path.quadraticBezierTo(size.width - 5, 0, size.width, 15);
    path.lineTo(size.width, size.height - 12);

    // Bottom-right rounded corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 12,
      size.height,
    );
    path.lineTo(20, size.height);

    // Bottom-left diagonal cut with curve
    path.quadraticBezierTo(5, size.height, 0, size.height - 15);
    path.lineTo(0, 12);

    // Top-left rounded corner
    path.quadraticBezierTo(0, 0, 12, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Ensure home tab is selected when home screen is initialized
    SimpleNavigationService.state.resetToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Location dropdown
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Location selection coming soon!'),
                            backgroundColor: Color(0xFF7CB342),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF7CB342),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Douala, Cameroon',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF7F8C8D),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Notification icon
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF2C3E50),
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Profile avatar
                    GestureDetector(
                      onTap: () => BottomNavigationService.navigateToProfile(
                        context,
                        const ProfileScreen(),
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/splash_image.webp',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hey, Jonathan!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Let's start exploring",
                      style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Room, Studio, Apartment, Villa',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      suffixIcon: const Icon(
                        Icons.tune,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Category Buttons - Scrollable
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryButton('All'),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Room'),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Studio'),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Apartment'),
                    const SizedBox(width: 12),
                    _buildCategoryButton('Villa'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Promotional Banner Cards (different from Featured Estates)
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final bannerProperties = [
                      {
                        'title': 'Halloween\nVacation',
                        'subtitle': 'Special Holiday Deals',
                        'images': [
                          'assets/images/splash_image.webp',
                          'assets/images/splash_image.webp',
                          'assets/images/splash_image.webp',
                        ],
                        'isSpecial': true,
                      },
                      {
                        'title': 'Summer\nVacation',
                        'subtitle': 'Beach Resort Getaway',
                        'images': [
                          'assets/images/splash_image.webp',
                          'assets/images/splash_image.webp',
                          'assets/images/splash_image.webp',
                        ],
                        'isSpecial': false,
                      },
                    ];

                    return _buildScrollableFeaturedPropertyCard(
                      bannerProperties[index]['title']! as String,
                      bannerProperties[index]['subtitle']! as String,
                      bannerProperties[index]['images']! as List<String>,
                      bannerProperties[index]['isSpecial'] as bool,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Featured Estates Section
              _buildSectionHeader('Featured Estates', 'View all'),

              const SizedBox(height: 12),

              // Featured Estates Cards
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFeaturedCard(
                      'Villa Moderne Buea',
                      'Buea, Southwest Region',
                      '135M FCFA',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildFeaturedCard(
                      'Résidence Étoile',
                      'Douala, Littoral Region',
                      '175M FCFA',
                      'assets/images/splash_image.webp',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Top Locations Section
              _buildSectionHeader('Top Locations', 'explore'),

              const SizedBox(height: 12),

              // Top Locations List - Scrollable
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildLocationItem(
                      'Douala',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Yaoundé',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Buea',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Bamenda',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Garoua',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Bafoussam',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLocationItem(
                      'Maroua',
                      'assets/images/splash_image.webp',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Top Landlords Section
              _buildSectionHeader('Top Landlords', 'explore'),

              const SizedBox(height: 12),

              // Landlord List - Extended and Scrollable
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildLandlordItem(
                      'Jean-Baptiste',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Marie-Claire',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Emmanuel',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Françoise',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Paul-Henri',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Aminata',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Ibrahim',
                      'assets/images/splash_image.webp',
                    ),
                    const SizedBox(width: 16),
                    _buildLandlordItem(
                      'Fatima',
                      'assets/images/splash_image.webp',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Explore Nearby Estates Section
              _buildSectionHeader('Explore Nearby Estates', ''),

              const SizedBox(height: 12),

              // Nearby Estates Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildNearbyCard(
                            'Tour Étoile',
                            'Douala',
                            '150K FCFA/month',
                            'assets/images/splash_image.webp',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNearbyCard(
                            'Résidence Moderne',
                            'Yaoundé',
                            '200K FCFA/month',
                            'assets/images/splash_image.webp',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNearbyCard(
                            'Villa Familiale',
                            'Buea',
                            '120K FCFA/month',
                            'assets/images/splash_image.webp',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNearbyCard(
                            'Appartement Étoile',
                            'Bamenda',
                            '135K FCFA/month',
                            'assets/images/splash_image.webp',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: WakaHouseBottomNavigation(
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7CB342) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          if (action.isNotEmpty)
            GestureDetector(
              onTap: () {
                // Navigate to appropriate screen based on title
                if (title.contains('Featured Estates')) {
                  NavigationService.navigateToDetail(
                    context,
                    const FeaturedEstatesScreen(),
                  );
                } else if (title.contains('Top Locations')) {
                  NavigationService.navigateToDetail(
                    context,
                    const LocationMapScreen(),
                  );
                } else if (title.contains('Top Landlords')) {
                  NavigationService.navigateToDetail(
                    context,
                    const TopEstateAgentScreen(), // Screen will show landlords
                  );
                } else if (title.contains('Nearby Estates')) {
                  NavigationService.navigateToDetail(
                    context,
                    const SearchResultsScreen(
                      searchQuery: '',
                      priceRange: RangeValues(50000, 500000),
                      propertyType: 'All',
                      location: 'All Locations',
                      amenities: [],
                      sortBy: 'Price: Low to High',
                    ),
                  );
                }

                // Show feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exploring $title'),
                    backgroundColor: const Color(0xFF7CB342),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7CB342),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(
    String title,
    String location,
    String price,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to Listing Details screen
        NavigationService.navigateToDetail(
          context,
          ListingDetailsScreen(
            title: title,
            price: price,
            imagePath: imagePath,
            location: location,
            rating: 4.9,
          ),
        );
      },
      child: Container(
        width: 320,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating section at top
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Bottom content
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$price/month',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7CB342),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationItem(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to Location Map screen
        NavigationService.navigateToDetail(context, const LocationMapScreen());

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exploring properties in $name'),
            backgroundColor: const Color(0xFF7CB342),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandlordItem(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to Top Landlords screen
        NavigationService.navigateToDetail(
          context,
          const TopEstateAgentScreen(), // Screen will show landlords
        );

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing landlord profile: $name'),
            backgroundColor: const Color(0xFF7CB342),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(
    String title,
    String location,
    String price,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigateToDetail(
          context,
          ListingDetailsScreen(
            title: title,
            price: price,
            imagePath: imagePath,
            location: location,
            rating: 4.9,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Star rating positioned at top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 10),
                        const SizedBox(width: 2),
                        const Text(
                          '4.7',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7CB342),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableFeaturedPropertyCard(
    String title,
    String subtitle,
    List<String> images,
    bool isSpecial,
  ) {
    PageController pageController = PageController();
    ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

    return GestureDetector(
      onTap: () {
        // Navigate to Featured Estates screen
        NavigationService.navigateToDetail(
          context,
          const FeaturedEstatesScreen(),
        );
      },
      child: Container(
        width: 200,
        height: 140,
        margin: const EdgeInsets.only(right: 12),
        child: ClipPath(
          clipper: DiagonalRoundedClipper(),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Scrollable Background Images with proper gesture handling
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    // Prevent parent ListView from receiving scroll events
                    return true;
                  },
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      currentPageNotifier.value = index;
                    },
                    itemCount: images.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient overlay for text readability
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // Text Content positioned on image
                Positioned(
                  left: 16,
                  top: 16,
                  right: 50, // Leave space for arrow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Navigation Arrow (matching design)
                Positioned(
                  right: 12,
                  top: 16,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to next image
                      int nextPage =
                          (currentPageNotifier.value + 1) % images.length;
                      pageController.animateToPage(
                        nextPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF2C3E50),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // Page Indicator Dots (showing current image)
                Positioned(
                  right: 12,
                  bottom: 16,
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          images.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: _buildPageDot(index == currentPage),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Decorative accent (optional)
                if (isSpecial)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7CB342).withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPropertyCard(
    String title,
    String subtitle,
    String imagePath,
    bool isSpecial,
  ) {
    return Container(
      width: 200,
      height: 140,
      margin: const EdgeInsets.only(right: 12),
      child: ClipPath(
        clipper: DiagonalRoundedClipper(),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient overlay for text readability
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Text Content positioned on image
              Positioned(
                left: 16,
                top: 16,
                right: 50, // Leave space for arrow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Navigation Arrow (matching design)
              Positioned(
                right: 12,
                top: 16,
                child: GestureDetector(
                  onTap: () {
                    // Handle navigation to more images/details
                    _showImageGallery(title, subtitle);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2C3E50),
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Page Indicator Dots (showing multiple images available)
              Positioned(
                right: 12,
                bottom: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPageDot(true), // Active dot
                    const SizedBox(width: 4),
                    _buildPageDot(false), // Inactive dot
                    const SizedBox(width: 4),
                    _buildPageDot(false), // Inactive dot
                  ],
                ),
              ),
              // Decorative accent (optional)
              if (isSpecial)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342).withOpacity(0.9),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesignPropertyCard(
    String title,
    String subtitle,
    String location,
    String rating,
    String price,
    String imagePath,
  ) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and Subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                  // Location with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF7F8C8D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Star Rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      // Price
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7CB342),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalPropertyCard(
    String title,
    String type,
    String location,
    String rating,
    String price,
    String imagePath,
  ) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Property Image
          Container(
            width: 90,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Type
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                  // Location with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 10,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF7F8C8D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Star Rating
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 10),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      // Price
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7CB342),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyListingCard(
    String title,
    String type,
    String location,
    String rating,
    String price,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Property Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Type
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Star Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      // Price
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7CB342),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build page indicator dots
  Widget _buildPageDot(bool isActive) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // Handle bottom navigation taps with unified transitions
  void _handleBottomNavTap(int index) {
    BottomNavigationService.handleBottomNavTap(
      context,
      index,
      getHomeScreen: () => const HomeScreen(),
      getSearchScreen: () => const SearchScreen(),
      getFavoritesScreen: () => const MyFavoriteScreen(),
      getProfileScreen: () => const ProfileScreen(),
    );
  }

  // Method to show image gallery (placeholder for now)
  void _showImageGallery(String title, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle),
              const SizedBox(height: 16),
              const Text(
                '✅ Scrollable Image Gallery Active!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7CB342),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Swipe left/right on the banner to see different images\n• Tap the arrow to navigate to next image\n• Watch the dots change to show current image',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
}
