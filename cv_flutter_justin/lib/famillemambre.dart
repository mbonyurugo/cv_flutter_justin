class FamilleMembre {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  FamilleMembre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  factory FamilleMembre.fromJson(Map<String, dynamic> json) {
    return FamilleMembre(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nom: json['nom']?.toString() ?? '',
      postnom: json['postnom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      lieuNaissance: json['lieu_naissance']?.toString() ?? '',
      dateNaissance: json['date_naissance']?.toString() ?? '',
      parente: json['parente']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
    };
  }
}