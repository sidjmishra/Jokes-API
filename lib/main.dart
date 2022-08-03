import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_name/services.dart';

void main() => runApp(const JokesAPI());

class JokesAPI extends StatelessWidget {
  const JokesAPI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JokesPage(),
    );
  }
}

class JokesPage extends StatefulWidget {
  const JokesPage({Key? key}) : super(key: key);

  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  Future<List<Jokes>> getJokes() async {
    // Request Data
    var data = await http
        .get(Uri.parse("https://api.chucknorris.io/jokes/search?query=cats"));

    // Convert json data
    var jsonData = json.decode(data.body);

    List<Jokes> jokes = [];
    // Data object
    for (var j in jsonData["result"]) {
      Jokes joke = Jokes(j["icon_url"], j["updated_at"], j["value"]);
      jokes.add(joke);
    }

    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Jokes API"),
      ),
      body: FutureBuilder(
        future: getJokes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].value),
                  subtitle: Text(snapshot.data[index].updated_at),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage:
                        NetworkImage(snapshot.data[index].icon_url),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
