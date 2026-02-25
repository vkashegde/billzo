import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../invoice/domain/entities/invoice.dart';
import '../../../invoice/presentation/cubit/invoice_cubit.dart';
import '../../../invoice/presentation/cubit/invoice_state.dart';
import '../../../invoice/presentation/pages/create_invoice_page.dart';
import '../../../invoice/presentation/pages/invoice_list_page.dart';
import '../../../invoice/presentation/pages/invoice_preview_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routePath = '/';
  static const String routeName = 'dashboard';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceCubit>().loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 24),
              const _BalanceCard(),
              const SizedBox(height: 24),
              const _QuickActionsRow(),
              const SizedBox(height: 32),
              const _RecentInvoicesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.receipt_long_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              'Welcome to Billzo',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        double totalBalance = 0;
        double monthlyRevenue = 0;
        double pendingAmount = 0;

        if (state is InvoiceLoaded) {
          final now = DateTime.now();
          final thisMonth = DateTime(now.year, now.month, 1);

          for (final invoice in state.invoices) {
            totalBalance += invoice.totalAmount;

            if (invoice.issueDate.isAfter(thisMonth)) {
              monthlyRevenue += invoice.totalAmount;
            }

            if (invoice.status == InvoiceStatus.sent || invoice.status == InvoiceStatus.draft) {
              pendingAmount += invoice.totalAmount;
            }
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${_formatCurrency(totalBalance)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatPill(
                      label: 'Monthly Revenue',
                      value: '+₹${_formatCurrency(monthlyRevenue)}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatPill(label: 'Pending', value: '₹${_formatCurrency(pendingAmount)}'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }
    return '${buffer.toString()}.$decPart';
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickAction(
          icon: Icons.add,
          label: 'New',
          onTap: () => context.push(CreateInvoicePage.routePath),
        ),
        _QuickAction(
          icon: Icons.group_rounded,
          label: 'Clients',
          onTap: () => context.go('/clients'),
        ),
        _QuickAction(
          icon: Icons.bar_chart_rounded,
          label: 'Reports',
          onTap: () {
            // TODO: Navigate to reports
          },
        ),
        _QuickAction(
          icon: Icons.settings_rounded,
          label: 'Tools',
          onTap: () => context.go('/profile'),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }
}

class _RecentInvoicesSection extends StatelessWidget {
  const _RecentInvoicesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Invoices',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(InvoiceListPage.routePath),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoading) {
              return const Center(
                child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
              );
            } else if (state is InvoiceLoaded) {
              if (state.invoices.isEmpty) {
                return _buildEmptyState(context);
              }

              // Show only the 4 most recent invoices
              final recentInvoices = state.invoices.toList()
                ..sort((a, b) => b.issueDate.compareTo(a.issueDate));
              final displayInvoices = recentInvoices.take(4).toList();

              return Column(
                children: displayInvoices
                    .map(
                      (invoice) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _InvoiceCard(invoice: invoice),
                      ),
                    )
                    .toList(),
              );
            } else if (state is InvoiceError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No invoices yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create your first invoice to get started',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push(CreateInvoicePage.routePath),
            icon: const Icon(Icons.add),
            label: const Text('Create Invoice'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        InvoicePreviewPage.routeName,
        pathParameters: {'id': invoice.id},
        extra: invoice,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: _getAvatarColor(invoice.status),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(_getStatusIcon(invoice.status), color: _getStatusColor(invoice.status)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.clientName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${invoice.invoiceNumber} • ${_formatDate(invoice.issueDate)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${_formatAmount(invoice.totalAmount)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getChipBackground(invoice.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusLabel(invoice.status),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(invoice.status),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return const Color(0xFFE5F9EE);
      case InvoiceStatus.sent:
        return const Color(0xFFFFEFD6);
      case InvoiceStatus.overdue:
        return const Color(0xFFFFE1E5);
      case InvoiceStatus.draft:
        return const Color(0xFFF5F5F5);
      case InvoiceStatus.cancelled:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getChipBackground(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return AppColors.paidChipBackground;
      case InvoiceStatus.sent:
        return AppColors.pendingChipBackground;
      case InvoiceStatus.overdue:
        return AppColors.overdueChipBackground;
      case InvoiceStatus.draft:
        return const Color(0xFFF5F5F5);
      case InvoiceStatus.cancelled:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return AppColors.success;
      case InvoiceStatus.sent:
        return AppColors.warning;
      case InvoiceStatus.overdue:
        return AppColors.danger;
      case InvoiceStatus.draft:
        return AppColors.textSecondary;
      case InvoiceStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return Icons.check_rounded;
      case InvoiceStatus.sent:
        return Icons.access_time_filled_rounded;
      case InvoiceStatus.overdue:
        return Icons.error_rounded;
      case InvoiceStatus.draft:
        return Icons.edit_rounded;
      case InvoiceStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  String _getStatusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return 'PAID';
      case InvoiceStatus.sent:
        return 'PENDING';
      case InvoiceStatus.overdue:
        return 'OVERDUE';
      case InvoiceStatus.draft:
        return 'DRAFT';
      case InvoiceStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }
    return '${buffer.toString()}.$decPart';
  }
}
