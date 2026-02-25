import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  static const String routePath = '/profile';
  static const String routeName = 'profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // TODO: Replace with actual user profile from Cubit/Repository
  // These are placeholder values - user should configure them
  String _userName = '';
  String _companyName = '';
  String _businessAddress = '';
  String _taxId = '';
  String _currency = 'INR';
  String _themeMode = 'light';

  bool get _isProfileSetup => _userName.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildProfileSection(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('BUSINESS DETAILS'),
                    const SizedBox(height: 12),
                    _buildBusinessDetailsCard(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('APP SETTINGS'),
                    const SizedBox(height: 12),
                    _buildAppSettingsCard(),
                    const SizedBox(height: 24),
                    _buildDataManagementCard(),
                    const SizedBox(height: 16),
                    _buildVersionInfo(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      color: AppColors.background,
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Profile & Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Column(
        children: [
          // Avatar with edit button
          GestureDetector(
            onTap: _showEditProfileDialog,
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 3),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Name
          if (_isProfileSetup) ...[
            Text(
              _userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            if (_companyName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _companyName,
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
              ),
            ],
          ] else ...[
            const Text(
              'Set Up Your Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to add your business details',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 12),
          // Free plan badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'FREE PLAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildBusinessDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.primary,
            title: 'Business Address',
            subtitle: _businessAddress.isEmpty ? 'Not set' : _businessAddress,
            onTap: () => _showEditBusinessAddressDialog(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.primary,
            title: 'Tax ID / VAT',
            subtitle: _taxId.isEmpty ? 'Not set' : _taxId,
            onTap: () => _showEditTaxIdDialog(),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.payments_outlined,
            iconColor: AppColors.primary,
            title: 'Default Currency',
            subtitle: _getCurrencyDisplay(),
            onTap: () => _showCurrencyPicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            iconColor: Colors.grey.shade700,
            title: 'Notifications',
            subtitle: 'Coming soon',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            iconColor: Colors.grey.shade700,
            title: 'Appearance',
            subtitle: 'Light / Dark / Auto',
            trailing: Text(
              _themeMode[0].toUpperCase() + _themeMode.substring(1),
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            onTap: () => _showThemePicker(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.sync_outlined,
            iconColor: AppColors.primary,
            title: 'Sync Data',
            subtitle: 'Sync with cloud (coming soon)',
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.delete_outline,
            iconColor: AppColors.danger,
            title: 'Clear All Data',
            subtitle: 'Delete all invoices and clients',
            onTap: () => _showClearDataDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[trailing, const SizedBox(width: 8)],
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Text(
        'BILLZO v1.0.0',
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _getCurrencyDisplay() {
    final currencies = {
      'INR': 'INR (₹) - Indian Rupee',
      'USD': 'USD (\$) - US Dollar',
      'EUR': 'EUR (€) - Euro',
      'GBP': 'GBP (£) - British Pound',
    };
    return currencies[_currency] ?? _currency;
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final companyController = TextEditingController(text: _companyName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                hintText: 'e.g., John Doe',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                hintText: 'e.g., Acme Inc.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text.trim();
                _companyName = companyController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditBusinessAddressDialog() {
    final controller = TextEditingController(text: _businessAddress);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business Address'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '123 Main St, City, Country',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _businessAddress = controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditTaxIdDialog() {
    final controller = TextEditingController(text: _taxId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tax ID / VAT'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g., US-123456789'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _taxId = controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _buildCurrencyOption('INR', 'Indian Rupee', '₹'),
            _buildCurrencyOption('USD', 'US Dollar', '\$'),
            _buildCurrencyOption('EUR', 'Euro', '€'),
            _buildCurrencyOption('GBP', 'British Pound', '£'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String code, String name, String symbol) {
    final isSelected = _currency == code;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.grey.shade100,
        child: Text(
          symbol,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
      title: Text('$code - $name'),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() => _currency = code);
        Navigator.pop(context);
      },
    );
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _buildThemeOption('light', 'Light', Icons.light_mode_outlined),
            _buildThemeOption('dark', 'Dark', Icons.dark_mode_outlined),
            _buildThemeOption(
              'auto',
              'System',
              Icons.settings_suggest_outlined,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String mode, String label, IconData icon) {
    final isSelected = _themeMode == mode;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() => _themeMode = mode);
        Navigator.pop(context);
        // TODO: Actually apply theme change
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your invoices and clients. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement clear all data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feature coming soon')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
