import 'package:book_recommend/models/usermodel.dart';
import 'package:book_recommend/providers/provider.dart';
import 'package:book_recommend/screens/about.dart';
import 'package:book_recommend/screens/contactus.dart';
import 'package:book_recommend/screens/login.dart';
import 'package:book_recommend/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

BookProvider bookProvider;

class _HomeScreenState extends State<HomeScreen> {
  Widget _builgDrawer() {
    return Container(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              _buildUserAccountsDrawerHeader(),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed('homeApp');
                },
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.id);
                },
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed('homeApp');
                },
                leading: Icon(
                  Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Favorite',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed('homeApp');
                },
                leading: Icon(
                  Icons.library_books,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'My Library',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed('homeApp');
                },
                leading: Icon(
                  Icons.save,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Saved',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ContactUs.id);
                },
                leading: Icon(
                  Icons.contact_phone,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutScreen.id);
                },
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed('homeApp');
                },
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushNamed(context, LoginScreen.id);
                  });
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = bookProvider.userModelList;
    return Column(
      children: userModel.map((e) {
        return UserAccountsDrawerHeader(
          accountName: Text(
            e.userName,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'pacifico',
              fontSize: 18.0,
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: e.userImage == null
                ? AssetImage('assets/images/userImage.png')
                : NetworkImage(e.userImage),
            radius: 50.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          accountEmail: Text(
            e.userEmail,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void getCallAllFunction() {
    bookProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    bookProvider = Provider.of<BookProvider>(context);
    getCallAllFunction();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _builgDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.sort,
                              size: 30,
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    maxRadius: 50,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      maxRadius: 45,
                                      backgroundImage: AssetImage(
                                        'assets/images/kingicon.png',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 220,
                                    child: ListTile(
                                      title: Text(
                                        'What do you like',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'to read ?',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}