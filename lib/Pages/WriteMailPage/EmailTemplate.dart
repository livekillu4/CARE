class EmailTemplate {
  final String name;
  final String betreff;
  final String text;
  final List<String> empfaenger;
  final List<String> cc;

  EmailTemplate({
    required this.name,
    required this.betreff,
    required this.text,
    required this.empfaenger,   
    required this.cc,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'betreff': betreff,
        'text': text,
        'empfaenger': empfaenger,
        'cc': cc,
      };

factory EmailTemplate.fromJson(Map<String, dynamic> json) {
  return EmailTemplate(
    name: json['name'] ?? '',
    betreff: json['betreff'] ?? '',
    text: json['text'] ?? '',
    empfaenger: List<String>.from(json['empfaenger'] ?? []),
    cc: List<String>.from(json['cc'] ?? []),
  );
}
}