import 'dart:convert';

import 'package:xml/xml.dart';

class PlistToMap {
  static final _whitespaceReg = RegExp(r'\s+');
  
  Map parse(String xml) {
    Iterable<XmlElement> elements;
    try {
      var doc = XmlDocument.parse(xml);
      elements = doc.rootElement.children.where(_isElement).cast<XmlElement>();
    } on Error catch (e) {
      throw XmlParserException(e.toString());
    }
    if (elements.isEmpty) {
      throw Exception('Not found plist elements');
    }

    return _handleDict(elements.first);
  }

  bool _isElement(XmlNode node) => node.nodeType == XmlNodeType.ELEMENT;

  Map _handleDict(XmlElement elem) {
    var children = elem.children.where(_isElement).cast<XmlElement>();

    var keys = children
        .where((el) => el.name.local == 'key')
        .map((el) => el.text);

    var values = children
        .where((el) => el.name.local != 'key')
        .map((el) => _handleElem(el));
    return Map.fromIterables(keys, values);
  }

  dynamic _handleElem(XmlElement elem) {
    switch (elem.name.local) {
      case 'string':
        return elem.text;
      case 'real':
        return double.parse(elem.text);
      case 'integer':
        return int.parse(elem.text);
      case 'true':
        return true;
      case 'false':
        return false;
      case 'date':
        return DateTime.parse(elem.text);
      case 'data':
        return base64.decode(elem.text.replaceAll(_whitespaceReg, ''));
      case 'array':
        return elem.children
            .where(_isElement)
            .cast<XmlElement>()
            .map((el) => _handleElem(el))
            .toList();
      case 'dict':
        return _handleDict(elem);
      default:
        return null;
    }
  }
}