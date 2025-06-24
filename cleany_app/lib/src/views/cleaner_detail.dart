import 'package:cleany_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:cleany_app/src/widgets/navbar_widget.dart';

class CleanerDetail extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String role;
  final String shift;

  const CleanerDetail({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.role,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Detail Petugas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // tombol kembali
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _buildDetailItem('First Name', firstName),
              _buildDetailItem('Last Name', lastName),
              _buildDetailItem('Username', username),
              _buildDetailItem('Email', email),
              _buildDetailItem('Role', role),
              _buildDetailItem('Shift', shift),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
