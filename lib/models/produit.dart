class Produit {
  static const String table = 'Produits';
  static const String idColumn = '_id';
  static const String titleColumn = 'title';
  static const String descriptionColumn = 'description';
  static const String prixColumn = 'prix';
  static const String imageUrlColumn = 'imageUrl';

  String? id;
  String title;
  String description;
  double prix;
  String imageUrl;

  Produit({
    this.id,
    required this.title,
    required this.description,
    required this.prix,
    required this.imageUrl,
  });

  /* La fonction toMap convertit un objet Produit en un Map<String, dynamic> où chaque clé
  est le nom de la colonne dans la base de données et chaque valeur est l'attribut
  correspondant de l'objet Produit */
  
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      titleColumn: title,
      descriptionColumn: description,
      prixColumn: prix,
      imageUrlColumn: imageUrl,
    };
  }

  /* fromMap qui permettra de traduire nos fichiers JSON provenant de notre base de données en
  variables pouvant être traitées par notre code. */
  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map[idColumn],
      title: map[titleColumn],
      description: map[descriptionColumn],
      prix: map[prixColumn],
      imageUrl: map[imageUrlColumn],
    );
  }
}
