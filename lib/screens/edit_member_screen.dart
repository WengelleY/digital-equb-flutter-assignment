import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';

class EditMemberScreen extends StatefulWidget {
  final Member member;

  const EditMemberScreen({super.key, required this.member});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _contributionController;
  late TextEditingController _roundController;
  late String _selectedStatus;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _phoneController = TextEditingController(text: widget.member.phone);
    _contributionController = TextEditingController(
      text: widget.member.contribution.toStringAsFixed(0),
    );
    _roundController = TextEditingController(
      text: widget.member.roundReceived.toString(),
    );
    _selectedStatus = widget.member.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _contributionController.dispose();
    _roundController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedMember = widget.member.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      contribution:
          double.tryParse(_contributionController.text.trim()) ??
          widget.member.contribution,
      status: _selectedStatus,
      roundReceived:
          int.tryParse(_roundController.text.trim()) ??
          widget.member.roundReceived,
      groupId: widget.member.groupId,
    );

    final success = await context.read<MemberProvider>().updateMember(
      widget.member.id!,
      updatedMember,
    );

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Member updated successfully!',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = context.read<MemberProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5DFA0),
      appBar: AppBar(
        title: const Text('Edit Member'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar header
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7C59).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.member.name.isNotEmpty
                          ? widget.member.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7C59),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Editing: ${widget.member.name}',
                  style: const TextStyle(
                    color: Color(0xFF5C4A2A),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF5C4A2A),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (val.trim().length < 2) return 'Name too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone
              _buildLabel('Phone Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Color(0xFF5C4A2A),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone is required';
                  }
                  if (val.trim().length < 10) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contribution
              _buildLabel('Contribution (ETB)'),
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
                  prefixIcon: Icon(
                    Icons.attach_money_rounded,
                    color: Color(0xFF5C4A2A),
                  ),
                  suffixText: 'ETB',
                  suffixStyle: TextStyle(
                    color: Color(0xFF5C4A2A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Amount is required';
                  }
                  final n = double.tryParse(val);
                  if (n == null || n <= 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Round received
              _buildLabel('Round Received (0 = not yet)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _roundController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.rotate_right_rounded,
                    color: Color(0xFF5C4A2A),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status
              _buildLabel('Payment Status'),
              const SizedBox(height: 4),
              Row(
                children: ['Not Paid', 'Paid'].map((status) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: status,
                        groupValue: _selectedStatus,
                        onChanged: (String? val) => setState(
                          () => _selectedStatus = val ?? _selectedStatus,
                        ),
                        activeColor: status == 'Paid'
                            ? const Color(0xFF4A7C59)
                            : const Color(0xFFB85C38),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: _selectedStatus == status
                              ? (status == 'Paid'
                                    ? const Color(0xFF4A7C59)
                                    : const Color(0xFFB85C38))
                              : const Color(0xFF5C4A2A),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save button
              Center(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveChanges,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C59),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Discard Changes',
                    style: TextStyle(color: Color(0xFF5C4A2A)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2C1F0E),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}
