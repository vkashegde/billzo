import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../features/invoice/domain/entities/invoice.dart';
import '../../features/invoice/domain/entities/line_item.dart';

/// Service for generating and saving invoice PDFs.
class PdfService {
  pw.Font? _regularFont;
  pw.Font? _boldFont;

  /// Load fonts that support Rupee symbol
  Future<void> _loadFonts() async {
    if (_regularFont != null && _boldFont != null) return;

    // Load Noto Sans font which supports Indian Rupee symbol
    final regularFontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final boldFontData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');

    _regularFont = pw.Font.ttf(regularFontData);
    _boldFont = pw.Font.ttf(boldFontData);
  }

  pw.TextStyle _textStyle({
    double fontSize = 11,
    bool bold = false,
    PdfColor? color,
    double? letterSpacing,
  }) {
    return pw.TextStyle(
      font: bold ? _boldFont : _regularFont,
      fontBold: _boldFont,
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Generates a PDF for the given invoice and saves it locally.
  /// Returns the file path of the saved PDF.
  Future<String> generateAndSaveInvoicePdf(Invoice invoice) async {
    // Load fonts first
    await _loadFonts();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(base: _regularFont, bold: _boldFont),
        build: (context) => [
          _buildHeader(invoice),
          pw.SizedBox(height: 30),
          _buildClientInfo(invoice),
          pw.SizedBox(height: 20),
          _buildInvoiceDetails(invoice),
          pw.SizedBox(height: 30),
          _buildLineItemsTable(invoice),
          pw.SizedBox(height: 20),
          _buildTotals(invoice),
          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 30),
            _buildNotes(invoice),
          ],
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    // Get the downloads directory
    final directory = await _getDownloadsDirectory();
    final fileName =
        'Invoice_${invoice.invoiceNumber.replaceAll('#', '')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${directory.path}/$fileName';

    // Save the PDF
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  /// Opens the PDF file with the default PDF viewer.
  Future<void> openPdf(String filePath) async {
    await OpenFile.open(filePath);
  }

  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // Use external storage downloads directory on Android
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory;
      }
      // Fallback to app documents directory
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      // Desktop platforms
      final downloadsDir = await getDownloadsDirectory();
      return downloadsDir ?? await getApplicationDocumentsDirectory();
    }
  }

  pw.Widget _buildHeader(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#4F46E5').shade(0.9),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Icon(
                const pw.IconData(0xe0af), // Business icon
                color: PdfColor.fromHex('#4F46E5'),
                size: 32,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Your Business',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Set up your business details in Profile',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#4F46E5'),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '#${invoice.invoiceNumber}',
              style: pw.TextStyle(fontSize: 14, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildClientInfo(Invoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BILL TO',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                  letterSpacing: 1,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                invoice.clientName,
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceDetails(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailItem('Issue Date', _formatDate(invoice.issueDate)),
        _buildDetailItem(
          'Due Date',
          invoice.dueDate != null ? _formatDate(invoice.dueDate!) : 'N/A',
          isHighlight: true,
        ),
        _buildDetailItem('Payment Method', 'Bank Transfer'),
        _buildDetailItem('Status', _getStatusText(invoice.status)),
      ],
    );
  }

  pw.Widget _buildDetailItem(String label, String value, {bool isHighlight = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: isHighlight ? PdfColors.red : PdfColors.black,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildLineItemsTable(Invoice invoice) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#4F46E5')),
          children: [
            _buildTableHeaderCell('Description'),
            _buildTableHeaderCell('Qty', align: pw.TextAlign.center),
            _buildTableHeaderCell('Rate', align: pw.TextAlign.right),
            _buildTableHeaderCell('Amount', align: pw.TextAlign.right),
          ],
        ),
        // Data rows
        ...invoice.lineItems.map((item) => _buildLineItemRow(item)),
      ],
    );
  }

  pw.Widget _buildTableHeaderCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      ),
    );
  }

  pw.TableRow _buildLineItemRow(LineItem item) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: pw.Text(item.description, style: _textStyle(fontSize: 11)),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: pw.Text(
            '${item.quantity}',
            textAlign: pw.TextAlign.center,
            style: _textStyle(fontSize: 11),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: pw.Text(
            _formatCurrency(item.unitPrice, withSymbol: true),
            textAlign: pw.TextAlign.right,
            style: _textStyle(fontSize: 11),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: pw.Text(
            _formatCurrency(item.total, withSymbol: true),
            textAlign: pw.TextAlign.right,
            style: _textStyle(fontSize: 11, bold: true),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTotals(Invoice invoice) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 200,
        child: pw.Column(
          children: [
            _buildTotalRow('Subtotal', _formatCurrency(invoice.subtotal, withSymbol: true)),
            pw.SizedBox(height: 4),
            _buildTotalRow(
              'Tax (${invoice.taxPercent.toStringAsFixed(0)}%)',
              _formatCurrency(invoice.taxAmount, withSymbol: true),
            ),
            if (invoice.discountAmount > 0) ...[
              pw.SizedBox(height: 4),
              _buildTotalRow(
                'Discount',
                '-${_formatCurrency(invoice.discountAmount, withSymbol: true)}',
              ),
            ],
            pw.SizedBox(height: 8),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total', style: _textStyle(fontSize: 14, bold: true)),
                pw.Text(
                  _formatCurrency(invoice.totalAmount, withSymbol: true),
                  style: _textStyle(fontSize: 18, bold: true, color: PdfColor.fromHex('#4F46E5')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildTotalRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: _textStyle(fontSize: 11, color: PdfColors.grey600)),
        pw.Text(value, style: _textStyle(fontSize: 11)),
      ],
    );
  }

  pw.Widget _buildNotes(Invoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'NOTES',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey600,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(invoice.notes!, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          pw.Text(
            'THIS IS A SECURE ELECTRONIC DOCUMENT GENERATED BY BILLZO',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500, letterSpacing: 0.5),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatCurrency(double amount, {bool withSymbol = false}) {
    final formatted = amount
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return withSymbol ? 'INR $formatted' : formatted;
  }

  String _getStatusText(dynamic status) {
    final statusStr = status.toString().split('.').last;
    return statusStr[0].toUpperCase() + statusStr.substring(1);
  }
}
