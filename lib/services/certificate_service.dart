import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../theme/app_colors.dart';

class CertificateService {
  static String _templateAssetPath(String category) {
    final fileName = category
        .toLowerCase()
        .replaceAll('+', 'plus')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return 'assets/images/${fileName}_template.png';
  }

  // This helper function creates the PDF object without printing it
  static Future<Uint8List> buildPdf({
    required String studentName,
    required String category,
  }) async {
    final pdf = pw.Document();
    
    // Load the background template
    final String assetPath = _templateAssetPath(category);
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final pw.MemoryImage background = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(
                ignoreMargins: true,
                child: pw.Image(background, fit: pw.BoxFit.cover),
              ),
              pw.Positioned(
                top: 260,
                left: 0,
                right: 0,
                child: pw.Center(
                  child: pw.Text(
                    studentName,
                    style: pw.TextStyle(
                      fontSize: 48,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF263238),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  // This function shows the POP-UP
  static void showCertificatePopup(BuildContext context, String name, String category) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              AppBar(
                title: const Text("Your E-Certificate"),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: AppColors.purple,
              ),
              Expanded(
                child: PdfPreview(
                  // This is the "Pop Up" preview
                  build: (format) => buildPdf(studentName: name, category: category),
                  allowPrinting: true,
                  allowSharing: true,
                  initialPageFormat: PdfPageFormat.a4.landscape,
                  pdfFileName: "${category}_Certificate.pdf",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
