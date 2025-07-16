import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final RangeValues priceRange;
  final String propertyType;
  final String location;
  final List<String> amenities;
  final String sortBy;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    required this.priceRange,
    required this.propertyType,
    required this.location,
    required this.amenities,
    required this.sortBy,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _buildFilterList();
  }

  void _buildFilterList() {
    selectedFilters.clear();

    if (widget.propertyType != 'All') {
      selectedFilters.add(widget.propertyType);
    }

    if (widget.location != 'All Locations') {
      selectedFilters.add(widget.location);
    }

    selectedFilters.add(
      '${(widget.priceRange.start / 1000).round()}k - ${(widget.priceRange.end / 1000).round()}k FCFA',
    );

    if (widget.amenities.isNotEmpty) {
      selectedFilters.addAll(
        widget.amenities.take(2),
      ); // Show first 2 amenities
      if (widget.amenities.length > 2) {
        selectedFilters.add('+${widget.amenities.length - 2} more');
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF2D3748)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Modern House',
                hintStyle: const TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Results Count and Sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Found 128 estates',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.grid_view,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7CB342),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.view_list,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filter Chips
          Container(
            height: 40,
            margin: const EdgeInsets.only(left: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFilters.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Chip(
                    label: Text(
                      selectedFilters[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: const Color(0xFF7CB342),
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                    onDeleted: () {
                      setState(() {
                        selectedFilters.removeAt(index);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Property List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPropertyCard(
                  'Villa Moderne Douala',
                  4.8,
                  'Douala, Littoral Region',
                  180000,
                  'assets/images/bridgeland_house.jpg',
                  'House',
                ),
                const SizedBox(height: 16),
                _buildPropertyCard(
                  'Résidence Étoile',
                  4.4,
                  'Yaoundé, Centre Region',
                  160000,
                  'assets/images/wayside_house.jpg',
                  'House',
                ),
                const SizedBox(height: 16),
                _buildPropertyCard(
                  'Maison Familiale Buea',
                  4.6,
                  'Buea, Southwest Region',
                  140000,
                  'assets/images/shoreview_house.jpg',
                  'House',
                ),
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(
    String title,
    double rating,
    String location,
    int price,
    String imagePath,
    String type,
  ) {
    return Container(
      height: 120,
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
      child: Row(
        children: [
          // Property Image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: Stack(
              children: [
                // Property Type Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFF9CA3AF),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
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
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF9CA3AF),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '${_formatPrice(price)} FCFA/month',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7CB342),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
