import 'package:cleany_app/src/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:cleany_app/src/models/user_profile_model.dart';
import 'package:cleany_app/src/providers/user_profile_provider.dart';
import 'package:cleany_app/core/colors.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  void initState() {
    super.initState();
    // Panggil provider untuk mengambil data saat halaman pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case ViewState.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            case ViewState.error:
              return _buildErrorWidget(context, provider.errorMessage);
            case ViewState.loaded:
              if (provider.userProfiles.isEmpty) {
                return const Center(child: Text("No users found."));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: provider.userProfiles.length,
                itemBuilder: (context, index) {
                  final user = provider.userProfiles[index];
                  return _buildUserProfileCard(context, user);
                },
              );
            case ViewState.initial:
            default:
              return const Center(child: Text('Welcome! Fetching data...'));
          }
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 60),
          const SizedBox(height: 16),
          Text(
            'Failed to Load Profile',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: AppColors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.black, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            onPressed: () {
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).getUserProfile();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Card(
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAvatar(user),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${user.username}',
                style: const TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.grey),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.email_outlined, user.email),
              _buildInfoRow(
                Icons.work_outline,
                'Role: ${user.role == 'k' ? 'Koordinator' : user.role}',
              ),
              _buildInfoRow(
                Icons.schedule_outlined,
                'Shift: ${user.shift ?? 'Not Assigned'}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserProfile user) {
    // Cek apakah imageUrl ada dan tidak kosong
    final hasImage = user.imageUrl != null && user.imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.primary,
      backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
      child:
          !hasImage
              ? Text(
                user.initials,
                style: const TextStyle(fontSize: 40, color: AppColors.white),
              )
              : null,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
