import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  bool _isLoading = false;
  
  // User profile data
  String _userName = 'Ethan Carter';
  String _userEmail = 'ethancarter@email.com';
  String _userPhone = '+1 (555) 123-4567';
  String _userGender = 'Male';
  DateTime _userDOB = DateTime(1990, 1, 15);
  String _userAddress = '123 Main St, New York, NY';
  String _accountId = 'USR-789456';
  bool _isVerified = true;
  String _lastLogin = 'Today, 10:30 AM • iPhone 13';
  bool _is2FAEnabled = false;
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'English';
  bool _publicProfile = true;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final List<OrderHistoryItem> _orders = [
    OrderHistoryItem(
      orderNumber: '#12345',
      items: 2,
      price: 45.00,
      status: 'Delivered',
      statusColor: AppColors.freshGreen,
    ),
    OrderHistoryItem(
      orderNumber: '#67890',
      items: 3,
      price: 60.00,
      status: 'Pending',
      statusColor: Colors.orange,
    ),
    OrderHistoryItem(
      orderNumber: '#11223',
      items: 1,
      price: 20.00,
      status: 'Cancelled',
      statusColor: AppColors.primaryRed,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Simulate loading user data from API/Database
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      // In production, load user data from your backend/local storage
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to load profile data');
      }
    }
  }

  // Pull-to-refresh functionality
  Future<void> _refreshProfile() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await _loadUserData();
      if (mounted) {
        _showSuccessSnackBar('Profile refreshed successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to refresh profile');
      }
    }
  }

  // Pick image with error handling
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        _showSuccessSnackBar('Profile picture updated successfully');
        // In production: Upload to server
        // await _uploadProfileImage(_profileImage!);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  // Show image source selection dialog
  void _showImageSourceDialog() {
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
              'Choose Profile Picture',
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
                _pickImage(ImageSource.camera);
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
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.delete, color: AppColors.primaryRed),
                ),
                title: const Text('Remove Picture'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _profileImage = null;
                  });
                  _showSuccessSnackBar('Profile picture removed');
                },
              ),
          ],
        ),
      ),
    );
  }

  // Enhanced edit profile dialog with validation
  void _showEditProfileDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);
    final addressController = TextEditingController(text: _userAddress);
    String selectedGender = _userGender;
    DateTime selectedDOB = _userDOB;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Edit Profile',
            style: AppTypography.h2.copyWith(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person, color: AppColors.primaryRed),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.email, color: AppColors.primaryRed),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.phone, color: AppColors.primaryRed),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\(\)\s]')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryRed),
                    ),
                    items: ['Male', 'Female', 'Other', 'Prefer not to say'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setDialogState(() {
                        selectedGender = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.cake, color: AppColors.primaryRed),
                      suffixIcon: Icon(Icons.calendar_today, color: AppColors.primaryRed),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('MMM dd, yyyy').format(selectedDOB),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDOB,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primaryRed,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setDialogState(() {
                          selectedDOB = date;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.location_on, color: AppColors.primaryRed),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.textGrey, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Account ID: $_accountId',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  
                  // Show loading indicator
                  _showLoadingDialog();
                  
                  try {
                    // Simulate API call
                    await Future.delayed(const Duration(seconds: 1));
                    
                    setState(() {
                      _userName = nameController.text.trim();
                      _userEmail = emailController.text.trim();
                      _userPhone = phoneController.text.trim();
                      _userGender = selectedGender;
                      _userDOB = selectedDOB;
                      _userAddress = addressController.text.trim();
                    });
                    
                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog
                      _showSuccessSnackBar('Profile updated successfully');
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog
                      _showErrorSnackBar('Failed to update profile');
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced change password dialog with validation
  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Change Password',
            style: AppTypography.h2.copyWith(fontSize: 20),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: obscureOld,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock, color: AppColors.primaryRed),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureOld ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureOld = !obscureOld;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryRed),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                      return 'Password must contain letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryRed),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Password must be at least 8 characters with letters and numbers',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  _showLoadingDialog();
                  
                  try {
                    // Simulate API call
                    await Future.delayed(const Duration(seconds: 1));
                    
                    if (mounted) {
                      Navigator.pop(context);
                      _showSuccessSnackBar('Password changed successfully');
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context);
                      _showErrorSnackBar('Failed to change password');
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }

  // Delete account confirmation
  void _showDeleteAccountDialog() {
    final TextEditingController confirmController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: AppTypography.h2.copyWith(fontSize: 20, color: AppColors.primaryRed),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text('• All your personal information'),
            const Text('• Order history'),
            const Text('• Saved preferences'),
            const Text('• Payment methods'),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                labelText: 'Type "DELETE" to confirm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (confirmController.text.trim().toUpperCase() == 'DELETE') {
                Navigator.pop(context);
                _showLoadingDialog();
                
                try {
                  await Future.delayed(const Duration(seconds: 2));
                  
                  if (mounted) {
                    Navigator.pop(context);
                    _showSuccessSnackBar('Account deletion initiated');
                    
                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    _showErrorSnackBar('Failed to delete account');
                  }
                }
              } else {
                _showErrorSnackBar('Please type DELETE to confirm');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  // Logout confirmation
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Perform logout with loading state
  Future<void> _performLogout() async {
    _showLoadingDialog();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar('Failed to logout');
      }
    }
  }

  // Toggle 2FA with loading state
  Future<void> _toggle2FA(bool value) async {
    _showLoadingDialog();
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      setState(() {
        _is2FAEnabled = value;
      });
      
      if (mounted) {
        Navigator.pop(context);
        _showSuccessSnackBar('2FA ${value ? 'enabled' : 'disabled'} successfully');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorSnackBar('Failed to update 2FA settings');
      }
    }
  }

  // Toggle dark mode
  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _darkMode = value;
    });
    _showSuccessSnackBar('Dark mode ${value ? 'enabled' : 'disabled'}');
    // In production: Save to shared preferences
  }

  // Toggle notifications
  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    _showSuccessSnackBar('Notifications ${value ? 'enabled' : 'disabled'}');
    // In production: Update notification settings
  }

  // Toggle public profile
  Future<void> _togglePublicProfile(bool value) async {
    setState(() {
      _publicProfile = value;
    });
    _showSuccessSnackBar('Public profile ${value ? 'enabled' : 'disabled'}');
    // In production: Update privacy settings on server
  }

  // Language selection
  void _showLanguageSelection() {
    final languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'Spanish', 'code': 'es'},
      {'name': 'French', 'code': 'fr'},
      {'name': 'German', 'code': 'de'},
      {'name': 'Chinese', 'code': 'zh'},
      {'name': 'Japanese', 'code': 'ja'},
      {'name': 'Korean', 'code': 'ko'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return RadioListTile<String>(
                title: Text(lang['name']!),
                value: lang['name']!,
                groupValue: _language,
                activeColor: AppColors.primaryRed,
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                  Navigator.pop(context);
                  _showSuccessSnackBar('Language changed to ${lang['name']}');
                  // In production: Update language preference and reload app
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper methods for showing dialogs and snackbars
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primaryRed),
              const SizedBox(height: 16),
              const Text('Please wait...'),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.freshGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          'My Account',
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: _showEditProfileDialog,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primaryRed,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header with Gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryRed.withOpacity(0.8),
                      AppColors.primaryRed.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.lightGray,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.textGrey,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: _showImageSourceDialog,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _userName,
                                style: AppTypography.h2.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (_isVerified)
                                Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 20,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userEmail,
                            style: AppTypography.caption.copyWith(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Summary Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem(
                            title: 'Total Orders',
                            value: '${_orders.length}',
                          ),
                          _buildSummaryItem(
                            title: 'Pending',
                            value: '${_orders.where((o) => o.status == 'Pending').length}',
                          ),
                          _buildSummaryItem(
                            title: 'Delivered',
                            value: '${_orders.where((o) => o.status == 'Delivered').length}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Account & Security Section
              _buildSectionHeader('Account & Security'),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: _showChangePasswordDialog,
              ),
              _buildMenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Account Verification',
                subtitle: _isVerified ? 'Verified ✅' : 'Unverified ⚠️',
                onTap: () {
                  _showSuccessSnackBar(_isVerified ? 'Account is verified' : 'Verification required');
                },
              ),
              _buildMenuItem(
                icon: Icons.login_outlined,
                title: 'Last Login',
                subtitle: _lastLogin,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Login History', style: AppTypography.h2.copyWith(fontSize: 18)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Login: $_lastLogin'),
                          const SizedBox(height: 8),
                          Text('Previous: Yesterday, 3:45 PM • iPhone 13'),
                          const SizedBox(height: 8),
                          Text('Oct 25, 8:20 AM • iPhone 13'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildSwitchMenuItem(
                icon: Icons.security_outlined,
                title: 'Two-Factor Authentication',
                subtitle: 'Add extra security to your account',
                value: _is2FAEnabled,
                onChanged: _toggle2FA,
              ),
              _buildMenuItem(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: _showDeleteAccountDialog,
                isDestructive: true,
              ),
              
              const SizedBox(height: 24),

              // Preferences Section
              _buildSectionHeader('Preferences'),
              _buildSwitchMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark theme',
                value: _darkMode,
                onChanged: _toggleDarkMode,
              ),
              _buildSwitchMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage app notifications',
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
              ),
              _buildMenuItem(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: _language,
                onTap: _showLanguageSelection,
              ),
              _buildSwitchMenuItem(
                icon: Icons.public_outlined,
                title: 'Public Profile',
                subtitle: 'Show my profile publicly',
                value: _publicProfile,
                onChanged: _togglePublicProfile,
              ),
              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Default Payment Method',
                subtitle: '•••• •••• •••• 1234',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.checkoutPayment);
                },
              ),
              
              const SizedBox(height: 24),

              // Activity & History Section
              _buildSectionHeader('Activity & History'),
              _buildMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: '${_orders.length} orders',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.orderHistory);
                },
              ),
              _buildMenuItem(
                icon: Icons.favorite_border_outlined,
                title: 'Wishlist',
                subtitle: '5 items',
                onTap: () {
                  _showSuccessSnackBar('Opening wishlist...');
                  // Navigator.pushNamed(context, AppRoutes.wishlist);
                },
              ),
              _buildMenuItem(
                icon: Icons.history_outlined,
                title: 'Recently Viewed',
                subtitle: '12 items',
                onTap: () {
                  _showSuccessSnackBar('Opening recently viewed...');
                  // Navigator.pushNamed(context, AppRoutes.recentlyViewed);
                },
              ),
              _buildMenuItem(
                icon: Icons.support_agent_outlined,
                title: 'Support Requests',
                subtitle: '2 open tickets',
                onTap: () {
                  _showSuccessSnackBar('Opening support tickets...');
                  // Navigator.pushNamed(context, AppRoutes.support);
                },
              ),
              
              const SizedBox(height: 24),

              // Support & Account Management Section
              _buildSectionHeader('Support & Account Management'),
              _buildMenuItem(
                icon: Icons.report_problem_outlined,
                title: 'Report an Issue',
                subtitle: 'Help us improve our service',
                onTap: () {
                  _showSuccessSnackBar('Opening issue reporter...');
                  // Navigator.pushNamed(context, AppRoutes.reportIssue);
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'FAQs and support articles',
                onTap: () {
                  _showSuccessSnackBar('Opening help center...');
                  // Navigator.pushNamed(context, AppRoutes.helpCenter);
                },
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Legal terms of service',
                onTap: () {
                  _showSuccessSnackBar('Opening terms & conditions...');
                  // Navigator.pushNamed(context, AppRoutes.terms);
                },
              ),
              _buildMenuItem(
                icon: Icons.security_outlined,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () {
                  _showSuccessSnackBar('Opening privacy policy...');
                  // Navigator.pushNamed(context, AppRoutes.privacy);
                },
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Version 1.0.0 • Developed by Butchee',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'MyApp',
                    applicationVersion: '1.0.0',
                    applicationIcon: Icon(Icons.shopping_bag, color: AppColors.primaryRed, size: 48),
                    children: [
                      const Text('Developed by Butchee'),
                      const SizedBox(height: 8),
                      const Text('© 2025 All rights reserved'),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 24),

              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == _selectedIndex) return;
          
          setState(() => _selectedIndex = index);

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.products);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.orderHistory);
              break;
            case 3:
              // Already on profile page
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: AppTypography.caption.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.caption.copyWith(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: AppTypography.h2.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSummaryItem({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h2.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTypography.caption.copyWith(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.primaryRed.withOpacity(0.1)
                : AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.primaryRed : AppColors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDestructive ? AppColors.primaryRed : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              )
            : null,
        trailing: Icon(Icons.chevron_right, color: AppColors.textGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => onChanged(!value),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryRed,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              )
            : null,
        trailing: Switch(
          value: value,
          onChanged: (val) => onChanged(val),
          activeColor: AppColors.primaryRed,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class OrderHistoryItem {
  final String orderNumber;
  final int items;
  final double price;
  final String status;
  final Color statusColor;

  OrderHistoryItem({
    required this.orderNumber,
    required this.items,
    required this.price,
    required this.status,
    required this.statusColor,
  });
}