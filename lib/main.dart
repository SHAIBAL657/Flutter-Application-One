import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "First Mobile Application",
        theme: ThemeData(primaryColor: Colors.teal[900]),
        home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Application")),
      drawer: MyDrawer(),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/img1.jpg")),
          Center(
              child: Text(
            "Hello!!!",
            style: TextStyle(color: Colors.teal[900], fontSize: 50.0),
          ))
        ],
      )),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF004D40),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Image.asset(
                      'assets/images/img1.jpg',
                      height: 50,
                      width: 50,
                    )),
                    Center(
                        child: Text(
                      'Hello!!!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    )),
                  ])),
          Container(
            child: Column(children: [
              ElevatedButton(
                  child: Text('Open route'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SecondRoute()));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(320),
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
              ElevatedButton(
                  child: Text('See List Data'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListData()));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(320),
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
            ]),
            padding: EdgeInsets.all(8.0),
            color: Colors.teal[900],
            alignment: Alignment.center,
          ),
          Container(
            child: ElevatedButton(
                child: Text('Internet Data'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InternetData()));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromWidth(320),
                    primary: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.all(8.0),
            color: Colors.teal[900],
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go back!'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
          ),
        ),
      ),
    );
  }
}

class ListData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List Data"),
        ),
        body: ListDatabase(items: List<String>.generate(10, (i) => 'Item $i')));
  }
}

class ListDatabase extends StatelessWidget {
  final List<String> items;

  ListDatabase({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 20.0),
        height: 200,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          },
        ),
      ),
      Center(
          child: ElevatedButton(
        child: Text('Go back!'),
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
        ),
      )),
    ]);
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Album.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class InternetData extends StatefulWidget {
  InternetData({Key? key}) : super(key: key);

  @override
  _InternetDataState createState() => _InternetDataState();
}

class _InternetDataState extends State<InternetData> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: SizedBox(
            child: FutureBuilder<List<Album>>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Album>? data = snapshot.data;
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 35,
                            color: Colors.teal,
                            child: Center(
                              child: Text(data[index].title),
                            ),
                          );
                        });
                  }
                  return Center(
                      child: Text(
                    "Loading",
                    style: TextStyle(color: Colors.teal[900], fontSize: 50.0),
                  ));
                  // By default, show a loading spinner.
                }),
          ),
        ),
        Center(
            child: ElevatedButton(
          child: Text('Go back!'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
          ),
        )),
      ]),
    );
  }
}
