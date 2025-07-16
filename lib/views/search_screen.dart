import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'home_screen.dart';
import 'my_favorite_screen.dart';
import 'search_results_screen.dart';
import '../services/navigation_state.dart';
import '../services/bottom_navigation_service.dart';
import '../services/navigation_service.dart';
import '../widgets/wakahouse_bottom_navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Search tab selected
  final TextEditingController _searchController = TextEditingController();

  // Filter state variables
  RangeValues _priceRange = const RangeValues(50000, 500000);
  String _selectedPropertyType = 'All';
  String _selectedLocation = 'All Locations';
  List<String> _selectedAmenities = [];
  String _sortBy = 'Price: Low to High';
  bool _showFilters = false;

  // Property types for Cameroon market
  final List<String> _propertyTypes = [
    'All',
    'Room',
    'Studio',
    'Apartment',
    'Villa',
  ];

  // Locations
  final List<String> _locations = [
    'All Locations',
    'Yaoundé',
    'Douala',
    'Buea',
    'Bamenda',
    'Garoua',
    'Maroua',
  ];

  // Modern amenities for Cameroon market
  final List<String> _amenities = [
    'WiFi/Internet',
    'Security Guard',
    'Swimming Pool',
    'Generator/Backup Power',
    'Parking',
    'Air Conditioning',
    'Furnished',
    'Unfurnished',
    'Water Supply',
    'Gated Community',
  ];

  // Sort options
  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Oldest First',
    'Rating: High to Low',
    'Size: Large to Small',
  ];

  @override
  void initState() {
    super.initState();
    // Ensure search tab is selected when search screen is initialized
    BottomNavigationService.state.setSelectedIndex(1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    // Navigate to search results with current filters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchQuery: _searchController.text,
          priceRange: _priceRange,
          propertyType: _selectedPropertyType,
          location: _selectedLocation,
          amenities: _selectedAmenities,
          sortBy: _sortBy,
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(50000, 500000);
      _selectedPropertyType = 'All';
      _selectedLocation = 'All Locations';
      _selectedAmenities.clear();
      _sortBy = 'Price: Low to High';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search properties...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF7CB342),
                          size: 24,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _showFilters
                                  ? const Color(0xFF7CB342)
                                  : const Color(0xFF9CA3AF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _performSearch,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CB342),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Search',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _clearFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filters Section (Expandable)
            if (_showFilters) _buildFiltersSection(),

            // Content Area
            Expanded(
              child: _showFilters
                  ? Container() // Show filters when expanded
                  : _buildMapView(), // Show map when filters are collapsed
            ),
          ],
        ),
      ),
      bottomNavigationBar: WakaHouseBottomNavigation(
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://maps.googleapis.com/maps/api/staticmap?center=-6.2088,106.8456&zoom=12&size=400x800&maptype=roadmap&style=feature:all|element:geometry|color:0xf5f5f5&style=feature:all|element:labels.icon|visibility:off&style=feature:all|element:labels.text.fill|color:0x616161&style=feature:all|element:labels.text.stroke|color:0xf5f5f5&style=feature:administrative|element:geometry|color:0xfefefe&style=feature:administrative.land_parcel|element:labels.text.fill|color:0xbdbdbd&style=feature:poi|element:geometry|color:0xeeeeee&style=feature:poi.park|element:geometry|color:0xe5e5e5&style=feature:road|element:geometry|color:0xffffff&style=feature:road.arterial|element:labels.text.fill|color:0x757575&style=feature:road.highway|element:geometry|color:0xdadada&style=feature:road.highway|element:labels.text.fill|color:0x616161&style=feature:road.local|element:labels.text.fill|color:0x9e9e9e&style=feature:transit.line|element:geometry|color:0xe5e5e5&style=feature:transit.station|element:geometry|color:0xeeeeee&style=feature:water|element:geometry|color:0xc9c9c9&key=YOUR_API_KEY',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Map overlay with property markers
              Positioned(
                top: 50,
                left: 50,
                child: _buildPropertyMarker('Villa Moderne', '80,000 FCFA'),
              ),
              Positioned(
                top: 120,
                right: 80,
                child: _buildPropertyMarker('Résidence Étoile', '150,000 FCFA'),
              ),
              Positioned(
                bottom: 100,
                left: 80,
                child: _buildPropertyMarker('Appartement Buea', '125,000 FCFA'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyMarker(String name, String price) {
    return GestureDetector(
      onTap: () => _performSearch(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              price,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Range Filter
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000000,
            divisions: 20,
            activeColor: const Color(0xFF7CB342),
            inactiveColor: const Color(0xFFE2E8F0),
            labels: RangeLabels(
              '${(_priceRange.start / 1000).round()}k FCFA',
              '${(_priceRange.end / 1000).round()}k FCFA',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),

          const SizedBox(height: 20),

          // Property Type Filter
          const Text(
            'Property Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _propertyTypes.map((type) {
              final isSelected = _selectedPropertyType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPropertyType = type;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF7CB342)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7CB342)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Location Filter
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLocation,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                items: _locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Amenities Filter
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenities.map((amenity) {
              final isSelected = _selectedAmenities.contains(amenity);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedAmenities.remove(amenity);
                    } else {
                      _selectedAmenities.add(amenity);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF7CB342)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7CB342)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    amenity,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Sort By Filter
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                items: _sortOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _sortBy = newValue!;
                  });
                },
              ),
            ),
          ),
        ],
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
}
