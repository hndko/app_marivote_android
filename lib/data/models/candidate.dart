/// Representasi data calon sesuai spesifikasi PRD Section 10.2
class Candidate {
  final String id;
  final String name;
  final String image;
  final String? description;

  const Candidate({
    required this.id,
    required this.name,
    required this.image,
    this.description,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      if (description != null) 'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Candidate && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Calon yang telah dipasangkan dengan nomor urut acak untuk satu sesi
class CandidateWithNumber {
  final Candidate candidate;
  final int number; // 1 atau 2

  const CandidateWithNumber({
    required this.candidate,
    required this.number,
  });

  /// Nomor urut dengan format dua digit, contoh: "01" atau "02"
  String get formattedNumber => number.toString().padLeft(2, '0');

  /// Label aksesibilitas sesuai UI Kit Section 5.4
  String get accessibilityLabel => 'Nomor urut $formattedNumber';

  factory CandidateWithNumber.fromJson(Map<String, dynamic> json) {
    return CandidateWithNumber(
      candidate: Candidate.fromJson(json['candidate'] as Map<String, dynamic>),
      number: json['number'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidate': candidate.toJson(),
      'number': number,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CandidateWithNumber &&
          runtimeType == other.runtimeType &&
          candidate == other.candidate &&
          number == other.number;

  @override
  int get hashCode => Object.hash(candidate, number);
}
