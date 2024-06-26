import 'package:flutter/material.dart';
import 'package:uberlike_flutterlearning/models/post.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // Header Button
          //
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 25,
                        )),
                    const SizedBox(width: 20),
                    Text(
                      "Event Detail",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title,
                    style: Theme.of(context).textTheme.headlineLarge!),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          "28 Mai 2021 - 10:00",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          "Lieu",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          post.association.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text("About Event",
                    style: Theme.of(context).textTheme.headlineSmall!),
                SizedBox(height: 20,),
                Text(post.description,
                    style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 40,),
                Center(
                  child: Material(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Faire une commande", style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
