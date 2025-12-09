import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/core/services/theme_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/features/settings/presentation/screens/change_password_screen.dart';
import 'package:myapp/features/settings/presentation/widgets/delete_account_dialog.dart';
import 'package:myapp/features/settings/presentation/screens/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const SettingsScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'No Email';
    final name = user?.displayName ?? 'User';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await FirebaseAuth.instance.currentUser?.reload();
          // Force rebuild to show updated info if any
          (context as Element).markNeedsBuild();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  // Placeholder for the profile image, replace with your actual image asset
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF37C8C3), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _buildSettingsOptions(context),
                const SizedBox(height: 40), // Replaced Spacer with SizedBox
                _buildLogoutButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditProfileScreen(),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChangePasswordScreen(),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteAccountDialog();
      },
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.edit_outlined,
            text: 'Edit Profile',
            onTap: () => _showEditProfileSheet(context),
          ),
          _buildDivider(),
          _buildListTile(
            context,
            icon: Icons.brightness_6_outlined,
            text: 'Tampilan Aplikasi',
            onTap: () => _showThemeDialog(context),
          ),
          _buildDivider(),
          _buildListTile(
            context,
            icon: Icons.lock_outline,
            text: 'Ubah Password',
            onTap: () => _showChangePasswordSheet(context),
          ),
          _buildDivider(),
          _buildListTile(
            context,
            icon: Icons.language,
            text: 'Hapus Akun',
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeService = Provider.of<ThemeService>(context, listen: false);
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title:
              Text('Pilih Tema', style: Theme.of(context).textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeRadio(
                  context, themeService, 'Terang', ThemeMode.light),
              _buildThemeRadio(context, themeService, 'Gelap', ThemeMode.dark),
              _buildThemeRadio(
                  context, themeService, 'Sistem', ThemeMode.system),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeRadio(BuildContext context, ThemeService service,
      String label, ThemeMode mode) {
    return RadioListTile<ThemeMode>(
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      value: mode,
      groupValue: service.themeMode,
      onChanged: (ThemeMode? value) {
        if (value != null) {
          service.setThemeMode(value);
          Navigator.pop(context);
        }
      },
      activeColor: FinoteColors.primary,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF37C8C3)),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          color: Theme.of(context).iconTheme.color, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.grey.withOpacity(0.2), height: 1),
    );
  }
}
