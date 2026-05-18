import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';

class AddMemberScreen extends StatefulWidget {
  final String groupId;
  const AddMemberScreen({super.key, required this.groupId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contributionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _contributionController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final member = Member(
      groupId: widget.groupId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      contribution: double.tryParse(_contributionController.text.trim()) ?? 0.0,
      status: 'Not Paid',
      roundReceived: 0,
    );

    final success = await context.read<MemberProvider>().addMember(member);

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Member added successfully!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
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
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
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
        title: const Text('Add New Member'),
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
              // Header illustration
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7C59).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Color(0xFF4A7C59),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'New Equb Member',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1F0E),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Name field
              _buildLabel('Full Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Abebe Girma',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF5C4A2A),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (val.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Phone field
              _buildLabel('Phone Number'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'e.g. 0912345678',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Color(0xFF5C4A2A),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (val.trim().length < 10) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Contribution field
              _buildLabel('Monthly Contribution (ETB)'),
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
                  hintText: 'e.g. 500',
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
                    return 'Contribution amount is required';
                  }
                  final amount = double.tryParse(val);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save button
              Center(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveMember,
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
                    label: Text(_isSaving ? 'Saving...' : 'Save Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C59),
                      disabledBackgroundColor: const Color(
                        0xFF4A7C59,
                      ).withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
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
