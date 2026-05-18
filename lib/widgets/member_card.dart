import 'package:flutter/material.dart';
import '../models/member.dart';

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
              color: const Color(0xFFEDD98A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFD4A843).withValues(alpha: 0.2),
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
                            color: Color(0xFF2C1F0E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_rounded,
                              size: 11,
                              color: Color(0xFF8C7A5A),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              member.phone,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8C7A5A),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.attach_money_rounded,
                              size: 11,
                              color: Color(0xFF8C7A5A),
                            ),
                            Text(
                              '${member.contribution.toStringAsFixed(0)} ETB',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8C7A5A),
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
                    color: Color(0xFF8C7A5A),
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
            color: isPaid ? const Color(0xFF4A7C59) : const Color(0xFFB85C38),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isPaid ? 'Paid' : 'Not Paid',
          style: TextStyle(
            fontSize: 11,
            color: isPaid ? const Color(0xFF4A7C59) : const Color(0xFFB85C38),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
