import 'package:flutter/material.dart';
import 'package:cleany_app/core/colors.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String status;
  final String areaName;
  final String areaBuilding;
  final String? createdBy;
  final String? time;
  final String? taskType;
  final VoidCallback? onTap;

  const TaskCardWidget({
    super.key,
    required this.title,
    required this.status,
    required this.areaName,
    required this.areaBuilding,
    this.createdBy,
    this.time,
    this.taskType,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return const Color(0xFF10B981); // Green
      case 'in progress':
      case 'sedang dikerjakan':
        return const Color(0xFFF59E0B); // Amber
      case 'pending':
      case 'menunggu':
        return const Color(0xFF6B7280); // Gray
      default:
        return AppColors.primary;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return 'Selesai';
      case 'in_progress':
      case 'sedang dikerjakan':
        return 'Dikerjakan';
      case 'pending':
      case 'menunggu':
        return 'Menunggu';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRoutine = taskType?.toLowerCase() == 'routine';
    final isReport = taskType?.toLowerCase() == 'report';
    final hasAdditionalInfo = (isRoutine && time != null) || (isReport && createdBy != null);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Title and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$areaName • $areaBuilding',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),

                // Additional Info (Time for Routine, User for Report)
                if (hasAdditionalInfo) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        if (isRoutine && time != null) ...[
                          Icon(
                            Icons.schedule_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            time!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                        if (isReport && createdBy != null) ...[
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            createdBy!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  // Simple arrow indicator when no additional info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}