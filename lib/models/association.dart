class Association {
  static const String table = 'Associations';
  static const String idColumn = '_id';
  static const String titleColumn = 'title';
  static const String phoneColumn = 'phone';
  static const String mailColumn = 'mail';
  static const String imageUrlColumn = 'imageUrl';

  final String? id;
  String title;
  String phone;
  String mail;
  String imageUrl;

  Association({
    this.id,
    required this.title,
    required this.phone,
    required this.mail,
    required this.imageUrl,
  });

  /* La fonction toMap convertit un objet Association en un Map<String, dynamic> où chaque clé
  est le nom de la colonne dans la base de données et chaque valeur est l'attribut
  correspondant de l'objet Association */
  
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      titleColumn: title,
      phoneColumn: phone,
      mailColumn: mail,
      imageUrlColumn: imageUrl,
    };
  }

  /* fromMap qui permettra de traduire nos fichiers JSON provenant de notre base de données en
  variables pouvant être traitées par notre code. */
  factory Association.fromMap(Map<String, dynamic> map) {
    return Association(
      id: map[idColumn],
      title: map[titleColumn],
      phone: map[phoneColumn],
      mail: map[mailColumn],
      imageUrl: map[imageUrlColumn],
    );
  }
}