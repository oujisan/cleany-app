import 'package:cleany_app/core/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTaskReportScreen extends StatefulWidget {
  const CreateTaskReportScreen({super.key});

  @override
  State<CreateTaskReportScreen> createState() => _CreateTaskReportScreenState();
}

class _CreateTaskReportScreenState extends State<CreateTaskReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _areaIdController = TextEditingController();

  bool _isLoading = false;

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  final token = await SecureStorageService.getToken();  // sesuaikan nama class penyimpan tokennya

  final url = Uri.parse('https://localhost:7218/api/task/report/add');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      'areaId': int.tryParse(_areaIdController.text) ?? 0,
    }),
  );

  setState(() => _isLoading = false);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task report berhasil dibuat')),
    );
    Navigator.pop(context);
  } else {
    // gagal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal membuat task report: ${response.body}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Task Report'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _areaIdController,
                decoration: const InputDecoration(labelText: 'Area ID'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
