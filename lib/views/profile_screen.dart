import 'package:flutter/material.dart';
import 'transaction_details_screen.dart';
import 'search_screen.dart';
import 'home_screen.dart';
import 'my_favorite_screen.dart';
import 'edit_profile_screen.dart' as edit_profile;
import 'admin_dashboard_screen.dart' as admin;
import 'landlord_approval_status_screen.dart';
import 'add_listing_basic_screen.dart';
import '../models/user_types.dart';
import '../services/navigation_state.dart';
import '../services/bottom_navigation_service.dart';
import '../widgets/wakahouse_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedTab = 'Transaction';

  @override
  void initState() {
    super.initState();
    // Ensure profile tab is selected when profile screen is initialized
    SimpleNavigationService.state.setToProfile();
  }

  // Track favorite states for listings
  Map<String, bool> favoriteStates = {
    'Fairview Apartment': false,
    'Shootview House': false,
  };

  // Track favorite states for transactions
  Map<String, bool> transactionFavoriteStates = {
    'Wings Tower': false,
    'Bridgeland Modern House': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        GestureDetector(
                          onTap: _showSettingsMenu,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Color(0xFF2C3E50),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Profile Avatar with Edit Button
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
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
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _navigateToEditProfile,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7CB342),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Name and Email
                    Row(
                      children: [
                        const Text(
                          'Mathew Adam',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2196F3)),
                          ),
                          child: const Text(
                            'Tenant',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'mathew@gmail.com',
                      style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('30', 'Listings'),
                        _buildStatItem('12', 'Sold'),
                        _buildStatItem('28', 'Reviews'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tab Buttons
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton('Transaction'),
                          _buildTabButton('Listings'),
                          _buildTabButton('Sold'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic content based on selected tab
                    if (selectedTab == 'Transaction') ...[
                      // Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '2 transactions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.apps,
                              color: Color(0xFF2C3E50),
                              size: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Transaction Cards Container
                      Container(
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
                            Expanded(
                              child: _buildTransactionCard(
                                'Wings Tower',
                                'November 21, 2021',
                                'Rent',
                                'assets/images/splash_image.webp',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTransactionCard(
                                'Bridgeland Modern House',
                                'December 17, 2021',
                                'Rent',
                                'assets/images/splash_image.webp',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (selectedTab == 'Listings') ...[
                      // Listings Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '30 listings',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.apps,
                                  color: Color(0xFF2C3E50),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddListingBasicScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C3E50),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Listings Grid
                      Container(
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
                            Expanded(
                              child: _buildListingCard(
                                'Appartement Fairview',
                                '185K FCFA',
                                'month',
                                4.9,
                                'Douala, Cameroun',
                                'assets/images/splash_image.webp',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildListingCard(
                                'Maison Shootview',
                                '160K FCFA',
                                'month',
                                4.8,
                                'Yaoundé, Cameroun',
                                'assets/images/splash_image.webp',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (selectedTab == 'Sold') ...[
                      // Sold Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '12 sold',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.apps,
                              color: Color(0xFF2C3E50),
                              size: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Sold Properties Container
                      Container(
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
                        child: const Center(
                          child: Text(
                            'Sold properties will be displayed here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildStatItem(String number, String label) {
    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF7F8C8D)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2C3E50)
                  : const Color(0xFF7F8C8D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    String title,
    String date,
    String type,
    String imagePath,
  ) {
    bool isFavorite = transactionFavoriteStates[title] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailsScreen(
              propertyTitle: title,
              propertyImage: imagePath,
              location: 'Jakarta, Indonesia',
              transactionType: type,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with curved radius
          Container(
            height: 120, // Reduced height to fit better
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Interactive Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        transactionFavoriteStates[title] = !isFavorite;
                      });
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.red
                            : const Color(0xFF7F8C8D),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // Rent Badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CB342),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ), // Reduced space between image and description
          // Description Container
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 2,
              ), // Further reduced space between name and date
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF7CB342),
                    size: 12,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

  // Settings menu with profile and admin options
  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingsOption(
              'Edit Profile',
              'Update your personal information and preferences',
              Icons.person_outline,
              _navigateToEditProfile,
            ),
            _buildSettingsOption(
              'Admin Dashboard',
              'Manage landlord applications and approvals',
              Icons.admin_panel_settings,
              _navigateToAdminDashboard,
            ),
            _buildSettingsOption(
              'Approval Status',
              'Check your landlord verification status',
              Icons.verified_user,
              _navigateToApprovalStatus,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF7CB342), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  // Helper method for edit profile navigation
  void _navigateToEditProfile() {
    // Create a user profile with current data from the profile screen
    final currentProfile = edit_profile.UserProfile(
      name: 'Mathew Adam',
      email: 'mathew@gmail.com',
      phone: '+237 677 123 456',
      bio: 'Real estate enthusiast looking for the perfect home in Cameroon',
      userType: edit_profile
          .UserType
          .tenant, // Default to tenant, can be changed in profile
      selectedRegion: 'Yaoundé',
      selectedLanguage: 'English',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            edit_profile.EditProfileScreen(initialProfile: currentProfile),
      ),
    ).then((updatedProfile) {
      // Handle the updated profile data when user returns
      if (updatedProfile != null &&
          updatedProfile is edit_profile.UserProfile) {
        // Here you could update the profile screen with the new data
        // For now, we'll just refresh the screen
        setState(() {
          // Profile data updated
        });
      }
    });
  }

  // Helper method for admin dashboard navigation
  void _navigateToAdminDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const admin.AdminDashboardScreen(),
      ),
    );
  }

  // Helper method for approval status navigation
  void _navigateToApprovalStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandlordApprovalStatusScreen(
          status: ApprovalStatus.pending,
          submissionDate: '2024-01-15',
        ),
      ),
    );
  }

  Widget _buildListingCard(
    String title,
    String price,
    String period,
    double rating,
    String location,
    String imagePath,
  ) {
    bool isFavorite = favoriteStates[title] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Container with curved radius
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Interactive Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      favoriteStates[title] = !isFavorite;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFF2C3E50),
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Edit button
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () {
                    // Handle edit functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Edit $title'),
                        backgroundColor: const Color(0xFF7CB342),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF7CB342),
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Price tag
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$price/$period',
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

        const SizedBox(height: 8),

        // Property Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Rating
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFFFB800), size: 14),
            const SizedBox(width: 4),
            Text(
              rating.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Location
        Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF7F8C8D), size: 12),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                location,
                style: const TextStyle(fontSize: 11, color: Color(0xFF7F8C8D)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
