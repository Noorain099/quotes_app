import 'dart:ui';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:myquotes/quotes.dart';
import 'package:myquotes/utils/textstyle.dart';

class HomePage extends flutter.StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends flutter.State<HomePage> {
  List<String> categories = ["inspirational", "truth", "life", "humor"];

  List quotes = [];
  List authors = [];

  bool isDataThere = false;
  @override
  void initState() {
    super.initState();
    getquotes();
  }

  getquotes() async {
    String url = "https://quotes.toscrape.com/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");
    // for (int i = 0; i < quotesclass.length; i++) {
    //   quotes.add(quotesclass[i].getElementsByClassName("text")[0].innerHtml);
    // }
    quotes = quotesclass
        .map((element) => element.getElementsByClassName("text")[0].innerHtml)
        .toList();
    authors = quotesclass
        .map((element) => element.getElementsByClassName("author")[0].innerHtml)
        .toList();
    setState(() {
      isDataThere = true;
    });
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Quotes",
          style: textStyle(30, Colors.white, FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: flutter.Padding(
          padding: const EdgeInsets.only(left: 12,right: 12),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: categories.map(
                  (category) {
                    return InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> QuotesPage(categoryname: category))),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 206, 146, 217)
                        ),
                        child: Center(
                            child: Text(
                          category.toUpperCase(),
                          style: textStyle(20, Colors.white, FontWeight.bold),
                        )),
                      ),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 30),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 8,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: flutter.Text(
                              quotes[index],
                              style: textStyle(18, Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: flutter.Text(
                              authors[index],
                              style: textStyle(16, Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
