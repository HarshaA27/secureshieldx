import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../router/route_paths.dart';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const UserProfileScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _userName = 'Dr. Alex Vance';
  final String _email = 'alex.vance@secureshield.io';
  String _phone = '+91 98765 43210';
  String _emergencyContact = '+91 98123 99999 (Cyber Cell Emergency)';
  final String _alertLanguage = 'English (🇺🇸)';
  bool _biometricEnabled = true;

  void _showLogoutModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.logout_rounded, color: AppColors.riskCritical),
              SizedBox(width: 10),
              Text('Confirm Logout'),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out? Real-time active threat monitoring will pause until you log in again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.riskCritical,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.go(RoutePaths.login);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Profile & Identity',
        subtitle: 'Account Security • Pro Active Subscription',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.riskCritical),
            onPressed: _showLogoutModal,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Avatar Card
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primary.withAlpha(40),
                        child: const Icon(Icons.person_rounded, size: 48, color: AppColors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.riskSafe,
                        ),
                        child: const Icon(Icons.verified_rounded, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    _email,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: const Text(
                      '🛡️ PRO TIER • ACTIVE SHIELD GUARDIAN',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Info List
            CustomCard(
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.phone_android_rounded,
                    title: 'Phone Number',
                    value: _phone,
                  ),
                  const Divider(),
                  _buildProfileTile(
                    icon: Icons.contact_phone_rounded,
                    title: 'Emergency Fraud Hotline Contact',
                    value: _emergencyContact,
                  ),
                  const Divider(),
                  _buildProfileTile(
                    icon: Icons.language_rounded,
                    title: 'Default Alert Language',
                    value: _alertLanguage,
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Biometric Fingerprint / FaceID Unlock', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Require biometrics to open administrative tools', style: TextStyle(fontSize: 11)),
                    value: _biometricEnabled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _biometricEnabled = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Edit Profile & Contacts',
                    variant: CustomButtonVariant.outline,
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    onPressed: () async {
                      final updated = await showModalBottomSheet<Map<String, String>>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => _EditProfileModal(
                          currentName: _userName,
                          currentPhone: _phone,
                          currentEmergency: _emergencyContact,
                        ),
                      );
                      if (updated != null) {
                        setState(() {
                          _userName = updated['name'] ?? _userName;
                          _phone = updated['phone'] ?? _phone;
                          _emergencyContact = updated['emergency'] ?? _emergencyContact;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            CustomButton(
              text: 'Log Out of SecureShield X',
              variant: CustomButtonVariant.critical,
              icon: const Icon(Icons.logout_rounded, size: 18),
              onPressed: _showLogoutModal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileModal extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final String currentEmergency;

  const _EditProfileModal({
    required this.currentName,
    required this.currentPhone,
    required this.currentEmergency,
  });

  @override
  State<_EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<_EditProfileModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emergencyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentName);
    _phoneCtrl = TextEditingController(text: widget.currentPhone);
    _emergencyCtrl = TextEditingController(text: widget.currentEmergency);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emergencyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit User Profile & Contacts', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emergencyCtrl,
            decoration: const InputDecoration(labelText: 'Emergency Contact Hotline', prefixIcon: Icon(Icons.contact_phone)),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Save Changes',
            variant: CustomButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop({
                'name': _nameCtrl.text,
                'phone': _phoneCtrl.text,
                'emergency': _emergencyCtrl.text,
              });
            },
          ),
        ],
      ),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SubscriptionScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Pro Subscription', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                children: const [
                  Icon(Icons.workspace_premium_rounded, size: 48, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text('SecureShield Pro Tier Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Unlimited AI Risk Explanations • Multi-Lingual Cyber Complaints • 24/7 Threat Protection', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CloudSyncScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const CloudSyncScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cloud Intelligence Sync', showBackButton: true),
      body: const Center(child: Text('Cloud Signatures Synchronized (14.2M Hashes)')),
    );
  }
}

class ConnectedDevicesScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ConnectedDevicesScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Multi-Device Shield Manager', showBackButton: true),
      body: const Center(child: Text('Connected Devices: 2 (Pixel 8 Pro, Galaxy Tab S9)')),
    );
  }
}
