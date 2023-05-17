class MapToXml {
  static const xmlPrefix = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
''';

  static const xmlSuffix = '''
</dict>
</plist>
''';

  static const eol = '\n';

  String convert(Map map) {
    var xml = StringBuffer();

    xml.write(xmlPrefix);
    xml.write(_handleMap(map));
    xml.write(xmlSuffix);

    return xml.toString().trim();
  }

  String _handleMap(Map map) {
    String xml = '';
    map.forEach((key, value) {
      if (value is String) {
        xml += '<key>$key</key>$eol<string>$value</string>';
      }
      if (value is bool) {
        if (value) {
          xml += '<key>$key</key>$eol<true/>';
        } else {
          xml += '<key>$key</key>$eol<false/>';
        }
      }
      if (value is List) {
        xml += '<key>$key</key>$eol<array>';
        value.forEach((element) {
          xml += '$eol<string>$element</string>';
        });
        xml += '$eol</array>';
      }
      if (value is Map) {
        xml += '<key>$key</key>$eol<dict>';
        xml += '$eol${_handleMap(value)}';
        xml += '</dict>';
      }
      xml += eol;
    });
    return xml;
  }
}