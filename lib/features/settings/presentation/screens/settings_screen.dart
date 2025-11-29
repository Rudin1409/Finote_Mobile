import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: const Color(0xFF121212), // Darker background
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(
          'Settings', // Changed title
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
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
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 14,
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
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
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
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
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
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Color(0xFF2F2F2F), height: 1),
    );
  }
}
