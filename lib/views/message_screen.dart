import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_call_screen.dart';

enum MessageType { text, image, file, property, audio, video }

enum MessageStatus { sending, sent, delivered, read }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final bool isFromMe;
  final DateTime timestamp;
  final MessageStatus status;
  final String? fileName;
  final String? fileSize;
  final String? imageUrl;

  Message({
    required this.id,
    required this.content,
    required this.type,
    required this.isFromMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.fileName,
    this.fileSize,
    this.imageUrl,
  });
}

class MessageScreen extends StatefulWidget {
  final String contactName;
  final String contactImage;
  final bool isOnline;

  const MessageScreen({
    super.key,
    required this.contactName,
    required this.contactImage,
    required this.isOnline,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();

  bool _isTyping = false;
  bool _showAttachmentOptions = false;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  List<Message> messages = [
    Message(
      id: '1',
      content:
          'Hello! I\'m interested in the Villa Moderne Yaoundé property. Could you provide more details?',
      type: MessageType.text,
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: MessageStatus.read,
    ),
    Message(
      id: '2',
      content:
          'Hi! I\'d be happy to help you with that property. It\'s a beautiful 3-bedroom villa with modern amenities.',
      type: MessageType.text,
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      status: MessageStatus.read,
    ),
    Message(
      id: '3',
      content: 'Here are some additional photos of the property:',
      type: MessageType.text,
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      status: MessageStatus.read,
    ),
    Message(
      id: '4',
      content: 'property_image_1.jpg',
      type: MessageType.image,
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      status: MessageStatus.read,
      imageUrl: 'assets/images/laurels_villa_favorite.jpg',
    ),
    Message(
      id: '5',
      content: 'That looks amazing! What\'s the monthly rent?',
      type: MessageType.text,
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      status: MessageStatus.read,
    ),
    Message(
      id: '6',
      content:
          'The monthly rent is 200,000 FCFA. Would you like to schedule a viewing?',
      type: MessageType.text,
      isFromMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
      status: MessageStatus.read,
    ),
    Message(
      id: '7',
      content: 'Yes, I\'d love to schedule a viewing. When are you available?',
      type: MessageType.text,
      isFromMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      status: MessageStatus.delivered,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Simulate typing indicator
    _simulateTyping();

    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _simulateTyping() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
        _typingAnimationController.repeat();

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
            _typingAnimationController.stop();
          }
        });
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _messageController.text.trim(),
        type: MessageType.text,
        isFromMe: true,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      setState(() {
        messages.add(newMessage);
        _messageController.clear();
      });

      // Simulate message status updates
      _updateMessageStatus(newMessage.id);
      _scrollToBottom();

      // Simulate landlord response
      _simulateLandlordResponse();
    }
  }

  void _updateMessageStatus(String messageId) {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final index = messages.indexWhere((m) => m.id == messageId);
          if (index != -1) {
            messages[index] = Message(
              id: messages[index].id,
              content: messages[index].content,
              type: messages[index].type,
              isFromMe: messages[index].isFromMe,
              timestamp: messages[index].timestamp,
              status: MessageStatus.sent,
            );
          }
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          final index = messages.indexWhere((m) => m.id == messageId);
          if (index != -1) {
            messages[index] = Message(
              id: messages[index].id,
              content: messages[index].content,
              type: messages[index].type,
              isFromMe: messages[index].isFromMe,
              timestamp: messages[index].timestamp,
              status: MessageStatus.delivered,
            );
          }
        });
      }
    });
  }

  void _simulateLandlordResponse() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final responses = [
          'I\'m available tomorrow afternoon or this weekend. Which works better for you?',
          'Great! I can show you the property tomorrow at 2 PM. Does that work?',
          'Perfect! I\'ll send you the address and my contact details.',
        ];

        final response = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: responses[DateTime.now().millisecond % responses.length],
          type: MessageType.text,
          isFromMe: false,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
        );

        setState(() {
          messages.add(response);
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                final message = messages[index];
                final showDateSeparator =
                    index == 0 ||
                    !_isSameDay(
                      message.timestamp,
                      messages[index - 1].timestamp,
                    );

                return Column(
                  children: [
                    if (showDateSeparator) ...[
                      _buildDateSeparator(_formatDate(message.timestamp)),
                      const SizedBox(height: 16),
                    ],
                    _buildMessageBubble(message),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
          if (_showAttachmentOptions) _buildAttachmentOptions(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            // Back button - matching notification screen style
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
            const SizedBox(width: 12),
            // User avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(widget.contactImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            // Call button - matching notification screen style
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallScreen(
                      contactName: widget.contactName,
                      contactImage: widget.contactImage,
                    ),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.call,
                  color: Color(0xFF2C3E50),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF95A5A6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCardMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            Container(
              height: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_image.webp'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Favorite icon
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  // Property type badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Apartment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Property details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sky Dandelions Apartment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Rating and location
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFB800),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF7F8C8D),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Jakarta, Indonesia',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.check, color: Color(0xFF7CB342), size: 16),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF34495E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Color(0xFF95A5A6)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment Button
          GestureDetector(
            onTap: () {
              setState(() {
                _showAttachmentOptions = !_showAttachmentOptions;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _showAttachmentOptions
                    ? const Color(0xFF7CB342).withValues(alpha: 0.1)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _showAttachmentOptions ? Icons.close : Icons.add,
                color: _showAttachmentOptions
                    ? const Color(0xFF7CB342)
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Message Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: _messageFocusNode.hasFocus
                      ? const Color(0xFF7CB342)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onChanged: (text) {
                  setState(() {}); // Rebuild to update send button state
                },
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _messageController.text.trim().isNotEmpty
                    ? const Color(0xFF7CB342)
                    : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: _messageController.text.trim().isNotEmpty
                    ? Colors.white
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    switch (message.type) {
      case MessageType.text:
        return _buildTextMessage(message);
      case MessageType.image:
        return _buildImageMessage(message);
      case MessageType.file:
        return _buildFileMessage(message);
      case MessageType.property:
        return _buildPropertyMessage(message);
      default:
        return _buildTextMessage(message);
    }
  }

  Widget _buildTextMessage(Message message) {
    return Align(
      alignment: message.isFromMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: message.isFromMe ? 50 : 0,
          right: message.isFromMe ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: message.isFromMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromMe
                    ? const Color(0xFF7CB342)
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isFromMe ? 16 : 4),
                  bottomRight: Radius.circular(message.isFromMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: message.isFromMe
                      ? Colors.white
                      : const Color(0xFF2D3748),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (message.isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _getStatusIcon(message.status),
                    size: 12,
                    color: _getStatusColor(message.status),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageMessage(Message message) {
    return Align(
      alignment: message.isFromMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: message.isFromMe ? 50 : 0,
          right: message.isFromMe ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: message.isFromMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.asset(
                      message.imageUrl ?? 'assets/images/placeholder.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (message.isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _getStatusIcon(message.status),
                    size: 12,
                    color: _getStatusColor(message.status),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessage(Message message) {
    return Align(
      alignment: message.isFromMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: message.isFromMe ? 50 : 0,
          right: message.isFromMe ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: message.isFromMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isFromMe
                    ? const Color(0xFF7CB342)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: message.isFromMe
                          ? Colors.white.withValues(alpha: 0.2)
                          : const Color(0xFF7CB342).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description,
                      color: message.isFromMe
                          ? Colors.white
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
                          message.fileName ?? 'Document',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: message.isFromMe
                                ? Colors.white
                                : const Color(0xFF2D3748),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message.fileSize ?? '1.2 MB',
                          style: TextStyle(
                            fontSize: 12,
                            color: message.isFromMe
                                ? Colors.white.withValues(alpha: 0.8)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.download,
                    color: message.isFromMe
                        ? Colors.white
                        : const Color(0xFF7CB342),
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                if (message.isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    _getStatusIcon(message.status),
                    size: 12,
                    color: _getStatusColor(message.status),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyMessage(Message message) {
    return _buildPropertyCardMessage();
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _typingAnimation,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    final delay = index * 0.2;
    final animationValue = (_typingAnimation.value - delay).clamp(0.0, 1.0);
    final scale =
        0.5 + (0.5 * (1 - (animationValue - 0.5).abs() * 2).clamp(0.0, 1.0));

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF9CA3AF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.photo_camera,
            label: 'Camera',
            color: const Color(0xFF7CB342),
            onTap: () => _handleAttachment('camera'),
          ),
          _buildAttachmentOption(
            icon: Icons.photo_library,
            label: 'Gallery',
            color: const Color(0xFF2196F3),
            onTap: () => _handleAttachment('gallery'),
          ),
          _buildAttachmentOption(
            icon: Icons.description,
            label: 'Document',
            color: const Color(0xFFFF9800),
            onTap: () => _handleAttachment('document'),
          ),
          _buildAttachmentOption(
            icon: Icons.location_on,
            label: 'Location',
            color: const Color(0xFFE91E63),
            onTap: () => _handleAttachment('location'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAttachment(String type) {
    setState(() {
      _showAttachmentOptions = false;
    });

    // Simulate file selection and sending
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Message newMessage;

        switch (type) {
          case 'camera':
          case 'gallery':
            newMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg',
              type: MessageType.image,
              isFromMe: true,
              timestamp: DateTime.now(),
              status: MessageStatus.sending,
              imageUrl: 'assets/images/laurels_villa_favorite.jpg',
            );
            break;
          case 'document':
            newMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: 'Property_Contract.pdf',
              type: MessageType.file,
              isFromMe: true,
              timestamp: DateTime.now(),
              status: MessageStatus.sending,
              fileName: 'Property_Contract.pdf',
              fileSize: '2.4 MB',
            );
            break;
          case 'location':
            newMessage = Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: 'Shared location: Villa Moderne Yaoundé',
              type: MessageType.text,
              isFromMe: true,
              timestamp: DateTime.now(),
              status: MessageStatus.sending,
            );
            break;
          default:
            return;
        }

        setState(() {
          messages.add(newMessage);
        });

        _updateMessageStatus(newMessage.id);
        _scrollToBottom();
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
    }
  }

  Color _getStatusColor(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return const Color(0xFF9CA3AF);
      case MessageStatus.sent:
        return const Color(0xFF9CA3AF);
      case MessageStatus.delivered:
        return const Color(0xFF9CA3AF);
      case MessageStatus.read:
        return const Color(0xFF7CB342);
    }
  }
}
