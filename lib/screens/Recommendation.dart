import 'package:book_recommend/adminPages/services/store.dart';
import 'package:book_recommend/setting/Style/models_providers/theme_provider.dart';
import 'package:book_recommend/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:book_recommend/constant.dart';
import 'package:book_recommend/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:book_recommend/models/apibookmodel.dart';
import 'package:book_recommend/screens/recommendationDetails.dart';

class Recommendation extends StatefulWidget {
  static String id = 'Recommendation';

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  int bookcount;
  var jsonresponse;
  String bookname;
  String queryDec;
  int count = 0;
  List<Apibook> booklist = new List();
  Future<void> callUri(decString) async {
    List<Apibook> books = [];
    print("hello fro calURI");
    print(decString);
    http.Response response = await http.get(
      Uri.https(
        '192.168.1.4:5000',
        "/api/get_rec",
        {'books': "{$decString}"},
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        jsonresponse = jsonDecode(response.body);
        bookcount = jsonresponse.length;
      });
      final books = apibookFromJson(response.body);
      setState(() {
        booklist = books;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }

    return books;
  }

  void getBooks() async {
    //List<Book> books = [];
    //String url = "http://10.0.2.2:5000/api/get_rec?books={1:\"$booknamee\"}";
    //creating  a list of book names
    final _store = Store();
    List<String> bookNames = await _store.loadInterestBooks2();
    String decString;
    int counter = 0;
    for (var name in bookNames) {
      print(name + 'inside loop');
      if (counter != 0) {
        decString += ",";
      }
      if (counter == 0) {
        decString = (counter.toString() + ':' + '\"' + name + '\"');
        counter += 1;
      } else {
        decString = decString + (counter.toString() + ':' + '\"' + name + '\"');
        counter += 1;
      }
    }
    print(decString);
    callUri(decString);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final _store = Store();
    // Interest interest;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            themeProvider.isLightTheme ? Colors.white : Color(0xFF26242e),
        title: Text(
          'Recommendation',
          style: TextStyle(
              color: kBackground2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          },
          icon: Icon(
            Icons.arrow_back,
            color: kBackground2,
            size: 35,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: MyButton(
                    name: 'Get Books',
                    onPressed: () {
                      setState(() {
                        getBooks();
                        bookcount = null;
                      });
                    },
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: bookcount == null ? 50 : 600,
                  child: bookcount == null
                      ? Container()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationDetails(
                                                booklist[index])));
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: booklist[index].imageUrlL == null
                                          ? Container()
                                          : Image(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  booklist[index].imageUrlL),
                                            ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        color: Colors.black87,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                booklist[index].bookTitle,
                                                style: TextStyle(
                                                  color: kBackground2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                booklist[index].bookAuthor,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          itemCount: booklist.length,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
