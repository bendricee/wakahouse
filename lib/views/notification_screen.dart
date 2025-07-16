import 'package:flutter/material.dart';
import 'message_screen.dart';
import '../widgets/delete_confirmation_dialog.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedTab = 'Notification';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and delete icon - same color as screen
            Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF2C3E50),
                        size: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Section - rounded rectangle with gray background
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      'Notification',
                      selectedTab == 'Notification',
                    ),
                  ),
                  Expanded(
                    child: _buildTab('Messages', selectedTab == 'Messages'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips - only show for Notification tab
            if (selectedTab == 'Notification') ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('All', selectedFilter == 'All'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Review', selectedFilter == 'Review'),
                    const SizedBox(width: 12),
                    _buildFilterChip('Sold', selectedFilter == 'Sold'),
                    const SizedBox(width: 12),
                    _buildFilterChip('House', selectedFilter == 'House'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else
              const SizedBox(height: 8),

            // Content based on selected tab
            Expanded(
              child: selectedTab == 'Notification'
                  ? _buildNotificationContent()
                  : _buildMessagesContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today Section
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          _buildNotificationItem(
            'Emmett Perry',
            'Just messaged you. Check the message in message tab.',
            '10 mins ago',
            'assets/images/splash_image.webp',
            null,
          ),

          _buildNotificationItem(
            'Geraldo',
            'Just giving 5 Star review on your listing Fairview Apartment',
            '30 mins ago',
            'assets/images/splash_image.webp',
            'assets/images/splash_image.webp',
          ),

          _buildNotificationItem(
            'Walter Lindsey',
            'Just buy your listing Schoolview House',
            '1 hours ago',
            'assets/images/splash_image.webp',
            'assets/images/splash_image.webp',
          ),

          const SizedBox(height: 32),

          // Older notifications Section
          const Text(
            'Older notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          _buildNotificationItem(
            'Velma Cole',
            'Just favourited your listing Schoolview House',
            '2 days ago',
            'assets/images/splash_image.webp',
            'assets/images/splash_image.webp',
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMessagesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All chats Section
          const Text(
            'All chats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),

          _buildChatItem(
            'Milano',
            'tempor incididunt ut labore et dolore',
            '2m',
            'assets/images/splash_image.webp',
            isOnline: true,
          ),

          _buildChatItem(
            'Samuel Ella',
            'Lorem ipsum dolor sit amet',
            '5m',
            'assets/images/splash_image.webp',
            isOnline: false,
          ),

          _buildChatItem(
            'Emmet Perry',
            'Excepteur sint occaecat cupidatat non',
            '10m',
            'assets/images/splash_image.webp',
            isOnline: false,
          ),

          _buildChatItem(
            'Walter Lindsey',
            'Quis nostrud exercitation ullamco',
            '1h',
            'assets/images/splash_image.webp',
            isOnline: false,
          ),

          _buildChatItem(
            'Velma Cole',
            'Excepteur sint occaecat cupidatat non',
            '2h',
            'assets/images/splash_image.webp',
            isOnline: false,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
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
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF2C3E50)
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF34495E) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF34495E)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(
    String name,
    String lastMessage,
    String time,
    String avatarPath, {
    bool isOnline = false,
  }) {
    return Dismissible(
      key: Key('chat-$name-$time-${DateTime.now().millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.3},
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF34495E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (direction) async {
        bool? shouldDelete = await DeleteConfirmationDialog.show(
          context: context,
          title: 'Delete Chat?',
          message:
              'Are you sure you want to delete your chat with $name? This action cannot be undone.',
          itemName: name,
          onDelete: () {
            // This will be called when user confirms deletion
          },
        );

        if (shouldDelete == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chat with $name deleted'),
              backgroundColor: const Color(0xFF34495E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        return shouldDelete ?? false;
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                contactName: name,
                contactImage: avatarPath,
                isOnline: isOnline,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar with online indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String name,
    String message,
    String time,
    String avatarPath,
    String? propertyImagePath,
  ) {
    return Dismissible(
      key: Key(
        'notification-$name-$time-${DateTime.now().millisecondsSinceEpoch}',
      ),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.3},
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF34495E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (direction) async {
        bool? shouldDelete = await DeleteConfirmationDialog.show(
          context: context,
          title: 'Delete Notification?',
          message:
              'Are you sure you want to delete this notification from $name? This action cannot be undone.',
          itemName: name,
          onDelete: () {
            // This will be called when user confirms deletion
          },
        );

        if (shouldDelete == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name notification deleted'),
              backgroundColor: const Color(0xFF34495E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        return shouldDelete ?? false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(radius: 22, backgroundImage: AssetImage(avatarPath)),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            // Property Image (if available)
            if (propertyImagePath != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  propertyImagePath,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
