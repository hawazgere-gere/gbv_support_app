/* 
 * Incident Reporting Screen
 * -----------------------------------------
 * Clean and realistic reporting interface
 * with validation, categories, safe UI,
 * and proper state handling.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_provider.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _detailsController = TextEditingController();

  String? _selectedIncident;
  bool _isSubmitting = false;

  final List<String> _incidentTypes = [
    'Physical Violence',
    'Emotional Abuse',
    'Sexual Harassment',
    'Forced Marriage',
    'Online Abuse',
    'Threat or Intimidation',
    'Other',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(reportProvider.notifier).submitReport(
            _selectedIncident!,
            _detailsController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Report submitted successfully.'
                : 'Failed to submit report.',
          ),
          backgroundColor:
              success ? Colors.green.shade600 : Colors.red.shade600,
        ),
      );

      if (success) {
        _formKey.currentState!.reset();

        setState(() {
          _selectedIncident = null;
        });

        _detailsController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                const Text(
                  'Submit a Report',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your information will remain private and secure.',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                // INFORMATION CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.brown.shade100,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.security,
                        color: Colors.brown.shade400,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Only trusted personnel should access submitted reports.',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // INCIDENT TYPE
                const Text(
                  'Incident Type',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: _selectedIncident,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  hint: const Text('Select incident type'),
                  items: _incidentTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select incident type';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedIncident = value;
                    });
                  },
                ),

                const SizedBox(height: 22),

                // DETAILS
                const Text(
                  'Incident Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _detailsController,
                  minLines: 6,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText:
                        'Describe what happened, where it occurred, or any important information...',
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide incident details';
                    }

                    if (value.trim().length < 15) {
                      return 'Please provide more detailed information';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // NOTE
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'If you are in immediate danger, use the SOS feature instead.',
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D4C41),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Report',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
