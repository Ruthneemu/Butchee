import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  bool _isTyping = false;
  bool _isSupportOnline = true;
  
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! Welcome to Butchee Support. How can we assist you today?',
      isSupport: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'Hi, I have a question about my recent order.',
      isSupport: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      text: 'Sure! I\'d be happy to help. Please provide your order number so I can look into it for you.',
      isSupport: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  // Automated responses based on keywords
  final Map<String, List<String>> _autoResponses = {
    'order': [
      'I can help you with your order. Could you please provide your order number?',
      'Let me check your order details. Please share your order number.',
    ],
    'delivery': [
      'I can help track your delivery. What\'s your order number?',
      'Delivery times vary by location. Typically 30-45 minutes. What would you like to know?',
    ],
    'payment': [
      'For payment issues, please check your payment method. We accept credit cards, debit cards, and mobile payments.',
      'Is there a specific payment issue I can help you with?',
    ],
    'refund': [
      'I understand you need a refund. Let me help you with that. Could you tell me more about the issue?',
      'Refunds are typically processed within 5-7 business days. What order needs a refund?',
    ],
    'cancel': [
      'I can help you cancel your order. Please provide your order number.',
      'Orders can be cancelled within 5 minutes of placing. What\'s your order number?',
    ],
    'help': [
      'I\'m here to help! What do you need assistance with? Orders, delivery, payments, or refunds?',
    ],
    'thank': [
      'You\'re welcome! Is there anything else I can help you with?',
      'Happy to help! Let me know if you need anything else.',
    ],
  };

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    
    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessage,
          isSupport: false,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });

    _scrollToBottom();
    _simulateSupportResponse(userMessage);
  }

  void _simulateSupportResponse(String userMessage) {
    // Show typing indicator
    setState(() => _isTyping = true);

    // Simulate response delay
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      String response = _getAutomatedResponse(userMessage);

      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: response,
            isSupport: true,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollToBottom();
    });
  }

  String _getAutomatedResponse(String message) {
    final lowerMessage = message.toLowerCase();

    for (var entry in _autoResponses.entries) {
      if (lowerMessage.contains(entry.key)) {
        final responses = entry.value;
        return responses[DateTime.now().millisecond % responses.length];
      }
    }

    // Default response
    return 'Thank you for your message. A support agent will assist you shortly. Is there anything specific I can help you with? (Orders, Delivery, Payment, Refunds)';
  }

  Future<void> _pickImage() async {
    try {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attach Image',
                style: AppTypography.h2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.camera_alt, color: AppColors.primaryRed),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.photo_library, color: AppColors.primaryRed),
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.attach_file, color: AppColors.primaryRed),
                ),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument();
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      _showError('Failed to open attachment options');
    }
  }

  Future<void> _takePhoto(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Image attached',
              isSupport: false,
              timestamp: DateTime.now(),
              attachmentPath: photo.path,
              attachmentType: AttachmentType.image,
            ),
          );
        });
        _scrollToBottom();
        
        // Auto response for image
        _simulateSupportResponse('sent an image');
      }
    } catch (e) {
      _showError('Failed to pick image');
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        final file = result.files.first;
        setState(() {
          _messages.add(
            ChatMessage(
              text: file.name,
              isSupport: false,
              timestamp: DateTime.now(),
              attachmentPath: file.path,
              attachmentType: AttachmentType.document,
            ),
          );
        });
        _scrollToBottom();
        
        // Auto response for document
        _simulateSupportResponse('sent a document');
      }
    } catch (e) {
      _showError('Failed to pick document');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.copy, color: AppColors.primaryRed),
              title: const Text('Copy Message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),
            if (!message.isSupport)
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.primaryRed),
                title: const Text('Delete Message'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.remove(message);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.lightGray,
                  child: Icon(
                    Icons.support_agent,
                    size: 20,
                    color: AppColors.primaryRed,
                  ),
                ),
                if (_isSupportOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.freshGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butchee Support',
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _isTyping ? 'typing...' : (_isSupportOnline ? 'Online' : 'Offline'),
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: _isTyping 
                          ? AppColors.primaryRed 
                          : (_isSupportOnline ? AppColors.freshGreen : AppColors.textGrey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Chat Information',
                    style: AppTypography.h2.copyWith(fontSize: 18),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Status', _isSupportOnline ? 'Online' : 'Offline'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Messages', '${_messages.length}'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Response Time', 'Usually within 2 min'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: TextStyle(color: AppColors.primaryRed),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.info_outline, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.primaryRed.withOpacity(0.05),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primaryRed),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ask about: Orders, Delivery, Payment, Refunds',
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Attachment Button
                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.attach_file,
                      color: AppColors.primaryRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Text Input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppTypography.caption.copyWith(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textGrey,
          ),
        ),
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.lightGray,
            child: Icon(
              Icons.support_agent,
              size: 18,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -4 * (1 - (animValue * 2 - 1).abs())),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.textGrey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: message.isSupport
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isSupport)
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 40),
                child: Text(
                  'Butchee Support',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: message.isSupport
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.isSupport) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.lightGray,
                    child: Icon(
                      Icons.support_agent,
                      size: 18,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: message.isSupport
                          ? AppColors.lightGray.withOpacity(0.5)
                          : AppColors.primaryRed,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: message.isSupport
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                        bottomRight: message.isSupport
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.attachmentPath != null)
                          _buildAttachment(message),
                        Text(
                          message.text,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            color: message.isSupport
                                ? AppColors.textPrimary
                                : Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: message.isSupport
                                ? AppColors.textGrey
                                : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!message.isSupport) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryRed.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 18,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachment(ChatMessage message) {
    if (message.attachmentType == AttachmentType.image) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(message.attachmentPath!),
            width: 200,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (message.attachmentType == AttachmentType.document) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description,
                color: message.isSupport ? AppColors.primaryRed : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.text,
                  style: AppTypography.caption.copyWith(
                    color: message.isSupport ? AppColors.textPrimary : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

enum AttachmentType { image, document }

class ChatMessage {
  final String text;
  final bool isSupport;
  final DateTime timestamp;
  final String? attachmentPath;
  final AttachmentType? attachmentType;

  ChatMessage({
    required this.text,
    required this.isSupport,
    required this.timestamp,
    this.attachmentPath,
    this.attachmentType,
  });
}