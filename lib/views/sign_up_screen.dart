import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'landlord_approval_status_screen.dart';
import '../models/user_types.dart';
import '../services/navigation_service.dart';

class SignUpScreen extends StatefulWidget {
  final UserType userType;

  const SignUpScreen({super.key, this.userType = UserType.tenant});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF2C3E50),
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title with user type
              Row(
                children: [
                  Text(
                    widget.userType == UserType.landlord
                        ? "Create Landlord Account"
                        : "Create your account",
                    style: const TextStyle(
                      fontSize: 28,
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
                      color: widget.userType == UserType.landlord
                          ? const Color(0xFF7CB342).withValues(alpha: 0.1)
                          : const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.userType == UserType.landlord
                            ? const Color(0xFF7CB342)
                            : const Color(0xFF2196F3),
                      ),
                    ),
                    child: Text(
                      widget.userType == UserType.landlord
                          ? 'Landlord'
                          : 'Tenant',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.userType == UserType.landlord
                            ? const Color(0xFF7CB342)
                            : const Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                widget.userType == UserType.landlord
                    ? "Create your landlord account to list properties"
                    : "Please fill in the form to continue",
                style: const TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
              ),

              if (widget.userType == UserType.landlord) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF9800)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFFFF9800),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Landlord accounts require admin approval before you can list properties.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Full name field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
                ),
                child: TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Email field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Terms of service and Show password row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Terms of service
                  GestureDetector(
                    onTap: () {
                      // Handle terms of service
                      print('Terms of service pressed');
                    },
                    child: const Text(
                      'Terms of service',
                      style: TextStyle(
                        color: Color(0xFF7CB342),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Show password
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Text(
                      _obscurePassword ? 'Show password' : 'Hide password',
                      style: const TextStyle(
                        color: Color(0xFF7CB342),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _handleRegistration();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CB342),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    // Basic validation
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    // Email validation
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    // Password validation
    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    // Create user session
    final userSession = UserSession(
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _fullNameController.text,
      email: _emailController.text,
      userType: widget.userType,
      approvalStatus: widget.userType == UserType.landlord
          ? ApprovalStatus.pending
          : ApprovalStatus.approved,
      verificationStatus: widget.userType == UserType.landlord
          ? VerificationStatus.notSubmitted
          : VerificationStatus.approved,
      lastLogin: DateTime.now(),
    );

    // Navigate based on user type
    if (widget.userType == UserType.landlord) {
      // Landlords go to approval status screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LandlordApprovalStatusScreen(
            status: ApprovalStatus.pending,
            submissionDate: '2024-01-15',
          ),
        ),
      );
    } else {
      // Tenants go directly to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }

    _showSnackBar(
      widget.userType == UserType.landlord
          ? 'Landlord account created! Awaiting approval.'
          : 'Account created successfully!',
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
