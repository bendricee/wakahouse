import 'package:flutter/material.dart';

class ListingDetailsScreen extends StatefulWidget {
  final String title;
  final String price;
  final String imagePath;
  final String location;
  final double rating;

  const ListingDetailsScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.location,
    required this.rating,
  });

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  bool isFavorite = false;
  bool isRentSelected = true;
  int selectedImageIndex = 0;

  // Property images for the gallery - using available image with different views
  final List<String> propertyImages = [
    'assets/images/splash_image.webp', // Main view
    'assets/images/splash_image.webp', // Interior view
    'assets/images/splash_image.webp', // Exterior view
  ]; // Rent vs Buy toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            _buildHeroImageSection(),

            // Property Details Section
            _buildPropertyDetailsSection(),

            // Agent Section
            _buildAgentSection(),

            // Amenities Section
            _buildAmenitiesSection(),

            // Location & Public Facilities
            _buildLocationSection(),

            // Map Section
            _buildMapSection(),

            // Cost of Living
            _buildCostOfLivingSection(),

            // Reviews Section
            _buildReviewsSection(),

            // Nearby Properties
            _buildNearbyPropertiesSection(),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildHeroImageSection() {
    return Container(
      height: 450, // Increased height for better visibility
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(propertyImages[selectedImageIndex]),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF2C3E50),
                  size: 20,
                ),
              ),
            ),
          ),

          // Share button
          Positioned(
            top: 50,
            right: 70,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share,
                color: Color(0xFF2C3E50),
                size: 20,
              ),
            ),
          ),

          // Favorite button
          Positioned(
            top: 50,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isFavorite ? const Color(0xFF7CB342) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.white : const Color(0xFF2C3E50),
                  size: 20,
                ),
              ),
            ),
          ),

          // Interactive image thumbnails
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                for (int i = 0; i < propertyImages.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildImageThumbnail(i),
                  ),
              ],
            ),
          ),

          // Rating overlay on image
          Positioned(
            bottom: 120,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFB800), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apartment type overlay on image (separate)
          Positioned(
            bottom: 120,
            left: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Apartment',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Property info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
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

  Widget _buildImageThumbnail(int index) {
    bool isSelected = selectedImageIndex == index;

    // Different visual styles for each thumbnail to distinguish them
    List<String> overlayTexts = ['Main', 'Interior', 'Exterior'];
    List<Color> overlayColors = [
      Colors.blue.withOpacity(0.7),
      Colors.green.withOpacity(0.7),
      Colors.orange.withOpacity(0.7),
    ];

    return GestureDetector(
      onTap: () {
        print(
          'Thumbnail $index tapped! Switching to image: ${propertyImages[index]}',
        );
        setState(() {
          selectedImageIndex = index;
        });
        print('Selected image index is now: $selectedImageIndex');
      },
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFF7CB342), width: 3)
              : Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              // Base image
              Image.asset(
                propertyImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 24,
                    ),
                  );
                },
              ),
              // Overlay to distinguish different views
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, overlayColors[index]],
                  ),
                ),
              ),
              // Text label for each view
              Positioned(
                bottom: 2,
                left: 2,
                right: 2,
                child: Text(
                  overlayTexts[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Rent/Buy Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isRentSelected = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isRentSelected
                            ? const Color(0xFF7CB342)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Rent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isRentSelected
                              ? Colors.white
                              : const Color(0xFF7F8C8D),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isRentSelected = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isRentSelected
                            ? const Color(0xFF7CB342)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Buy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: !isRentSelected
                              ? Colors.white
                              : const Color(0xFF7F8C8D),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Agent Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/splash_image.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Agent Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anderson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  'Owner',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                ),
              ],
            ),
          ),
          // Message Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.message,
              color: Color(0xFF7F8C8D),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAmenityItem(Icons.bed, '2 Bedroom'),
          _buildAmenityItem(Icons.bathtub, '1 Bathroom'),
          _buildAmenityItem(Icons.garage, '1 Garage'),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF7CB342).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7CB342), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location & Public Facilities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          _buildLocationItem(
            Icons.location_on,
            'Jl. Sultan Iskandar Muda',
            '1.2 km',
          ),
          const SizedBox(height: 12),
          _buildLocationItem(Icons.school, 'SMK Telkom Malang', '2.5 km'),
          const SizedBox(height: 12),
          _buildLocationItem(
            Icons.local_hospital,
            'Rumah Sakit Umum Malang',
            '1.5 km',
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(IconData icon, String name, String distance) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF7CB342), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
          ),
        ),
        Text(
          distance,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Row(
                children: [
                  _buildMapButton('Satellite', false),
                  const SizedBox(width: 8),
                  _buildMapButton('3D View', false),
                  const SizedBox(width: 8),
                  _buildMapButton('Direction', true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF8F9FA),
            ),
            child: Stack(
              children: [
                // Map placeholder
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/splash_image.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Map markers
                const Positioned(
                  top: 60,
                  left: 80,
                  child: Icon(
                    Icons.location_on,
                    color: Color(0xFF7CB342),
                    size: 30,
                  ),
                ),
                const Positioned(
                  bottom: 40,
                  right: 60,
                  child: Icon(
                    Icons.location_on,
                    color: Color(0xFF2C3E50),
                    size: 25,
                  ),
                ),
                // View on map button
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'View on map',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7CB342) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
        ),
      ),
    );
  }

  Widget _buildCostOfLivingSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cost of Living',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View details',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7CB342)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '415K FCFA/month',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Monthly cost',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          // Rating overview header - matching design exactly
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF34495E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFB800), size: 20),
                const SizedBox(width: 8),
                const Text(
                  '4.9',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // User avatars stack
                SizedBox(
                  width: 80,
                  height: 32,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: _buildUserAvatar(
                          'assets/images/splash_image.webp',
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: _buildUserAvatar(
                          'assets/images/splash_image.webp',
                        ),
                      ),
                      Positioned(
                        left: 40,
                        child: _buildUserAvatar(
                          'assets/images/splash_image.webp',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Individual reviews - matching design layout
          _buildReviewItem(
            'Ravi Shankar',
            5.0,
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            'assets/images/splash_image.webp',
          ),
          const SizedBox(height: 16),
          _buildReviewItem(
            'Joy Shetty',
            5.0,
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'assets/images/splash_image.webp',
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View all reviews',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7CB342),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String imagePath) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildReviewItem(
    String name,
    double rating,
    String review,
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Review content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and rating row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    // Star rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFB800),
                          size: 14,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Review text
                Text(
                  review,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyPropertiesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nearby From this Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNearbyPropertyCard(
                  'assets/images/splash_image.webp',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNearbyPropertyCard(
                  'assets/images/splash_image.webp',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyPropertyCard(String imagePath) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.message,
              color: Color(0xFF7F8C8D),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Rent Now button
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF7CB342),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Rent Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
