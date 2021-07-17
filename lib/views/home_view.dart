import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> articles = [];
  bool isLoading = false;
  bool hasError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : articles.length <= 0
              ? Center(
                  child: RaisedButton(
                    onPressed: () {
                      getArticles();
                    },
                    child: Text(hasError ? "Try Again" : "Get News"),
                  ),
                )
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    DateTime date = DateTime.parse(articles[0]["publishedAt"]);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListTile(
                        leading: articles[0]["urlToImage"] == null
                            ? Text("no image")
                            : Image.network(articles[index]["urlToImage"]),
                        title: Text(
                          articles[index]["title"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text(date.day.toString() +
                                "/" +
                                date.month.toString() +
                                "/" +
                                date.year.toString()),
                            Spacer(),
                            Text(articles[0]["author"])
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  getArticles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String url = "https://newsapi.org/v2/everything?q=tesl"
          "a&from=2021-06-17&sortBy=publishedAt&apiKey"
          "=082709359c204a43b39e0a0d00666aee";
      http.Response response = await http.get(url);
      Map result = json.decode(response.body);

      result["articles"].forEach((element) {
        articles.add(element);
      });
      // articles = result["articles"];
      print(articles.length);
      hasError = false;
    } catch (e) {
      print(e);
      print("has error");
      hasError = true;
    }
    setState(() {
      isLoading = false;
    });
  }
}
