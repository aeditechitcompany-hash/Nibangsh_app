import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../const/resources.dart';
import '../../../../common/util/app_colors.dart';
import '../../../../common/util/app_route.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController(), permanent: true);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Preferences'),
                const SizedBox(height: 12),
                _togglesCard(controller),
                const SizedBox(height: 24),
                _sectionTitle('Account'),
                const SizedBox(height: 12),
                _menuCard([
                  _menuTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    onTap: () => _notWiredYet(context, 'Change password'),
                  ),
                  _menuTile(
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Manage Admins',
                    onTap: () => _notWiredYet(context, 'Manage admins'),
                  ),
                  _menuTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () => Get.toNamed(AppRoute.notifications),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _sectionTitle('About'),
                const SizedBox(height: 12),
                _menuCard([
                  _menuTile(
                    icon: Icons.info_outline_rounded,
                    label: 'App Version',
                    trailing: const Text(
                      '1.0.0',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
                    ),
                    onTap: null,
                  ),
                  _menuTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () => _notWiredYet(context, 'Privacy policy'),
                  ),
                  _menuTile(
                    icon: Icons.description_outlined,
                    label: 'Terms of Service',
                    onTap: () => _notWiredYet(context, 'Terms of service'),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _logoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBlue, AppColors.darkBlue, AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your admin account',
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12.5),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppResources.logoPath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'admin@nibangsh.com',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  // ── Toggles card ──
  Widget _togglesCard(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Obx(
                () => _toggleTile(
              icon: Icons.notifications_active_outlined,
              label: 'Push Notifications',
              subtitle: 'Get notified about student activity',
              value: controller.pushNotifications.value,
              onChanged: controller.togglePushNotifications,
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGrey),
          Obx(
                () => _toggleTile(
              icon: Icons.mail_outline_rounded,
              label: 'Email Alerts',
              subtitle: 'Receive a daily summary by email',
              value: controller.emailAlerts.value,
              onChanged: controller.toggleEmailAlerts,
              showDivider: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  // ── Menu card ──
  Widget _menuCard(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(children: tiles),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.textGrey, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textGrey,
                      size: 20,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.borderGrey),
      ],
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorColor,
          side: const BorderSide(color: AppColors.errorColor),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _notWiredYet(BuildContext context, String feature) {
    Get.snackbar(
      feature,
      '$feature isn\'t wired up yet.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryRed,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoute.login);
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}