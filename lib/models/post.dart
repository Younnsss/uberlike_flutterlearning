import 'package:uberlike_flutterlearning/models/association.dart';
import 'package:uberlike_flutterlearning/models/produit.dart';

class Post {
  static const String table = 'Posts';
  static const String idColumn = '_id';
  static const String titleColumn = 'title';
  static const String descriptionColumn = 'description';
  static const String imageUrlColumn = 'imageUrl';
  static const String dateColumn = 'date';
  static const String datePublicationColumn = 'datePublication';
  static const String associationIDColumn = 'associationID';
  static const String lieuColumn = 'lieu';


  final String id;
  String title;
  String description;
  String imageUrl;
  int date;
  int datePublication;
  Association association;
  List<Produit> products;
  String associationID;
  String lieu;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.lieu,
    required this.date,
    required this.associationID,
    required this.imageUrl,
    required this.datePublication,
    required this.association,
    required this.products,
  });

  /* La fonction toMap convertit un objet Post en un Map<String, dynamic> où chaque clé
  est le nom de la colonne dans la base de données et chaque valeur est l'attribut
  correspondant de l'objet Post */

  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      titleColumn: title,
      descriptionColumn: description,
      imageUrlColumn: imageUrl,
      dateColumn: date,
      datePublicationColumn: datePublication,
      associationIDColumn: associationID,
    };
  }

  /* fromMap qui
  permettra de traduire nos fichiers JSON provenant de notre base de données en
  variables pouvant être traitées par notre code. */
  factory Post.fromMap(Map<String, dynamic> map, Association association, List<Produit> products) {
    return Post(
      id: map[idColumn],
      title: map[titleColumn],
      lieu: map[lieuColumn],
      description: map[descriptionColumn],
      imageUrl: map[imageUrlColumn],
      date: map[dateColumn],
      datePublication: map[datePublicationColumn],
      associationID: map[associationIDColumn],
      association: association,
      products: products,
    );
  }

  void toStringPost(){
    print('Post{id: $id, title: $title, description: $description, imageUrl: $imageUrl, date: $date, datePublication: $datePublication}');
  }
}