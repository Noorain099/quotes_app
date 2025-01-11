import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:myquotes/utils/textstyle.dart';


class QuotesPage extends StatefulWidget {
  final String categoryname;
  const QuotesPage( {super.key,required this.categoryname});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  List quotes = [];
  List authors = [];

  bool isDataThere = false;
  @override
  void initState() {
    super.initState();
    getquotes();
  }

  getquotes() async {
    String url = "https://quotes.toscrape.com/tag/${widget.categoryname}/";
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  isDataThere == false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            :SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
                children: [
                const  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 50),
                    child: flutter.Text(
                      "${widget.categoryname} quotes".toUpperCase(),
                      style: textStyle(28, Colors.white, FontWeight.w600),
                    ),
                  ),
                  isDataThere == false ? const Center(child: CircularProgressIndicator()): ListView.builder(
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
                      },),
                ],
              ),
      ),
    );
  }
}
