class FaqItem {
  final String heading;
  final String body;

  FaqItem({
    required this.heading,
    required this.body,
  });

  factory FaqItem.fromMap(Map<String, dynamic> map) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    return FaqItem(
      heading: readString(['heading', 'title', 'question', 'faq_heading']),
      body: readString(['body', 'text', 'answer', 'description', 'faq_text']),
    );
  }
}

class FaqModel {
  final String supportEmail;
  final String supportPhone;
  final List<FaqItem> faqs;

  FaqModel({
    required this.supportEmail,
    required this.supportPhone,
    required this.faqs,
  });

  factory FaqModel.fromApi(Map<String, dynamic> root) {
    Map<String, dynamic> payload = root;
    if (root['data'] is Map) {
      payload = Map<String, dynamic>.from(root['data']);
    }

    String readString(Map<String, dynamic> source, List<String> keys) {
      for (final key in keys) {
        final value = source[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    List<dynamic> rawFaqs = [];
    final dynamic faqsValue = payload['faqs'] ??
        payload['faq'] ??
        payload['faq_list'] ??
        payload['data'];
    if (faqsValue is List) {
      rawFaqs = faqsValue;
    }

    final faqs = rawFaqs
        .whereType<Map>()
        .map((e) => FaqItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return FaqModel(
      supportEmail:
          readString(payload, ['support_email', 'supportEmail', 'email']),
      supportPhone:
          readString(payload, ['support_phone', 'supportPhone', 'phone']),
      faqs: faqs,
    );
  }
}
