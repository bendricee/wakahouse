import 'package:flutter/material.dart';
import 'add_listing_location_screen.dart';

class AddListingBasicScreen extends StatefulWidget {
  const AddListingBasicScreen({super.key});

  @override
  State<AddListingBasicScreen> createState() => _AddListingBasicScreenState();
}

class _AddListingBasicScreenState extends State<AddListingBasicScreen> {
  final TextEditingController _propertyNameController = TextEditingController();

  String selectedListingType = 'Rent';
  String selectedPropertyCategory = 'House';

  final List<String> listingTypes = ['Rent', 'Sell'];
  final List<String> propertyCategories = [
    'House',
    'Apartment',
    'Hotel',
    'Villa',
    'Cottage',
  ];

  @override
  void dispose() {
    _propertyNameController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 24, color: Color(0xFF2D3748)),
                children: [
                  TextSpan(
                    text: 'Hi Josh, Fill detail of your\n',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'real estate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7CB342),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Property Name Input
            _buildInputField(
              label: '',
              controller: _propertyNameController,
              hintText: 'The Lodge House',
              suffixIcon: Icons.home_outlined,
            ),

            const SizedBox(height: 24),

            // Listing Type Section
            _buildSectionTitle('Listing type'),
            const SizedBox(height: 12),
            _buildToggleButtons(
              options: listingTypes,
              selectedValue: selectedListingType,
              onChanged: (value) {
                setState(() {
                  selectedListingType = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Property Category Section
            _buildSectionTitle('Property category'),
            const SizedBox(height: 12),
            _buildCategoryGrid(),

            const SizedBox(height: 40),

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
                      onPressed: _isFormValid() ? _onNextPressed : null,
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: const Color(0xFF9CA3AF), size: 20)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildToggleButtons({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Row(
      children: options.map((option) {
        bool isSelected = selectedValue == option;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: option != options.last ? 12 : 0),
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7CB342)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF7CB342)
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D3748),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: propertyCategories.map((category) {
        bool isSelected = selectedPropertyCategory == category;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedPropertyCategory = category;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF7CB342)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF7CB342)
                    : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isFormValid() {
    return _propertyNameController.text.trim().isNotEmpty;
  }

  void _onNextPressed() {
    if (_isFormValid()) {
      // Navigate to location screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddListingLocationScreen(),
        ),
      );

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Basic details saved! Continue with detailed information.',
          ),
          backgroundColor: Color(0xFF7CB342),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
