import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/validators.dart';
import '../../data/models/job_application.dart';
import '../common/widgets/custom_text_field.dart';
import '../common/widgets/custom_button.dart';
import '../common/widgets/status_selector.dart';
import '../viewmodels/applications_viewmodel.dart';

class AddApplicationScreen extends ConsumerStatefulWidget {
  const AddApplicationScreen({super.key});

  @override
  ConsumerState<AddApplicationScreen> createState() => _AddApplicationScreenState();
}

class _AddApplicationScreenState extends ConsumerState<AddApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  
  ApplicationStatus _selectedStatus = ApplicationStatus.applied;
  DateTime? _appliedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appsState = ref.watch(applicationsViewModelProvider);

    ref.listen(applicationsViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ref.read(applicationsViewModelProvider.notifier).clearSuccess();
        context.pop();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(applicationsViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Application'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: 'Job Title *',
                  hint: 'Flutter Developer',
                  controller: _titleController,
                  validator: (v) => Validators.required(v, 'Job title'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Company *',
                  hint: 'ABC Technologies',
                  controller: _companyController,
                  validator: (v) => Validators.required(v, 'Company'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Location',
                  hint: 'Remote',
                  controller: _locationController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Job URL',
                  hint: 'https://...',
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                Text(
                  'Status *',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                StatusSelector(
                  selectedStatus: _selectedStatus,
                  onSelected: (status) {
                    setState(() => _selectedStatus = status);
                  },
                ),
                const SizedBox(height: 16),
                // Applied date picker
                InkWell(
                  onTap: () => _pickDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Applied Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _appliedDate != null
                          ? '${_appliedDate!.day.toString().padLeft(2, '0')}/${_appliedDate!.month.toString().padLeft(2, '0')}/${_appliedDate!.year}'
                          : 'Select date',
                      style: TextStyle(
                        color: _appliedDate != null
                            ? null
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Notes',
                  hint: 'Applied via company website...',
                  controller: _notesController,
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Save Application',
                  isLoading: appsState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appliedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _appliedDate = picked);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final application = JobApplication(
      id: const Uuid().v4(),
      userId: '', // Will be set by repository
      jobTitle: _titleController.text.trim(),
      companyName: _companyController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      jobUrl: _urlController.text.trim().isEmpty
          ? null
          : _urlController.text.trim(),
      status: _selectedStatus,
      appliedAt: _appliedDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    ref.read(applicationsViewModelProvider.notifier).addApplication(application);
  }
}