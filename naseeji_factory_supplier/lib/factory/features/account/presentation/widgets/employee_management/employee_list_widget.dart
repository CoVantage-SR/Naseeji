import 'package:flutter/material.dart';
import '../../providers/account_provider.dart';
import '../account_reusable_widgets.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<EmployeeModel> employees;
  final Function(EmployeeModel) onEdit;
  final Function(String) onToggleStatus;
  final Function(String) onDelete;

  const EmployeeListWidget({
    super.key,
    required this.employees,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const AccountEmptyStateWidget(
        title: 'لا يوجد موظفون',
        description: 'أضف موظفين إلى المصنع وحدد صلاحياتهم.',
        icon: Icons.people_outline_rounded,
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: employees.length,
      itemBuilder: (_, i) {
        final emp = employees[i];
        return EmployeeCard(
          employee: emp,
          onEdit: () => onEdit(emp),
          onToggleStatus: () => onToggleStatus(emp.id),
          onDelete: () => onDelete(emp.id),
        );
      },
    );
  }
}



