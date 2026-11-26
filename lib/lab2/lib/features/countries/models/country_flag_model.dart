import 'package:trip_planner/core/json/json_read.dart';

class CountryFlag {
  const CountryFlag({required this.emoji, required this.pngUrl});

  factory CountryFlag.fromJson(Map<String, dynamic> json) => CountryFlag(
    emoji: json.req<String>('emoji'),
    pngUrl: json.req<String>('url_png'),
  );

  final String emoji;
  final String pngUrl;

  String get label => emoji.isEmpty ? '🏳️' : emoji;

  CountryFlag copyWith({String? emoji, String? pngUrl}) => CountryFlag(
    emoji: emoji ?? this.emoji,
    pngUrl: pngUrl ?? this.pngUrl,
  );

  Map<String, dynamic> toJson() => {'emoji': emoji, 'url_png': pngUrl};
}
