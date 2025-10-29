import 'package:flutter/material.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/core/constants/typography.dart';

class Address {
  final String id;
  String name;
  String addressLine;
  String contact;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.addressLine,
    required this.contact,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'addressLine': addressLine,
    'contact': contact,
    'isDefault': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    name: json['name'],
    addressLine: json['addressLine'],
    contact: json['contact'],
    isDefault: json['isDefault'] ?? false,
  );
}

class MyAddressesPage extends StatefulWidget {
  const MyAddressesPage({super.key});

  @override
  State<MyAddressesPage> createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  List<Address> _addresses = [
    Address(
      id: '1',
      name: 'Ethan Carter',
      addressLine: '123 Maple Street, Apt 4B, Springfield',
      contact: '+1 (555) 123-4567',
      isDefault: true,
    ),
    Address(
      id: '2',
      name: 'Olivia Bennett',
      addressLine: '456 Oak Avenue, Unit 2A, Lakeside',
      contact: '+1 (555) 987-6543',
      isDefault: false,
    ),
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Replace with actual API call
      // final addresses = await AddressService.getAddresses();
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to load addresses: ${e.toString()}');
      }
    }
  }

  void _showAddAddressDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        onSave: (address) => _addAddress(address),
      ),
    );
  }

  void _showEditAddressDialog(Address address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (updatedAddress) => _updateAddress(updatedAddress),
      ),
    );
  }

  Future<void> _addAddress(Address address) async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // await AddressService.addAddress(address);
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _addresses.add(address);
          _isLoading = false;
        });
        _showSuccessSnackBar('Address added successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to add address: ${e.toString()}');
      }
    }
  }

  Future<void> _updateAddress(Address updatedAddress) async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // await AddressService.updateAddress(updatedAddress);
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
          if (index != -1) {
            _addresses[index] = updatedAddress;
          }
          _isLoading = false;
        });
        _showSuccessSnackBar('Address updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to update address: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteAddress(Address address) async {
    final confirmed = await _showDeleteConfirmation(address);
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // await AddressService.deleteAddress(address.id);
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _addresses.removeWhere((a) => a.id == address.id);
          
          // If deleted address was default and there are other addresses, set first as default
          if (address.isDefault && _addresses.isNotEmpty) {
            _addresses[0].isDefault = true;
          }
          
          _isLoading = false;
        });
        _showSuccessSnackBar('Address deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to delete address: ${e.toString()}');
      }
    }
  }

  Future<void> _setDefaultAddress(Address address) async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // await AddressService.setDefaultAddress(address.id);
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          for (var addr in _addresses) {
            addr.isDefault = addr.id == address.id;
          }
          _isLoading = false;
        });
        _showSuccessSnackBar('Default address updated');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Failed to update default address: ${e.toString()}');
      }
    }
  }

  Future<bool> _showDeleteConfirmation(Address address) async {
    if (address.isDefault && _addresses.length > 1) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Default Address?'),
          content: const Text(
            'This is your default address. If you delete it, the next address will be set as default.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryRed),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete "${address.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.freshGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Addresses',
          style: AppTypography.h2.copyWith(fontSize: 20),
        ),
      ),
      body: _isLoading && _addresses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    if (_isLoading)
                      const LinearProgressIndicator(minHeight: 2),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadAddresses,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _addresses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _AddressCard(
                              address: _addresses[index],
                              onEdit: () => _showEditAddressDialog(_addresses[index]),
                              onDelete: () => _deleteAddress(_addresses[index]),
                              onSetDefault: () => _setDefaultAddress(_addresses[index]),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _showAddAddressDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              disabledBackgroundColor: AppColors.textGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text('Add New Address', style: AppTypography.button),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 100,
              color: AppColors.textGrey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Addresses Yet',
              style: AppTypography.h2.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your delivery addresses to get started',
              style: AppTypography.body.copyWith(
                fontSize: 14,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddAddressDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: address.isDefault
            ? Border.all(color: AppColors.primaryRed, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      address.name,
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.textGrey),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                    case 'default':
                      onSetDefault();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Set as Default'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address.addressLine,
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 4),
              Text(
                address.contact,
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final Address? address;
  final Function(Address) onSave;

  const _AddressFormSheet({
    this.address,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _addressController = TextEditingController(text: widget.address?.addressLine ?? '');
    _contactController = TextEditingController(text: widget.address?.contact ?? '');
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an address';
    }
    if (value.trim().length < 10) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a contact number';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final address = Address(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        addressLine: _addressController.text.trim(),
        contact: _contactController.text.trim(),
        isDefault: _isDefault,
      );

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        widget.onSave(address);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.neutralGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isEditing ? 'Edit Address' : 'Add New Address',
                  style: AppTypography.h2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: _validateName,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address *',
                    hintText: 'Street, building, floor',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: _validateAddress,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number *',
                    hintText: '+1 (555) 123-4567',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: _validateContact,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() => _isDefault = value ?? false);
                  },
                  title: Text(
                    'Set as default address',
                    style: AppTypography.body.copyWith(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primaryRed,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      disabledBackgroundColor: AppColors.textGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Address' : 'Save Address',
                            style: AppTypography.button,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}