import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_firebase_flutter/services/authservice.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergencies App'),
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.blueAccent,
              child: Text('Sign Out'),
              onPressed: () {
                AuthService().signOut();
              },
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background2.jpg"),
                    fit: BoxFit.cover,
                  )
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget> [
                      IconButton(
                        icon: Image.asset('assets/images/ic_mada-web.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/ic_mcbi-web.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.asset('assets/images/ic_people-web.png'),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

