import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uberlike_flutterlearning/models/association.dart';
import 'package:uberlike_flutterlearning/models/post.dart';
import 'package:uberlike_flutterlearning/models/produit.dart';

class Database {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  final CollectionReference associationCollection =
      FirebaseFirestore.instance.collection('associations');

  Future<List<Post>> getPost() async {
    final List<Post> events = [];
    final QuerySnapshot snapshot = await postCollection.get();
    for (final doc in snapshot.docs) {
      var postData = doc.data() as Map<String, dynamic>;
      var association = await getAssociationById(postData['associationID']);
      var produitsSnapshot =
          await postCollection.doc(doc.id).collection('products').get();
      List<Produit> produits = produitsSnapshot.docs
          .map((doc) => Produit.fromMap(doc.data()))
          .toList();

      events.add(Post.fromMap(postData, association, produits));
    }
    return events;
  }

  void insertPost2(
    String title,
    String description,
    int date,
    String lieu,
    List<Produit> products,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final DocumentReference postRef =
        FirebaseFirestore.instance.collection('posts').doc();
    final post1 = Post(
        id: postRef.id,
        title: title,
        lieu: lieu,
        description: description,
        imageUrl: "https://via.placeholder.com/150",
        associationID: user.uid,
        products: [],
        date: date,
        association: Association(
            title: "Association 1",
            phone: "123456789",
            mail: " asso1@gmail.com",
            imageUrl: "https://www.google.com"),
        datePublication: DateTime.now().millisecondsSinceEpoch);
    await postRef.set(post1.toMap());
    for (final produit in products) {
      final productRef = postRef.collection('produits').doc();
      produit.id = productRef.id;
      await productRef.set(produit.toMap());
    }
  }

  void insertPost() async {
    // final posts = [
    //   Post(
    //       title: "Post 2",
    //       description: "Description 2",
    //       association: Association(
    //           title: "Association 1",
    //           phone: "123456789",
    //           mail: " asso1@gmail.com",
    //           imageUrl: "https://www.google.com"),
    //       imageUrl: "https://via.placeholder.com/150",
    //       products: [
    //         Produit(
    //           title: "Produit 2",
    //           description: "Description 2",
    //           imageUrl: "https://via.placeholder.com/150",
    //           prix: 20.0,
    //         ),
    //         Produit(
    //           title: "Produit 3",
    //           description: "Description 3",
    //           imageUrl: "https://via.placeholder.com/150",
    //           prix: 30.0,
    //         ),
    //       ],
    //       date: DateTime.now().millisecondsSinceEpoch,
    //       datePublication: DateTime.now().millisecondsSinceEpoch),
    //   Post(
    //       title: "Post 3",
    //       description: "Description 3",
    //       imageUrl: "https://via.placeholder.com/150",
    //       association: Association(
    //           title: "Association 1",
    //           phone: "123456789",
    //           mail: " asso1@gmail.com",
    //           imageUrl: "https://www.google.com"),
    //       products: [
    //         Produit(
    //           title: "Produit 4",
    //           description: "Description 4",
    //           imageUrl: "https://via.placeholder.com/150",
    //           prix: 40.0,
    //         ),
    //       ],
    //       date: DateTime.now().millisecondsSinceEpoch,
    //       datePublication: DateTime.now().millisecondsSinceEpoch),
    //   Post(
    //       title: "Post 4",
    //       description: "Description 4",
    //       imageUrl: "https://via.placeholder.com/150",
    //       association: Association(
    //           title: "Association 1",
    //           phone: "123456789",
    //           mail: " asso1@gmail.com",
    //           imageUrl: "https://www.google.com"),
    //       products: [],
    //       date: DateTime.now().millisecondsSinceEpoch,
    //       datePublication: DateTime.now().millisecondsSinceEpoch),
    //   Post(
    //       title: "Post 5",
    //       description: "Description 5",
    //       imageUrl: "https://via.placeholder.com/150",
    //       association: Association(
    //           title: "Association 1",
    //           phone: "123456789",
    //           mail: " asso1@gmail.com",
    //           imageUrl: "https://www.google.com"),
    //       products: [],
    //       date: DateTime.now().millisecondsSinceEpoch,
    //       datePublication: DateTime.now().millisecondsSinceEpoch),
    // ];
    // upload those post with for each a subcollection of products
    // for (final post in posts) {
    //   final DocumentReference postRef =
    //       FirebaseFirestore.instance.collection('posts').doc();
    //   await postRef.set(post.toMap());
    //   for (final produit in post.products) {
    //     await postRef.collection('produits').add(produit.toMap());
    //   }
    // }
  }

  Future<Association> getAssociationById(String id) async {
    var doc = await associationCollection.doc(id).get();
    return Association.fromMap(doc.data() as Map<String, dynamic>);
  }
}
