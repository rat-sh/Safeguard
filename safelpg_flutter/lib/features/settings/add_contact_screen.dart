import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/safe_lpg_button.dart';
import '../../shared/widgets/safe_lpg_input.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  int _priority = 1;
  bool _phoneCallEnabled = true;
  bool _smsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 28),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text(
          'Add Emergency Contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppTheme.border),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar preview
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCCFBF1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.person_add_outlined, color: AppTheme.primary, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    const SafeLPGInput(
                      labelText: 'Full Name',
                      hintText: 'e.g. Riya Kumar',
                    ),
                    const SizedBox(height: 16),

                    // Phone number input with country prefix
                    const Text(
                      'Phone Number',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            decoration: const BoxDecoration(
                              color: AppTheme.background,
                              border: Border(right: BorderSide(color: AppTheme.border)),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Row(children: const [
                              Text('🇮🇳 +91', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                              SizedBox(width: 4),
                              Icon(Icons.chevron_right, size: 16, color: AppTheme.textSecondary),
                            ]),
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
                              decoration: const InputDecoration(
                                hintText: '98765 43210',
                                hintStyle: TextStyle(color: AppTheme.disabled),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    const SafeLPGInput(
                      labelText: 'Relationship',
                      hintText: 'e.g. Family, Neighbour, Friend',
                    ),
                    const SizedBox(height: 24),

                    // Priority Selector
                    const Text(
                      'ALERT PRIORITY',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [1, 2, 3].map((p) {
                        final isSelected = _priority == p;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: p < 3 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _priority = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFCCFBF1) : AppTheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primary : AppTheme.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '#$p',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Priority #1 is contacted first during emergencies',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),

                    // Notification toggles
                    const Text(
                      'NOTIFY VIA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    _buildToggleRow(
                      Icons.phone_outlined,
                      'Phone Call',
                      'During critical alerts',
                      _phoneCallEnabled,
                      (v) => setState(() => _phoneCallEnabled = v),
                    ),
                    const Divider(height: 1, thickness: 1, color: AppTheme.border),
                    _buildToggleRow(
                      Icons.sms_outlined,
                      'SMS Message',
                      'For all warning-level events',
                      _smsEnabled,
                      (v) => setState(() => _smsEnabled = v),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppTheme.warning, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This contact will be alerted during emergencies. Make sure you have their permission.',
                              style: TextStyle(fontSize: 12, color: AppTheme.warning, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SafeLPGButton(
                      text: 'Cancel',
                      onPressed: () {
                        if (context.canPop()) context.pop();
                      },
                      variant: ButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SafeLPGButton(
                      text: 'Save Contact',
                      onPressed: () {
                        if (context.canPop()) context.pop();
                      },
                      variant: ButtonVariant.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    IconData icon,
    String label,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
        ],
      ),
    );
  }
}
