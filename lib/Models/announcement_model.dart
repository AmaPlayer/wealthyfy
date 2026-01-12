class AnnouncementItem {
  final String heading;
  final String html;

  AnnouncementItem({
    required this.heading,
    required this.html,
  });

  factory AnnouncementItem.fromMap(Map<String, dynamic> map) {
    String readString(List<String> keys) {
      for (final key in keys) {
        final value = map[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    return AnnouncementItem(
      heading: readString(['heading', 'title', 'announcement_heading']),
      html: readString(['html', 'text', 'body', 'description']),
    );
  }
}

class AnnouncementModel {
  final bool isNew;
  final List<AnnouncementItem> announcements;

  AnnouncementModel({
    required this.isNew,
    required this.announcements,
  });

  factory AnnouncementModel.fromApi(Map<String, dynamic> root) {
    Map<String, dynamic> payload = root;
    if (root['data'] is Map) {
      payload = Map<String, dynamic>.from(root['data']);
    }

    bool readBool(Map<String, dynamic> source, List<String> keys) {
      for (final key in keys) {
        if (!source.containsKey(key)) continue;
        final value = source[key];
        if (value is bool) return value;
        if (value is num) return value != 0;
        if (value is String) {
          final normalized = value.toLowerCase().trim();
          if (normalized == 'true' || normalized == 'yes' || normalized == '1') {
            return true;
          }
          if (normalized == 'false' || normalized == 'no' || normalized == '0') {
            return false;
          }
        }
      }
      return false;
    }

    List<dynamic> rawItems = [];
    final dynamic listValue = payload['announcements'] ??
        payload['announcement_list'] ??
        payload['data'];
    if (listValue is List) {
      rawItems = listValue;
    }

    final items = rawItems
        .whereType<Map>()
        .map((e) => AnnouncementItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    final isNew = readBool(payload, ['new', 'is_new', 'has_new']);
    return AnnouncementModel(isNew: isNew, announcements: items);
  }
}
