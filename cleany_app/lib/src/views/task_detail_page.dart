import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cleany_app/src/models/task_response_model.dart';
import 'package:cleany_app/src/providers/auth_provider.dart';
import 'package:cleany_app/src/services/task_service.dart';
import 'package:cleany_app/core/font.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskResponseModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool _isLoading = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      int assignmentIdInt = int.parse(widget.task.assignmentId);
      await TaskService.updateTaskStatus(
        assignmentId: assignmentIdInt,
        status: newStatus,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Status updated to $newStatus')));
      setState(() {
        widget.task.status = newStatus;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthProvider>(context).role;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: const Color(0xFF009688),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Judul Tugas', widget.task.taskTitle),
            _buildInfoCard(
              'Deskripsi',
              widget.task.taskDescription ?? 'Tidak ada deskripsi',
            ),
            _buildInfoCard(
              'Area',
              '${widget.task.areaName}, ${widget.task.areaBuilding}, Lt.${widget.task.areaFloor}',
            ),
            _buildInfoCard('Tipe Tugas', widget.task.taskType),
            _buildInfoCard('Dibuat oleh', widget.task.taskCreatedBy),
            _buildInfoCard('Status', widget.task.status.toUpperCase()),
            if (widget.task.date != null)
              _buildInfoCard('Tanggal', widget.task.date!),
            if (widget.task.createdAt != null)
              _buildInfoCard('Dibuat pada', widget.task.createdAt!),
            const SizedBox(height: 20),
            if (role == 'cleaner') _buildActionButton(widget.task.status),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: AppFonts.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String status) {
    String buttonLabel = '';
    String? nextStatus;

    if (status == 'pending') {
      buttonLabel = 'Mulai Dikerjakan';
      nextStatus = 'in_progress';
    } else if (status == 'in_progress') {
      buttonLabel = 'Tandai Selesai';
      nextStatus = 'completed';
    }

    if (nextStatus == null) return const SizedBox();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _updateStatus(nextStatus!),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00796B),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(buttonLabel, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
