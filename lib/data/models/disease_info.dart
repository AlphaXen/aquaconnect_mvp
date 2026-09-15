enum DiseaseInfoScope {
  domestic,
  overseas;

  static DiseaseInfoScope fromKey(String key) =>
      key == 'overseas' ? DiseaseInfoScope.overseas : DiseaseInfoScope.domestic;

  String get key => this == DiseaseInfoScope.overseas ? 'overseas' : 'domestic';

  String get label => this == DiseaseInfoScope.overseas ? '해외 · 참고용' : '국내';
}

class DiseaseInfo {
  const DiseaseInfo({
    required this.id,
    required this.scope,
    required this.species,
    required this.title,
    required this.source,
    required this.publishedAt,
  });

  final String id;
  final DiseaseInfoScope scope;

  /// e.g. "넙치", "새우" — empty string means species-agnostic.
  final String species;
  final String title;
  final String source;
  final DateTime publishedAt;

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) => DiseaseInfo(
        id: json['id'] as String,
        scope: DiseaseInfoScope.fromKey(json['scope'] as String),
        species: json['species'] as String? ?? '',
        title: json['title'] as String,
        source: json['source'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
      );
}
