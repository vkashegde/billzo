import '../../domain/entities/invoice.dart';

sealed class InvoiceState {
  const InvoiceState();
}

class InvoiceInitial extends InvoiceState {
  const InvoiceInitial();
}

class InvoiceLoading extends InvoiceState {
  const InvoiceLoading();
}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;

  const InvoiceLoaded(this.invoices);
}

class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError(this.message);
}
