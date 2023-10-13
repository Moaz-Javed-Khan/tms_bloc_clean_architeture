class Name {
  String? ar;
  String? en;

  Name({
    required this.ar,
    required this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        ar: json["ar"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "ar": ar,
        "en": en,
      };
}
