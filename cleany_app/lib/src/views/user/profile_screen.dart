import 'package:cleany_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/providers/profile_provider.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _initDataFuture;

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.initializeProfile(); // Changed from loadUserProfile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildProfileContent(),
          _buildBottomSpacing(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              child: FutureBuilder(
                future: _initDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  }
                  if (snapshot.hasError) {
                    return _buildErrorState();
                  }
                  return _buildHeaderContent();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Text(
        'Error loading profile data',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        // Show loading state if still loading
        if (profileProvider.isLoadingProfile) {
          return _buildLoadingState();
        }

        // Show error state if there's an error
        if (profileProvider.profileError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white70, size: 48),
                const SizedBox(height: 16),
                Text(
                  profileProvider.profileError!,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => profileProvider.refreshProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileAvatar(profileProvider),
            const SizedBox(height: 16),
            Text(
              '${profileProvider.profile.firstName} ${profileProvider.profile.lastName ?? ''}', // Fixed
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@${profileProvider.profile.username}', // Fixed
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileAvatar(ProfileProvider profileProvider) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white.withOpacity(0.2),
        backgroundImage: profileProvider.profile.imageUrl != null && profileProvider.profile.imageUrl!.isNotEmpty // Fixed
            ? NetworkImage(profileProvider.profile.imageUrl!)
            : null,
        child: profileProvider.profile.imageUrl == null || profileProvider.profile.imageUrl!.isEmpty // Fixed
            ? const Icon(Icons.person, color: Colors.white, size: 40)
            : null,
      ),
    );
  }

  Widget _buildProfileContent() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              // Show loading indicator in content area if needed
              if (profileProvider.isLoadingProfile && !profileProvider.hasProfile) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(),
                  const SizedBox(height: 24),
                  _buildProfileInfoCard(profileProvider),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Manage your personal information',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard(ProfileProvider profileProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoItem(
              icon: Icons.person_outline,
              label: 'First Name',
              value: profileProvider.profile.firstName, // Fixed
            ),
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.person_outline,
              label: 'Last Name',
              value: profileProvider.profile.lastName ?? '-', // Fixed - handle nullable
            ),
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.alternate_email,
              label: 'Username',
              value: profileProvider.profile.username, // Fixed
            ),
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profileProvider.profile.email, // Fixed
            ),
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.work_outline,
              label: 'Role',
              value: profileProvider.profile.role, // Added role field
            ),
            if (profileProvider.profile.shift != null) ...[
              _buildDivider(),
              _buildInfoItem(
                icon: Icons.schedule_outlined,
                label: 'Shift',
                value: profileProvider.profile.shift!, // Added shift field
              ),
            ],
            _buildDivider(),
            _buildInfoItem(
              icon: Icons.lock_outline,
              label: 'Password',
              value: '••••••••',
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value, // Handle empty values
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isPassword)
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.grey,
                size: 20,
              ),
              onPressed: () {
                _showChangePasswordDialog();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.grey.withOpacity(0.2),
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          color: AppColors.secondary,
          onTap: () {
            Navigator.pushNamed(context, '/edit-profile');
          },
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.security_outlined,
          title: 'Change Password',
          subtitle: 'Update your account password',
          color: AppColors.primary,
          onTap: () {
            _showChangePasswordDialog();
          },
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.refresh_outlined,
          title: 'Refresh Profile',
          subtitle: 'Reload your profile information',
          color: AppColors.primary.withOpacity(0.7),
          onTap: () async {
            final profileProvider = context.read<ProfileProvider>();
            await profileProvider.refreshProfile();
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile refreshed successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.logout_outlined,
          title: 'Logout',
          subtitle: 'Sign out from your account',
          color: AppColors.error,
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          content: const Text(
            'This feature will redirect you to change password page.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/change-password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final authProvider = context.read<AuthProvider>();
                final profileProvider = context.read<ProfileProvider>();
                
                // Clear profile data before logout
                profileProvider.clearData();
                await authProvider.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSpacing() {
    return const SliverToBoxAdapter(child: SizedBox(height: 120));
  }
}