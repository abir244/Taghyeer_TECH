import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(isDark, theme),
            const SizedBox(height: 8),
            _buildSection(
              title: 'Appearance',
              children: [_buildThemeTile(isDark, theme)],
            ),
            const SizedBox(height: 8),
            _buildSection(
              title: 'Account',
              children: [_buildLogoutTile()],
            ),
            const SizedBox(height: 30),
            _buildAppVersion(isDark),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(bool isDark, ThemeData theme) {
    return Obx(() {
      final user = controller.user.value;
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [const Color(0xFF1A73E8), const Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 2),
              ),
              child: CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white24,
                child: user?.image != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user!.image!,
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _defaultAvatar(user),
                        ),
                      )
                    : _defaultAvatar(user),
              ),
            ),
            const SizedBox(width: 16),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '@${user?.username ?? ''}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: Colors.white60, size: 13),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user?.email ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _defaultAvatar(user) {
    return Text(
      user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : 'U',
      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildThemeTile(bool isDark, ThemeData theme) {
    return Obx(() => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              controller.isDarkMode.value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            controller.isDarkMode.value ? 'Currently using dark theme' : 'Currently using light theme',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Switch.adaptive(
            value: controller.isDarkMode.value,
            onChanged: controller.toggleTheme,
            activeColor: theme.colorScheme.primary,
          ),
        ));
  }

  Widget _buildLogoutTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.logout_rounded, color: Color(0xFFE53935)),
      ),
      title: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE53935)),
      ),
      subtitle: const Text('Sign out of your account', style: TextStyle(fontSize: 12)),
      onTap: () => _showLogoutDialog(),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: controller.logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion(bool isDark) {
    return Text(
      'Taghyeer Shop v1.0.0',
      style: TextStyle(
        fontSize: 12,
        color: isDark ? Colors.grey[600] : Colors.grey[400],
      ),
    );
  }
}
