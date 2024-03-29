import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locasi_app/add_item.dart';
import 'package:locasi_app/home_page.dart';
import 'package:locasi_app/item_list.dart';
import 'package:locasi_app/login_page.dart';
import 'package:locasi_app/lokasi.dart';
import 'package:locasi_app/sign_in.dart';
import 'package:locasi_app/welcome_page.dart';
import 'firebase_options.dart';
import 'item_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    //   home: StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Home();
    //     } else {
    //       return SignIn();
    //     }
    //   },
    // ));
      home: WelcomePage(),
    );
    // home: StreamBuilder<User?>(
    //       stream: FirebaseAuth.instance.authStateChanges(),
    //       builder: (BuildContext context, AsyncSnapshot snapshot) {
    //         if (snapshot.hasError) {
    //           return Text(snapshot.error.toString());
    //         }

    //         if (snapshot.connectionState == ConnectionState.active) {
    //           if (snapshot.hasData) {
    //             return Home();
                
    //           } else {
    //             return SignIn();
    //           }
    //         }

    //         return Center(child: CircularProgressIndicator());
    //       },
    //     ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  CollectionReference _referenceShoppingList =
      FirebaseFirestore.instance.collection('employee');
  late Stream<QuerySnapshot> _streamShoppingItems;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  initState() {
    super.initState();

    _streamShoppingItems = _referenceShoppingList.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.power_settings_new))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamShoppingItems,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.active) {
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                querySnapshot.docs;

            return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document =
                      listQueryDocumentSnapshot[index];
                  return ShoppingListItem(document: document);
                });
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ShoppingListItem extends StatefulWidget {
  const ShoppingListItem({
    Key? key,
    required this.document,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> document;

  @override
  State<ShoppingListItem> createState() => _ShoppingListItemState();
}

class _ShoppingListItemState extends State<ShoppingListItem> {
  bool _purchased = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetails(widget.document.id)));
      },
      title: Text(widget.document['name']),
      subtitle: Text(widget.document['quantity']),
      trailing: Checkbox(
        onChanged: (value) {
          setState(() {
            _purchased = value ?? false;
          });
        },
        value: _purchased,
      ),
    );
  }
}
