import 'package:cleany_app/core/font.dart';
import 'package:flutter/material.dart';

class CleaningTaskFormScreen extends StatelessWidget {
  const CleaningTaskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Cleaning Task Form',
          style: AppFonts.bodyMedium.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFB2DFDB),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Request by:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@asepthecustomer',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Title', style: AppFonts.bodySmall.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Floor', style: AppFonts.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: _inputDecoration(),
                          items: const [], // ← Dummy data dihapus
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Area / Room', style: AppFonts.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: _inputDecoration(),
                          items: const [], // ← Dummy data dihapus
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('Image', style: AppFonts.bodySmall.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: _inputDecoration(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image_outlined, color: Color(0xFF00796B)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF00796B)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text('Description', style: AppFonts.bodySmall.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 5,
                decoration: _inputDecoration(),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009688),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size.fromHeight(52),
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
