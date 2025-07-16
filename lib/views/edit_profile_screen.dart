import 'package:flutter/material.dart';

enum UserType { tenant, landlord }

enum VerificationStatus { pending, approved, rejected, notSubmitted }

enum ApprovalStatus { pending, approved, rejected }

class UserProfile {
  String name;
  String email;
  String phone;
  String bio;
  UserType userType;
  String? profileImagePath;
  String selectedRegion;
  String selectedLanguage;
  VerificationStatus verificationStatus;
  ApprovalStatus approvalStatus;
  Map<String, bool> notificationSettings;
  Map<String, bool> privacySettings;
  String? emergencyContactName;
  String? emergencyContactPhone;
  double minBudget;
  double maxBudget;
  List<String> preferredPropertyTypes;
  List<String> preferredLocations;
  bool twoFactorEnabled;
  int profileCompletionPercentage;

  UserProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.bio = '',
    this.userType = UserType.tenant,
    this.profileImagePath,
    this.selectedRegion = 'Yaoundé',
    this.selectedLanguage = 'English',
    this.verificationStatus = VerificationStatus.notSubmitted,
    this.approvalStatus = ApprovalStatus.pending,
    Map<String, bool>? notificationSettings,
    Map<String, bool>? privacySettings,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.minBudget = 50000,
    this.maxBudget = 500000,
    List<String>? preferredPropertyTypes,
    List<String>? preferredLocations,
    this.twoFactorEnabled = false,
    this.profileCompletionPercentage = 0,
  }) : notificationSettings =
           notificationSettings ??
           {'email': true, 'push': true, 'sms': false, 'marketing': false},
       privacySettings =
           privacySettings ??
           {
             'profileVisible': true,
             'contactVisible': true,
             'dataSharing': false,
           },
       preferredPropertyTypes = preferredPropertyTypes ?? ['Room'],
       preferredLocations = preferredLocations ?? ['Yaoundé'];
}

class EditProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late UserProfile _profile;
  late TabController _tabController;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;

  // Form state
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  Map<String, String?> _fieldErrors = {};

  // Constants
  final List<String> _cameroonRegions = [
    'Yaoundé',
    'Douala',
    'Buea',
    'Bamenda',
    'Bafoussam',
    'Garoua',
    'Maroua',
    'Ngaoundéré',
  ];

  final List<String> _propertyTypes = ['Room', 'Studio', 'Apartment', 'Villa'];
  final List<String> _languages = ['English', 'French'];

  @override
  void initState() {
    super.initState();
    _profile =
        widget.initialProfile ??
        UserProfile(
          name: 'Jean-Baptiste Mbarga',
          email: 'jean.mbarga@email.com',
          phone: '+237 6XX XXX XXX',
          bio: 'Looking for a comfortable apartment in Yaoundé',
          userType: UserType.tenant,
        );

    _tabController = TabController(length: 4, vsync: this);
    _initializeControllers();
    _calculateProfileCompletion();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _profile.name);
    _emailController = TextEditingController(text: _profile.email);
    _phoneController = TextEditingController(text: _profile.phone);
    _bioController = TextEditingController(text: _profile.bio);
    _emergencyNameController = TextEditingController(
      text: _profile.emergencyContactName ?? '',
    );
    _emergencyPhoneController = TextEditingController(
      text: _profile.emergencyContactPhone ?? '',
    );

    // Add listeners for unsaved changes detection
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
    _emergencyNameController.addListener(_onFieldChanged);
    _emergencyPhoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _calculateProfileCompletion() {
    int completedFields = 0;
    int totalFields = _profile.userType == UserType.landlord ? 12 : 8;

    if (_profile.name.isNotEmpty) completedFields++;
    if (_profile.email.isNotEmpty) completedFields++;
    if (_profile.phone.isNotEmpty) completedFields++;
    if (_profile.bio.isNotEmpty) completedFields++;
    if (_profile.profileImagePath != null) completedFields++;
    if (_profile.preferredLocations.isNotEmpty) completedFields++;
    if (_profile.preferredPropertyTypes.isNotEmpty) completedFields++;
    if (_profile.selectedRegion.isNotEmpty) completedFields++;

    if (_profile.userType == UserType.landlord) {
      if (_profile.emergencyContactName?.isNotEmpty == true) completedFields++;
      if (_profile.emergencyContactPhone?.isNotEmpty == true) completedFields++;
      if (_profile.verificationStatus != VerificationStatus.notSubmitted)
        completedFields++;
      if (_profile.twoFactorEnabled) completedFields++;
    }

    setState(() {
      _profile.profileCompletionPercentage =
          ((completedFields / totalFields) * 100).round();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _showUnsavedChangesDialog();
          if (shouldPop == true && mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              // Header with Profile Completion
              _buildHeader(),

              // Tab Bar
              _buildTabBar(),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPersonalInfoTab(),
                    _buildPreferencesTab(),
                    _buildNotificationsTab(),
                    _buildSecurityTab(),
                  ],
                ),
              ),

              // Save/Cancel Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (_hasUnsavedChanges) {
                    final shouldPop = await _showUnsavedChangesDialog();
                    if (shouldPop == true) {
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
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
              const SizedBox(width: 16),
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              _buildUserTypeBadge(),
            ],
          ),
          const SizedBox(height: 20),

          // Profile Photo and Completion
          Row(
            children: [
              _buildProfilePhoto(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profile.name.isNotEmpty ? _profile.name : 'Your Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _profile.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildProfileCompletion(),
                  ],
                ),
              ),
            ],
          ),

          // Approval Status for Landlords
          if (_profile.userType == UserType.landlord) ...[
            const SizedBox(height: 16),
            _buildApprovalStatus(),
          ],
        ],
      ),
    );
  }

  Widget _buildUserTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _profile.userType == UserType.landlord
            ? const Color(0xFF7CB342).withValues(alpha: 0.1)
            : const Color(0xFF2196F3).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _profile.userType == UserType.landlord
              ? const Color(0xFF7CB342)
              : const Color(0xFF2196F3),
        ),
      ),
      child: Text(
        _profile.userType == UserType.landlord ? 'Landlord' : 'Tenant',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _profile.userType == UserType.landlord
              ? const Color(0xFF7CB342)
              : const Color(0xFF2196F3),
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return GestureDetector(
      onTap: _selectProfilePhoto,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF7CB342),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7CB342).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _profile.profileImagePath != null
            ? ClipOval(
                child: Image.asset(
                  _profile.profileImagePath!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.person, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildProfileCompletion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Profile ${_profile.profileCompletionPercentage}% complete',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const Spacer(),
            Text(
              '${_profile.profileCompletionPercentage}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7CB342),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: _profile.profileCompletionPercentage / 100,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildApprovalStatus() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (_profile.approvalStatus) {
      case ApprovalStatus.pending:
        statusColor = const Color(0xFFFF9800);
        statusText = 'Approval Pending';
        statusIcon = Icons.access_time;
        break;
      case ApprovalStatus.approved:
        statusColor = const Color(0xFF7CB342);
        statusText = 'Approved Landlord';
        statusIcon = Icons.verified;
        break;
      case ApprovalStatus.rejected:
        statusColor = const Color(0xFFE53E3E);
        statusText = 'Approval Rejected';
        statusIcon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 16),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
          if (_profile.approvalStatus == ApprovalStatus.pending) ...[
            const Spacer(),
            Text(
              'Est. 2-3 days',
              style: TextStyle(fontSize: 12, color: statusColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF7CB342),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Preferences'),
          Tab(text: 'Notifications'),
          Tab(text: 'Security'),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Personal Information', Icons.person),
            const SizedBox(height: 16),

            _buildTextFormField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Name is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextFormField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Email is required';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value!)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextFormField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+237 6XX XXX XXX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Phone number is required';
                }
                if (!RegExp(
                  r'^\+237\s[6-9]\d{2}\s\d{3}\s\d{3}$',
                ).hasMatch(value!)) {
                  return 'Enter a valid Cameroon phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextFormField(
              controller: _bioController,
              label: 'Bio',
              hint: 'Tell us about yourself...',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (value) {
                if (_profile.userType == UserType.landlord &&
                    (value?.isEmpty ?? true)) {
                  return 'Bio is required for landlords';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Location', Icons.location_on),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: 'Region',
              value: _profile.selectedRegion,
              items: _cameroonRegions,
              onChanged: (value) {
                setState(() {
                  _profile.selectedRegion = value!;
                  _onFieldChanged();
                });
              },
              icon: Icons.location_city,
            ),

            const SizedBox(height: 16),

            _buildDropdownField(
              label: 'Language',
              value: _profile.selectedLanguage,
              items: _languages,
              onChanged: (value) {
                setState(() {
                  _profile.selectedLanguage = value!;
                  _onFieldChanged();
                });
              },
              icon: Icons.language,
            ),

            // Emergency Contact (Required for Landlords)
            if (_profile.userType == UserType.landlord) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('Emergency Contact', Icons.emergency),
              const SizedBox(height: 16),

              _buildTextFormField(
                controller: _emergencyNameController,
                label: 'Emergency Contact Name',
                hint: 'Enter emergency contact name',
                icon: Icons.contact_emergency,
                validator: (value) {
                  if (_profile.userType == UserType.landlord &&
                      (value?.isEmpty ?? true)) {
                    return 'Emergency contact is required for landlords';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextFormField(
                controller: _emergencyPhoneController,
                label: 'Emergency Contact Phone',
                hint: '+237 6XX XXX XXX',
                icon: Icons.phone_in_talk,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (_profile.userType == UserType.landlord &&
                      (value?.isEmpty ?? true)) {
                    return 'Emergency contact phone is required for landlords';
                  }
                  if (value?.isNotEmpty == true &&
                      !RegExp(
                        r'^\+237\s[6-9]\d{2}\s\d{3}\s\d{3}$',
                      ).hasMatch(value!)) {
                    return 'Enter a valid Cameroon phone number';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 100), // Space for action buttons
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Property Preferences', Icons.home),
          const SizedBox(height: 16),

          // Budget Range
          _buildBudgetRangeSlider(),

          const SizedBox(height: 24),

          // Property Types
          _buildSectionHeader('Preferred Property Types', Icons.apartment),
          const SizedBox(height: 16),
          _buildPropertyTypeSelection(),

          const SizedBox(height: 24),

          // Preferred Locations
          _buildSectionHeader('Preferred Locations', Icons.location_on),
          const SizedBox(height: 16),
          _buildLocationSelection(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notification Preferences', Icons.notifications),
          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Email Notifications',
            'Receive updates via email',
            Icons.email,
            _profile.notificationSettings['email'] ?? true,
            (value) {
              setState(() {
                _profile.notificationSettings['email'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Push Notifications',
            'Receive push notifications on your device',
            Icons.notifications_active,
            _profile.notificationSettings['push'] ?? true,
            (value) {
              setState(() {
                _profile.notificationSettings['push'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'SMS Notifications',
            'Receive important updates via SMS',
            Icons.sms,
            _profile.notificationSettings['sms'] ?? false,
            (value) {
              setState(() {
                _profile.notificationSettings['sms'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Marketing Communications',
            'Receive promotional offers and updates',
            Icons.campaign,
            _profile.notificationSettings['marketing'] ?? false,
            (value) {
              setState(() {
                _profile.notificationSettings['marketing'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('Privacy Settings', Icons.privacy_tip),
          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Profile Visibility',
            'Make your profile visible to other users',
            Icons.visibility,
            _profile.privacySettings['profileVisible'] ?? true,
            (value) {
              setState(() {
                _profile.privacySettings['profileVisible'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Contact Information Visible',
            'Allow others to see your contact details',
            Icons.contact_phone,
            _profile.privacySettings['contactVisible'] ?? true,
            (value) {
              setState(() {
                _profile.privacySettings['contactVisible'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Data Sharing',
            'Share anonymized data for app improvement',
            Icons.share,
            _profile.privacySettings['dataSharing'] ?? false,
            (value) {
              setState(() {
                _profile.privacySettings['dataSharing'] = value;
                _onFieldChanged();
              });
            },
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Account Security', Icons.security),
          const SizedBox(height: 16),

          _buildSecurityOption(
            'Change Password',
            'Update your account password',
            Icons.lock_outline,
            () => _showChangePasswordDialog(),
          ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            'Two-Factor Authentication',
            'Add an extra layer of security to your account',
            Icons.verified_user,
            _profile.twoFactorEnabled,
            (value) {
              setState(() {
                _profile.twoFactorEnabled = value;
                _onFieldChanged();
              });
              if (value) {
                _showTwoFactorSetupDialog();
              }
            },
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('Account Management', Icons.manage_accounts),
          const SizedBox(height: 16),

          _buildSecurityOption(
            'Download My Data',
            'Download a copy of your personal data',
            Icons.download,
            () => _downloadUserData(),
          ),

          const SizedBox(height: 16),

          _buildSecurityOption(
            'Delete Account',
            'Permanently delete your account and data',
            Icons.delete_forever,
            () => _showDeleteAccountDialog(),
            isDestructive: true,
          ),

          // Verification Status for Landlords
          if (_profile.userType == UserType.landlord) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Verification', Icons.verified),
            const SizedBox(height: 16),
            _buildVerificationStatus(),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Helper Methods
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF7CB342).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF7CB342), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7CB342), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF7CB342), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetRangeSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Range (FCFA)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: RangeValues(_profile.minBudget, _profile.maxBudget),
            min: 25000,
            max: 1000000,
            divisions: 39,
            activeColor: const Color(0xFF7CB342),
            inactiveColor: const Color(0xFFE5E7EB),
            labels: RangeLabels(
              '${(_profile.minBudget / 1000).round()}K',
              '${(_profile.maxBudget / 1000).round()}K',
            ),
            onChanged: (values) {
              setState(() {
                _profile.minBudget = values.start;
                _profile.maxBudget = values.end;
                _onFieldChanged();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FCFA ${(_profile.minBudget / 1000).round()}K',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'FCFA ${(_profile.maxBudget / 1000).round()}K',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _propertyTypes.map((type) {
        final isSelected = _profile.preferredPropertyTypes.contains(type);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _profile.preferredPropertyTypes.remove(type);
              } else {
                _profile.preferredPropertyTypes.add(type);
              }
              _onFieldChanged();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7CB342) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF7CB342)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _cameroonRegions.map((location) {
        final isSelected = _profile.preferredLocations.contains(location);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _profile.preferredLocations.remove(location);
              } else {
                _profile.preferredLocations.add(location);
              }
              _onFieldChanged();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7CB342) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF7CB342)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Text(
              location,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7CB342).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF7CB342), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7CB342),
            activeTrackColor: const Color(0xFF7CB342).withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                    : const Color(0xFF7CB342).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF7CB342),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _profile.verificationStatus == VerificationStatus.approved
                    ? Icons.verified
                    : _profile.verificationStatus == VerificationStatus.pending
                    ? Icons.access_time
                    : Icons.upload_file,
                color:
                    _profile.verificationStatus == VerificationStatus.approved
                    ? const Color(0xFF7CB342)
                    : _profile.verificationStatus == VerificationStatus.pending
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                _getVerificationStatusText(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getVerificationStatusDescription(),
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          if (_profile.verificationStatus ==
              VerificationStatus.notSubmitted) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _uploadVerificationDocuments,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CB342),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Upload Documents'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                if (_hasUnsavedChanges) {
                  final shouldDiscard = await _showUnsavedChangesDialog();
                  if (shouldDiscard == true) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _hasUnsavedChanges ? _saveProfile : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CB342),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE5E7EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
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

  // Action Methods
  void _selectProfilePhoto() async {
    // Implement photo selection logic
    _showSnackBar('Photo selection feature coming soon!');
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Update profile data from controllers
      _profile.name = _nameController.text;
      _profile.email = _emailController.text;
      _profile.phone = _phoneController.text;
      _profile.bio = _bioController.text;
      _profile.emergencyContactName = _emergencyNameController.text.isEmpty
          ? null
          : _emergencyNameController.text;
      _profile.emergencyContactPhone = _emergencyPhoneController.text.isEmpty
          ? null
          : _emergencyPhoneController.text;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _calculateProfileCompletion();

      setState(() {
        _hasUnsavedChanges = false;
        _isLoading = false;
      });

      _showSnackBar('Profile updated successfully!');

      // Return updated profile to previous screen
      Navigator.pop(context, _profile);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Failed to update profile. Please try again.');
    }
  }

  String _getVerificationStatusText() {
    switch (_profile.verificationStatus) {
      case VerificationStatus.approved:
        return 'Verified';
      case VerificationStatus.pending:
        return 'Verification Pending';
      case VerificationStatus.rejected:
        return 'Verification Rejected';
      case VerificationStatus.notSubmitted:
        return 'Not Verified';
    }
  }

  String _getVerificationStatusDescription() {
    switch (_profile.verificationStatus) {
      case VerificationStatus.approved:
        return 'Your account has been verified and approved.';
      case VerificationStatus.pending:
        return 'Your documents are being reviewed. This usually takes 2-3 business days.';
      case VerificationStatus.rejected:
        return 'Your verification was rejected. Please contact support for more information.';
      case VerificationStatus.notSubmitted:
        return 'Upload your verification documents to become a verified landlord.';
    }
  }

  void _uploadVerificationDocuments() {
    _showSnackBar('Document upload feature coming soon!');
  }

  Future<bool?> _showUnsavedChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Do you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('Password change feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text('Two-factor authentication setup coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _downloadUserData() {
    _showSnackBar('Data download feature coming soon!');
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Account deletion feature coming soon!');
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
