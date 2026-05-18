import 'package:flutter/material.dart';
import '../models/member.dart';
import '../theme/ui_config.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;
  final VoidCallback? onMarkPaid;

  const MemberCard({
    super.key,
    required this.member,
    required this.onTap,
    this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = member.status == 'Paid';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryDark.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 11,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              member.phone,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.attach_money_rounded,
                              size: 11,
                              color: AppColors.textLight,
                            ),
                            Text(
                              '${member.contribution.toStringAsFixed(0)} ETB',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(isPaid),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isPaid) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPaid ? AppColors.paid : AppColors.notPaid,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isPaid ? 'Paid' : 'Not Paid',
          style: TextStyle(
            fontSize: 11,
            color: isPaid ? AppColors.paid : AppColors.notPaid,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
