import 'package:flutter/material.dart';

class RealEstateTypeSelectionScreen extends StatefulWidget {
  const RealEstateTypeSelectionScreen({super.key});

  @override
  State<RealEstateTypeSelectionScreen> createState() => _RealEstateTypeSelectionScreenState();
}

class _RealEstateTypeSelectionScreenState extends State<RealEstateTypeSelectionScreen> {
  Set<int> selectedTypes = {};

  final List<String> propertyImages = [
    'assets/images/modern_house_1.jpg',
    'assets/images/apartment_interior_1.jpg',
    'assets/images/modern_interior_1.jpg',
    'assets/images/luxury_house_1.jpg',
    'assets/images/colorful_houses.jpg',
    'assets/images/traditional_house.jpg',
    'assets/images/row_houses.jpg',
    'assets/images/suburban_house.jpg',
    'assets/images/pool_house.jpg',
    'assets/images/garden_house.jpg',
    'assets/images/greenhouse_1.jpg',
    'assets/images/modern_house_2.jpg',
    'assets/images/luxury_interior.jpg',
    'assets/images/apartment_balcony.jpg',
    'assets/images/house_exterior.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2D3748),
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Handle skip action
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select your preferable\nreal estate type',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You can edit this later on your account setting',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Property Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: propertyImages.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedTypes.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTypes.remove(index);
                          } else {
                            selectedTypes.add(index);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF7CB342),
                                  width: 3,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Property Image
                              Image.asset(
                                propertyImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFE5E7EB),
                                    child: const Icon(
                                      Icons.home,
                                      color: Color(0xFF9CA3AF),
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                              // Selection Overlay
                              if (isSelected)
                                Container(
                                  color: const Color(0xFF7CB342).withValues(alpha: 0.3),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Show More Button
            Container(
              margin: const EdgeInsets.all(20),
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle show more action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CB342),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Show more',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
