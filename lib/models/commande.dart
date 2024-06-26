import 'post.dart';
import 'produit.dart';

class Commande {
  static const String table = 'Commandes';
  static const String idColumn = '_id';
  static const String dateColumn = 'date';
  static const String postColumn = 'post';
  static const String produitsColumn = 'produits';

  final int? id;
  int date;
  Post post;
  List<Produit> produits;

  Commande({
    this.id,
    required this.date,
    required this.post,
    required this.produits,
  });

  /* La fonction toMap convertit un objet Commande en un Map<String, dynamic> où chaque clé
  est le nom de la colonne dans la base de données et chaque valeur est l'attribut
  correspondant de l'objet Commande */
  
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      dateColumn: date,
      postColumn: post.toMap(),
      produitsColumn: produits.map((produit) => produit.toMap()).toList(),
    };
  }

  /* fromMap qui permettra de traduire nos fichiers JSON provenant de notre base de données en
  variables pouvant être traitées par notre code. */
  // factory Commande.fromMap(Map<String, dynamic> map) {
  //   return Commande(
  //     id: map[idColumn],
  //     date: map[dateColumn],
  //     post: Post.fromMap(map[postColumn]),
  //     produits: (map[produitsColumn] as List).map((item) => Produit.fromMap(item)).toList(),
  //   );
  // }
}
