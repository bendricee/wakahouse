import 'package:flutter/material.dart';
import 'listing_published_success_screen.dart';

class AddListingPhotosScreen extends StatefulWidget {
  const AddListingPhotosScreen({super.key});

  @override
  State<AddListingPhotosScreen> createState() => _AddListingPhotosScreenState();
}

class _AddListingPhotosScreenState extends State<AddListingPhotosScreen> {
  List<String> selectedPhotos = [
    'assets/images/house1.jpg',
    'assets/images/house2.jpg',
    'assets/images/house3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2D3748),
              size: 18,
            ),
          ),
        ),
        title: const Text(
          'Add Listing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Title
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 24, color: Color(0xFF2D3748)),
                children: [
                  TextSpan(
                    text: 'Add ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'photos ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7CB342),
                    ),
                  ),
                  TextSpan(
                    text: 'to your\nlisting',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Photos Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: 4, // 3 photos + 1 add button
                itemBuilder: (context, index) {
                  if (index < selectedPhotos.length) {
                    return _buildPhotoCard(selectedPhotos[index], index);
                  } else {
                    return _buildAddPhotoCard();
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Buttons
            Row(
              children: [
                // Back Button
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF2D3748),
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Next Button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: selectedPhotos.isNotEmpty
                          ? _onNextPressed
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7CB342),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String imagePath, int index) {
    return Container(
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
      child: Stack(
        children: [
          // Photo
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF1F5F9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: const Color(0xFFE2E8F0),
                child: const Icon(
                  Icons.image,
                  size: 48,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ),

          // Remove button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPhotos.removeAt(index);
                });
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),

          // Check mark for selected
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF7CB342),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _addPhoto,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 2,
            style: BorderStyle.solid,
          ),
          color: const Color(0xFFF8FAFC),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Color(0xFF7CB342), size: 48),
            SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPhoto() {
    // Simulate adding a photo
    setState(() {
      selectedPhotos.add('assets/images/house${selectedPhotos.length + 1}.jpg');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo added successfully!'),
        backgroundColor: Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onNextPressed() {
    if (selectedPhotos.isNotEmpty) {
      // Simulate publishing process
      _showPublishingDialog();
    }
  }

  void _showPublishingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
        ),
      ),
    );

    // Simulate publishing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        // Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ListingPublishedSuccessScreen(),
          ),
        );
      }
    });
  }
}
