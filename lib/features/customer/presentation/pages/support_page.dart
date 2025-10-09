import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello, how can we assist you today?',
      isSupport: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      text: 'Hi, I have a question about my recent order.',
      isSupport: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      text: 'Sure, please provide your order number.',
      isSupport: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isSupport: false,
            timestamp: DateTime.now(),
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Customer Support',
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
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
            child: Row(
              children: [
                // Text Input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
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
                        fillColor: AppColors.lightGray.withOpacity(0.5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.attach_file,
                            color: AppColors.textGrey,
                            size: 20,
                          ),
                        ),
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Send Button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
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

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isSupport
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (message.isSupport)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Butchee Support',
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isSupport
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        : AppColors.freshGreen,
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
                  child: Text(
                    message.text,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      color: message.isSupport
                          ? AppColors.textPrimary
                          : Colors.white,
                      height: 1.4,
                    ),
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
    );
  }
}

class ChatMessage {
  final String text;
  final bool isSupport;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSupport,
    required this.timestamp,
  });
}