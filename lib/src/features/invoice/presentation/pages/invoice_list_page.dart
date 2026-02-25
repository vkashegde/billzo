import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/invoice_cubit.dart';
import '../cubit/invoice_state.dart';

class InvoiceListPage extends StatefulWidget {
  static const String routePath = '/invoices';
  static const String routeName = 'invoice_list';

  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceCubit>().loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InvoiceLoaded) {
            if (state.invoices.isEmpty) {
              return const Center(
                child: Text(
                  'No invoices yet. Tap + to add your first invoice.',
                ),
              );
            }
            return ListView.separated(
              itemCount: state.invoices.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final invoice = state.invoices[index];
                return ListTile(
                  title: Text(invoice.customerName),
                  subtitle: Text(
                    'Amount: \$${invoice.amount.toStringAsFixed(2)}',
                  ),
                  trailing: Text(
                    '${invoice.issueDate.day}/${invoice.issueDate.month}/${invoice.issueDate.year}',
                  ),
                );
              },
            );
          } else if (state is InvoiceError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
