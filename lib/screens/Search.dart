import 'package:book_recommend/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:book_recommend/constant.dart';
import 'package:book_recommend/screens/home.dart';
import 'package:book_recommend/setting/Style/models_providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:book_recommend/models/bookmodel.dart';
import 'package:book_recommend/screens/searchDetails.dart';

class SearchScreen extends StatefulWidget {
  static String id = 'SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int bookcount;
  var jsonresponse;
  String bookname;
  List<Book> booklist = new List();
  Future<void> getBooks(booknamee) async {
    List<Book> books = new List();
    //String url = "http://10.0.2.2:5000/api/get_rec?books={1:\"$booknamee\"}";
    http.Response response = await http.get(
      Uri.https(
        '192.168.1.4:5000',
        "/api/search",
        {'bookName': "\"$booknamee\""},
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        jsonresponse = jsonDecode(response.body);
        bookcount = jsonresponse.length;
      });
      books = bookFromJson(response.body);
      setState(() {
        booklist = books;
      });
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    // return books;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            themeProvider.isLightTheme ? Colors.white : Color(0xFF26242e),
        title: Text(
          'Search',
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: kBackground1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 20.0),
                      hintText: "Enter book name",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                    onChanged: (value) {
                      bookname = value;
                    },
                    onSubmitted: (value) {
                      print(value);
                    },
                  ),
                ),
                SizedBox(height: 30),
                MyButton(
                  name: 'Search',
                  onPressed: () {
                    getBooks(bookname);
                    setState(() {
                      bookcount = null;
                    });
                  },
                ),
                SizedBox(height: 20),
                Container(
                  height: bookcount == null ? 50 : 400,
                  child: bookcount == null
                      ? Text("Loading books...")
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            SearchDetails(booklist[index])));
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
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                booklist[index].bookAuthor,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
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
