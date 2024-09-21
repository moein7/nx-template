import 'dart:convert';

class CountryEntity {
  final String code;
  final String name;
  final String? alpha2Code;

  const CountryEntity({
    required this.code,
    required this.name,
    this.alpha2Code,
  });

  CountryEntity copyWith({
    String? code,
    String? name,
    String? alpha2Code,
  }) {
    return CountryEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      alpha2Code: alpha2Code ?? this.alpha2Code,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryEntity &&
        other.code == code &&
        other.name == name &&
        other.alpha2Code == alpha2Code;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode ^ alpha2Code.hashCode;

  @override
  String toString() => '$name ($code)';

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'alpha2Code': alpha2Code,
    };
  }

  factory CountryEntity.fromMap(Map<String, dynamic> map) {
    return CountryEntity(
      code: map['code'],
      name: map['name'],
      alpha2Code: map['alpha2Code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryEntity.fromJson(String source) =>
      CountryEntity.fromMap(json.decode(source));
  bool isDomestic() {
    if (code.toUpperCase() == "GB") {
      return true;
    }

    return false;
  }
}
