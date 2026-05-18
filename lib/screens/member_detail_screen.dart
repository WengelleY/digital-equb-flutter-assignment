import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';
import '../theme/ui_config.dart';
import 'edit_member_screen.dart';

class MemberDetailScreen extends StatelessWidget {
  final String memberId;
  const MemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberProvider>(
      builder: (context, provider, _) {
        final member = provider.allMembers
            .where((m) => m.id == memberId)
            .firstOrNull;

        if (member == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Member Detail')),
            body: const Center(child: Text('Member not found')),
          );
        }

        final isPaid = member.status == 'Paid';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Member Detail'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditMemberScreen(member: member),
                  ),
                ),
                tooltip: 'Edit Member',
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: AppColors.notPaid,
                ),
                onPressed: () => _confirmDelete(context, provider, member),
                tooltip: 'Delete Member',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            member.name.isNotEmpty
                                ? member.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _buildInfoSection('Contact Information', [
                  _buildInfoRow(Icons.person_rounded, 'Full Name', member.name),
                  _buildInfoRow(
                    Icons.phone_rounded,
                    'Phone Number',
                    member.phone,
                  ),
                ]),
                const SizedBox(height: 16),

                _buildInfoSection('Equb Details', [
                  _buildInfoRow(
                    Icons.attach_money_rounded,
                    'Contribution',
                    '${member.contribution.toStringAsFixed(0)} ETB / round',
                  ),
                  _buildInfoRow(
                    Icons.rotate_right_rounded,
                    'Round Received',
                    member.roundReceived == 0
                        ? 'Not yet received'
                        : 'Round ${member.roundReceived}',
                  ),
                  _buildInfoRow(
                    Icons.payment_rounded,
                    'Payment Status',
                    member.status,
                    valueColor: isPaid ? AppColors.paid : AppColors.notPaid,
                  ),
                ]),
                const SizedBox(height: 28),

                if (!isPaid)
                  Center(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () => _markAsPaid(context, provider, member),
                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle_rounded),
                        label: const Text('Mark as Paid'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.paid,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textMid,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsPaid(
    BuildContext context,
    MemberProvider provider,
    Member member,
  ) async {
    final success = await provider.markAsPaid(member);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? '${member.name} marked as Paid!' : 'Failed to update',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmDelete(
    BuildContext context,
    MemberProvider provider,
    Member member,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Member',
          style: TextStyle(color: AppColors.textDark),
        ),
        content: Text(
          'Are you sure you want to remove ${member.name}?',
          style: const TextStyle(color: AppColors.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMid),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteMember(member.id!);
              if (context.mounted && success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${member.name} removed',
                      style: const TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.notPaid),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
