import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/equb_group.dart';
import '../providers/group_provider.dart';
import '../theme/ui_config.dart';
import 'home_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DIGITAL EQUB',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.8,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<GroupProvider>(
        builder: (context, provider, _) {
          if (!provider.hasGroups) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_off_rounded,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No groups created yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap + to create your first Equb group',
                    style: TextStyle(fontSize: 13, color: AppColors.textLight),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: provider.groups.length,
            itemBuilder: (ctx, i) {
              final group = provider.groups[i];
              return _GroupCard(group: group);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGroupSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Group',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
      ),
    );
  }

  void _showAddGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddGroupSheet(),
    );
  }
}

// ─── Group Card ───────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final EqubGroup group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(group: group)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryDark.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _pill(
                          Icons.people_rounded,
                          '${group.totalMembers} members',
                        ),
                        const SizedBox(width: 8),
                        _pill(
                          Icons.attach_money_rounded,
                          '${group.contributionAmount.toStringAsFixed(0)} ETB',
                        ),
                        const SizedBox(width: 8),
                        _pill(Icons.calendar_today_rounded, group.interval),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.notPaid,
                  size: 22,
                ),
                onPressed: () => _confirmDelete(context),
                tooltip: 'Delete group',
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
    );
  }

  Widget _pill(IconData icon, String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 11, color: AppColors.textLight),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Group',
          style: TextStyle(color: AppColors.textDark),
        ),
        content: Text(
          'Are you sure you want to delete "${group.name}"?',
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
            onPressed: () {
              Navigator.pop(ctx);
              context.read<GroupProvider>().deleteGroup(group.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '"${group.name}" deleted',
                    style: const TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.notPaid),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Add Group Bottom Sheet ───────────────────────────────────────────────────

class _AddGroupSheet extends StatefulWidget {
  const _AddGroupSheet();

  @override
  State<_AddGroupSheet> createState() => _AddGroupSheetState();
}

class _AddGroupSheetState extends State<_AddGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contributionController = TextEditingController();
  final _totalMembersController = TextEditingController();
  String _interval = 'Monthly';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contributionController.dispose();
    _totalMembersController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);

    final group = EqubGroup(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      contributionAmount:
          double.tryParse(_contributionController.text.trim()) ?? 0,
      interval: _interval,
      totalMembers: int.tryParse(_totalMembersController.text.trim()) ?? 0,
    );

    await context.read<GroupProvider>().addGroup(group);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textLight.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Equb Group',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Group Name
              _label('Group Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Addis Equb Group A',
                  prefixIcon: Icon(
                    Icons.drive_file_rename_outline_rounded,
                    color: AppColors.textMid,
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Group name is required'
                    : null,
              ),
              const SizedBox(height: 14),

              // Contribution
              _label('Contribution Amount per Round (ETB)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contributionController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: 'e.g. 1000',
                  prefixIcon: Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.textMid,
                  ),
                  suffixText: 'ETB',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Required';
                  }
                  if ((double.tryParse(v) ?? 0) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Interval
              _label('Interval'),
              const SizedBox(height: 8),
              Row(
                children: ['Weekly', 'Monthly', 'Yearly'].map((opt) {
                  final selected = _interval == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _interval = opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.accent
                              : AppColors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? AppColors.accent
                                : AppColors.primaryDark.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          opt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? AppColors.white
                                : AppColors.textMid,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Total Members
              _label('Total Number of Members'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _totalMembersController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'e.g. 10',
                  prefixIcon: Icon(
                    Icons.people_rounded,
                    color: AppColors.textMid,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Required';
                  }
                  if ((int.tryParse(v) ?? 0) < 2) {
                    return 'Equb needs at least 2 members';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(_isSaving ? 'Saving...' : 'Create Group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.textDark,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
  );
}
