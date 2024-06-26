import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mastodon_api/mastodon_api.dart';
import 'package:mastodon_oauth2/mastodon_oauth2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uberlike_flutterlearning/database.dart';
import 'package:uberlike_flutterlearning/models/association.dart';
import 'package:uberlike_flutterlearning/models/post.dart';
import 'package:uberlike_flutterlearning/models/produit.dart';
import 'package:uberlike_flutterlearning/screens/create_post.dart';
import 'package:uberlike_flutterlearning/screens/login.dart';
import 'package:uberlike_flutterlearning/screens/view_post.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          return Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.green[400]!,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: user == null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        },
                                        child: Icon(Icons.account_circle,
                                            color: Colors.white, size: 50)),
                                    const SizedBox(width: 20),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));
                                          },
                                          child: Icon(Icons.exit_to_app,
                                              color: Colors.white, size: 30)),
                                      Text(
                                        user.email!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontSize,
                                          fontWeight: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontWeight,
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .fontFamily,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: SizedBox(
                            width: 200,
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.green[400]!,
                                        size: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Uber'int",
                                        style: TextStyle(
                                          color: Colors.green[400]!,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .fontSize,
                                          fontWeight: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .fontWeight,
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder<List<Post>>(
                        future: Database().getPost(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Post>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...List.generate(snapshot.data!.length,
                                        (int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7),
                                        child: InkWell(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              enableDrag: false,
                                              builder: (BuildContext context) {
                                                return ViewPost(
                                                    post:
                                                        snapshot.data![index]);
                                              },
                                            );
                                          },
                                          child: Material(
                                            elevation: 1,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: Row(
                                                  children: [
                                                    // rounded image
                                                    Container(
                                                      color: Colors.grey,
                                                      width: 80,
                                                      height: 80,
                                                    ),
                                                    // text
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                20, 10, 10, 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .title,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                DecoratedBox(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    //if DateTime.now() is after DateTime.parse(widget.event.date) then color = Colors.red else color = Colors.green
                                                                    color: DateTime.now().isAfter(DateTime
                                                                            .now())
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          2.0,
                                                                      horizontal:
                                                                          5.0,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        DateTime.now().isAfter(DateTime.now())
                                                                            ? "Passé"
                                                                            : "À venir",
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .description,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .calendar_today,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 11,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Flexible(
                                                                  child: Text(
                                                                    "28/05 - 10:00",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .account_circle,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 11,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Flexible(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .association
                                                                        .title,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 11,
                                                                ),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Flexible(
                                                                  child: Text(
                                                                    "Lieu",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   onPressed: () {
                                                    //   },
                                                    //   icon: const Icon(
                                                    //     Icons.arrow_forward_ios,
                                                    //     color: Colors.grey,
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            floatingActionButton: user != null
                ? FloatingActionButton(
                    onPressed: () async {
                      // final products = [
                      //   Produit(
                      //     title: "Produit 2",
                      //     description: "Description 2",
                      //     imageUrl: "https://via.placeholder.com/150",
                      //     prix: 20.0,
                      //   ),
                      //   Produit(
                      //     title: "Produit 3",
                      //     description: "Description 3",
                      //     imageUrl: "https://via.placeholder.com/150",
                      //     prix: 30.0,
                      //   ),
                      // ];
                      // Database().insertPost2(
                      //     "Post2", "Description 2", 123544949498, products);
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => CreatePost()));
                      // final oauth2 = MastodonOAuth2Client(
                      //   // Specify mastodon instance like "mastodon.social"
                      //   instance: 'mastodon-fisa.h.minet.net',
                      //   clientId: 'BirA6YtdpxQn11SFoXc1Rcdyiz6QtgknXz1koR5w3kw',
                      //   clientSecret:
                      //       'OfKIfMd8Coa00RipzMfhCvxbGHTs_hb4zB5bnBm1NQQ',
                      //   redirectUri: 'org.example.oauth://callback/',
                      //   customUriScheme: 'org.example.oauth',
                      // );
                      // final response = await oauth2.executeAuthCodeFlow(
                      //   scopes: [
                      //     Scope.read,
                      //     Scope.write,
                      //   ],
                      // );
                      // print(response.accessToken);

                      final mastodon = MastodonApi(
                        instance: 'mastodon-fisa.h.minet.net',
                        bearerToken:
                            'BzSWhFn_z-wmWSoLbDNzkYq-0ZD2HmqZiVeFnJzWxl4',

                        //! Automatic retry is available when server error or network error occurs
                        //! when communicating with the API.
                        retryConfig: RetryConfig(
                          maxAttempts: 5,
                          jitter: Jitter(
                            minInSeconds: 2,
                            maxInSeconds: 5,
                          ),
                          onExecute: (event) => print(
                            'Retry after ${event.intervalInSeconds} seconds... '
                            '[${event.retryCount} times]',
                          ),
                        ),

                        //! The default timeout is 10 seconds.
                        timeout: Duration(seconds: 20),
                      );
                      try {
                        final getImage = await http
                            .get(Uri.parse('https://picsum.photos/200/300'));
                        final directory = await getTemporaryDirectory();

                        // Step 3: Write the image bytes to a file
                        final imagePath =
                            '${directory.path}/downloadedImage.jpg';
                        final imageFile = File(imagePath);
                        await imageFile.writeAsBytes(getImage.bodyBytes);
                        final uploadImage = await mastodon.v2.media
                            .uploadMedia(file: imageFile);
                        final response =
                            await mastodon.v1.statuses.createStatus(
                          text: 'Toot2!',
                          mediaIds: [uploadImage.data.id],
                        );

                        print(response.rateLimit);
                        print(response.data);
                      } on UnauthorizedException catch (e) {
                        print(e);
                      } on RateLimitExceededException catch (e) {
                        print(e);
                      } on MastodonException catch (e) {
                        print(e.response);
                        print(e.body);
                        print(e);
                      }
                    },
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        });
  }
}
