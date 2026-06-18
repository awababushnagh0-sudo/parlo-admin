import 'dart:js_interop';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

/// Builds a CSV string from [rows] (first row is typically the header) and
/// triggers a browser download. Web-only (the dashboard's target); a no-op on
/// other platforms.
void downloadCsv(String filename, List<List<String>> rows) {
  final csv = rows.map((row) => row.map(_escape).join(',')).join('\r\n');
  if (!kIsWeb) return;
  final blob = web.Blob(
    [csv.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv;charset=utf-8;'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  web.URL.revokeObjectURL(url);
}

String _escape(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
