import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class DashboardPage extends StatelessWidget {
  static const String routePath = '/';
  static const String routeName = 'dashboard';

  const DashboardPage({super.key});

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
              _Header(),
              const SizedBox(height: 24),
              const _BalanceCard(),
              const SizedBox(height: 24),
              const _QuickActionsRow(),
              const SizedBox(height: 32),
              _RecentInvoicesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
              'Welcome back, Alex',
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
            '\$42,500.00',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: _StatPill(label: 'Monthly Revenue', value: '+\$8,200'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatPill(label: 'Pending', value: '\$3,150'),
              ),
            ],
          ),
        ],
      ),
    );
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
      children: const [
        _QuickAction(icon: Icons.add, label: 'New'),
        _QuickAction(icon: Icons.group_rounded, label: 'Clients'),
        _QuickAction(icon: Icons.bar_chart_rounded, label: 'Reports'),
        _QuickAction(icon: Icons.settings_rounded, label: 'Tools'),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _RecentInvoicesSection extends StatelessWidget {
  final List<_DashboardInvoice> invoices = const [
    _DashboardInvoice(
      clientName: 'Acme Corp',
      code: '#INV-2024-001',
      date: 'Jan 15',
      amount: '\$1,200.00',
      statusLabel: 'PAID',
      statusColor: AppColors.success,
      statusBackground: AppColors.paidChipBackground,
      avatarColor: Color(0xFFE5F9EE),
      avatarIcon: Icons.check_rounded,
    ),
    _DashboardInvoice(
      clientName: 'Global Tech',
      code: '#INV-2024-003',
      date: 'Jan 18',
      amount: '\$850.50',
      statusLabel: 'PENDING',
      statusColor: AppColors.warning,
      statusBackground: AppColors.pendingChipBackground,
      avatarColor: Color(0xFFFFEFD6),
      avatarIcon: Icons.access_time_filled_rounded,
    ),
    _DashboardInvoice(
      clientName: 'Stark Indust.',
      code: '#INV-2024-002',
      date: 'Jan 10',
      amount: '\$4,500.00',
      statusLabel: 'OVERDUE',
      statusColor: AppColors.danger,
      statusBackground: AppColors.overdueChipBackground,
      avatarColor: Color(0xFFFFE1E5),
      avatarIcon: Icons.error_rounded,
    ),
    _DashboardInvoice(
      clientName: 'Nebula Design',
      code: '#INV-2024-004',
      date: 'Jan 20',
      amount: '\$150.00',
      statusLabel: 'PAID',
      statusColor: AppColors.success,
      statusBackground: AppColors.paidChipBackground,
      avatarColor: Color(0xFFE5F9EE),
      avatarIcon: Icons.check_rounded,
    ),
  ];

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
              onPressed: () {
                // TODO: navigate to full invoices list
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: invoices
              .map(
                (invoice) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InvoiceCard(invoice: invoice),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DashboardInvoice {
  final String clientName;
  final String code;
  final String date;
  final String amount;
  final String statusLabel;
  final Color statusColor;
  final Color statusBackground;
  final Color avatarColor;
  final IconData avatarIcon;

  const _DashboardInvoice({
    required this.clientName,
    required this.code,
    required this.date,
    required this.amount,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBackground,
    required this.avatarColor,
    required this.avatarIcon,
  });
}

class _InvoiceCard extends StatelessWidget {
  final _DashboardInvoice invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: invoice.avatarColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(invoice.avatarIcon, color: invoice.statusColor),
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
                  '${invoice.code} • ${invoice.date}',
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
                invoice.amount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: invoice.statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.statusLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: invoice.statusColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
