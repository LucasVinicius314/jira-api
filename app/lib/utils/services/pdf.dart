import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sure_project_manager/models/issue.dart';
import 'package:sure_project_manager/utils/services/shared_preferences.dart';

Future<void> exportIssues({required List<Issue> issues}) async {
  final fontData = File('assets/fonts/Poppins-Regular.ttf').readAsBytesSync();
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  final document = pw.Document(theme: pw.ThemeData.withFont(base: ttf));

  final title = (await SharedPreferences.title) ?? '';

  final members = (await SharedPreferences.members);

  document.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    build: (context) {
      return [
        pw.Partition(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    title,
                    style: pw.Theme.of(context).header0,
                  ),
                  pw.Divider(),
                  if (members != null) ...[
                    pw.SizedBox(height: 8),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 16),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: members.split(',').map((e) {
                          return pw.Bullet(text: e.trim());
                        }).toList(),
                      ),
                    ),
                  ],
                  pw.SizedBox(height: 24),
                ],
              ),
              ...issues.map((e) {
                final description = e.fields.description?.computePdfWidget();

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      e.fields.summary ?? '',
                      style: pw.Theme.of(context).header3,
                    ),
                    pw.SizedBox(height: 8),
                    if (description != null) description,
                    pw.SizedBox(height: 16),
                  ],
                );
              }),
            ],
          ),
        ),
      ];
    },
  ));

  final bytes = await document.save();

  await FileSaver.instance.saveFile(
    'export',
    bytes,
    'pdf',
    mimeType: MimeType.PDF,
  );
}
