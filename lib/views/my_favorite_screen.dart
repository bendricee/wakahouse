import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import '../services/navigation_state.dart';
import '../services/bottom_navigation_service.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'listing_details_screen.dart';

class MyFavoriteScreen extends StatefulWidget {
  const MyFavoriteScreen({super.key});

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> {
  bool isGridView = true;
  bool isSelectionMode = false;
  String selectedCategory = 'All';
  Set<int> selectedProperties = {};

  final List<String> categories = [
    'All',
    'Villa',
    'Apartment',
    'House',
    'Recently Added',
  ];

  final List<Map<String, dynamic>> favoriteProperties = [
    {
      'id': 1,
      'name': 'Villa Moderne Yaoundé',
      'price': 80000,
      'period': 'night',
      'rating': 4.9,
      'location': 'Yaoundé, Centre Region',
      'image': 'assets/images/laurels_villa_favorite.jpg',
      'isFavorite': true,
      'category': 'Villa',
      'dateAdded': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 2,
      'name': 'Résidence Étoile Douala',
      'price': 150000,
      'period': 'month',
      'rating': 4.4,
      'location': 'Douala, Littoral Region',
      'image': 'assets/images/wayside_modern_house.jpg',
      'isFavorite': true,
      'category': 'House',
      'dateAdded': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 3,
      'name': 'Appartement Moderne Buea',
      'price': 125000,
      'period': 'month',
      'rating': 4.9,
      'location': 'Buea, Southwest Region',
      'image': 'assets/images/wings_tower.jpg',
      'isFavorite': true,
      'category': 'Apartment',
      'dateAdded': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 4,
      'name': 'Luxury Villa Bamenda',
      'price': 200000,
      'period': 'month',
      'rating': 4.8,
      'location': 'Bamenda, Northwest Region',
      'image': 'assets/images/laurels_villa_favorite.jpg',
      'isFavorite': true,
      'category': 'Villa',
      'dateAdded': DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      'id': 5,
      'name': 'Modern Apartment Garoua',
      'price': 95000,
      'period': 'month',
      'rating': 4.6,
      'location': 'Garoua, North Region',
      'image': 'assets/images/wings_tower.jpg',
      'isFavorite': true,
      'category': 'Apartment',
      'dateAdded': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  List<Map<String, dynamic>> get filteredProperties {
    if (selectedCategory == 'All') {
      return favoriteProperties;
    } else if (selectedCategory == 'Recently Added') {
      final recentProperties = favoriteProperties.where((property) {
        final dateAdded = property['dateAdded'] as DateTime;
        return DateTime.now().difference(dateAdded).inDays <= 7;
      }).toList();
      recentProperties.sort(
        (a, b) =>
            (b['dateAdded'] as DateTime).compareTo(a['dateAdded'] as DateTime),
      );
      return recentProperties;
    } else {
      return favoriteProperties
          .where((property) => property['category'] == selectedCategory)
          .toList();
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      if (!isSelectionMode) {
        selectedProperties.clear();
      }
    });
  }

  void _togglePropertySelection(int propertyId) {
    setState(() {
      if (selectedProperties.contains(propertyId)) {
        selectedProperties.remove(propertyId);
      } else {
        selectedProperties.add(propertyId);
      }
    });
  }

  void _selectAllProperties() {
    setState(() {
      selectedProperties.addAll(filteredProperties.map((p) => p['id'] as int));
    });
  }

  void _deselectAllProperties() {
    setState(() {
      selectedProperties.clear();
    });
  }

  void _deleteSelectedProperties() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Properties'),
          content: Text(
            'Are you sure you want to remove ${selectedProperties.length} properties from favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoriteProperties.removeWhere(
                    (property) => selectedProperties.contains(property['id']),
                  );
                  selectedProperties.clear();
                  isSelectionMode = false;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Properties removed from favorites'),
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _removeFromFavorites(int propertyId) {
    setState(() {
      favoriteProperties.removeWhere(
        (property) => property['id'] == propertyId,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Property removed from favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  // Top Header Row
                  Row(
                    children: [
                      Text(
                        isSelectionMode
                            ? '${selectedProperties.length} selected'
                            : 'My favorite',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),

                      const Spacer(),

                      if (isSelectionMode) ...[
                        // Selection Mode Controls
                        GestureDetector(
                          onTap:
                              selectedProperties.length ==
                                  filteredProperties.length
                              ? _deselectAllProperties
                              : _selectAllProperties,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7CB342),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              selectedProperties.length ==
                                      filteredProperties.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: selectedProperties.isNotEmpty
                              ? _deleteSelectedProperties
                              : null,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selectedProperties.isNotEmpty
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: selectedProperties.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _toggleSelectionMode,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                      ] else ...[
                        // Normal Mode Controls
                        GestureDetector(
                          onTap: _toggleSelectionMode,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.checklist,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Category Filter Tabs
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = selectedCategory == category;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                              if (isSelectionMode) {
                                selectedProperties.clear();
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
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
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Results Header
                    Row(
                      children: [
                        Text(
                          '${filteredProperties.length} estates',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),

                        const Spacer(),

                        if (!isSelectionMode) ...[
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isGridView = true;
                                  });
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isGridView
                                        ? const Color(0xFF7CB342)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.grid_view,
                                    color: isGridView
                                        ? Colors.white
                                        : const Color(0xFF9CA3AF),
                                    size: 16,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isGridView = false;
                                  });
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: !isGridView
                                        ? const Color(0xFF7CB342)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.view_list,
                                    color: !isGridView
                                        ? Colors.white
                                        : const Color(0xFF9CA3AF),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Properties Grid/List
                    Expanded(
                      child: filteredProperties.isEmpty
                          ? _buildEmptyState()
                          : (isGridView ? _buildGridView() : _buildListView()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _handleBottomNavTap(0),
              child: _buildNavItem(Icons.home_outlined, false),
            ),
            GestureDetector(
              onTap: () => _handleBottomNavTap(1),
              child: _buildNavItem(Icons.search, false),
            ),
            GestureDetector(
              onTap: () => _handleBottomNavTap(2),
              child: _buildNavItem(Icons.favorite, true),
            ),
            GestureDetector(
              onTap: () => _handleBottomNavTap(3),
              child: _buildNavItem(Icons.person_outline, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            selectedCategory == 'All'
                ? 'No favorites yet'
                : 'No ${selectedCategory.toLowerCase()} properties',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedCategory == 'All'
                ? 'Start exploring and save your favorite properties'
                : 'Try browsing other categories or add more favorites',
            style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              // Navigate to search screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF7CB342),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Explore Properties',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        final property = filteredProperties[index];
        return _buildPropertyCard(property, index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        final property = filteredProperties[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildSwipeablePropertyCard(property, index),
        );
      },
    );
  }

  Widget _buildSwipeablePropertyCard(Map<String, dynamic> property, int index) {
    return Dismissible(
      key: Key('property_${property['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remove from Favorites'),
              content: Text(
                'Remove "${property['name']}" from your favorites?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _removeFromFavorites(property['id']);
      },
      child: _buildPropertyCard(property, index, isListView: true),
    );
  }

  Widget _buildPropertyCard(
    Map<String, dynamic> property,
    int index, {
    bool isListView = false,
  }) {
    final propertyId = property['id'] as int;
    final isSelected = selectedProperties.contains(propertyId);

    return GestureDetector(
      onTap: () {
        if (isSelectionMode) {
          _togglePropertySelection(propertyId);
        } else {
          NavigationService.navigateToDetail(
            context,
            ListingDetailsScreen(
              title: property['name'],
              price:
                  '${_formatPrice(property['price'])} FCFA/${property['period']}',
              imagePath: property['image'],
              location: property['location'],
              rating: property['rating'].toDouble(),
            ),
          );
        }
      },
      onLongPress: () {
        if (!isSelectionMode) {
          _toggleSelectionMode();
          _togglePropertySelection(propertyId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(property['image']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Selection Mode Overlay
                    if (isSelectionMode)
                      Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7CB342).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                      ),

                    // Selection Checkbox
                    if (isSelectionMode)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF7CB342)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF7CB342)
                                  : const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),

                    // Favorite Button (only show when not in selection mode)
                    if (!isSelectionMode)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7CB342),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),

                    // Price Badge
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_formatPrice(property['price'])} FCFA/${property['period']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Property Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFC107),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property['rating'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF9CA3AF),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property['location'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF7CB342) : const Color(0xFF9CA3AF),
            size: 24,
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF7CB342),
                shape: BoxShape.circle,
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

  String _formatPrice(int price) {
    if (price >= 1000000) {
      double priceInM = price / 1000000;
      return '${priceInM.toStringAsFixed(priceInM.truncateToDouble() == priceInM ? 0 : 1)}M';
    } else if (price >= 1000) {
      double priceInK = price / 1000;
      return '${priceInK.toStringAsFixed(priceInK.truncateToDouble() == priceInK ? 0 : 1)}K';
    }
    return price.toString();
  }
}
