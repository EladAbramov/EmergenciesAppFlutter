import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_firebase_flutter/services/authservice.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode, name, id;
  bool codeSent = false;
  final databaseReference = Firestore.instance;
  FlutterToast flutterToast;

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("עודכן בהצלחה"),
      ],
    ),
  );
  _showToast() {
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergencies App'),
      ),
      body: Form(
        key: formKey,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Authentication',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: 'Phone number...'),
                  onChanged: (val) {
                    setState(() {
                      this.phoneNo = val;
                    });
                  },
                ),
              ),
              codeSent
                  ? Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration:
                            InputDecoration(hintText: 'Enter sms code...'),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                      ),
                    )
                  : Container(),
              SizedBox(height: 15.0),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Center(
                    child: codeSent ? Text('Login') : Text('Verify'),
                  ),
                  onPressed: () {
                    codeSent
                        ? AuthService().signInWithOTP(smsCode, verificationId)
                        : verifyPhone(phoneNo);
                    saveData();
                    if(DocumentSnapshot!=null) {
                      _showToast();
                    }

                  },
                ),
              ),
              SizedBox(height: 100.0),
              Text(
                'Add more details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  child: Form(
                    autovalidate: true,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Name...'),
                      onChanged: (val) {
                        setState(() {
                          this.name = val;
                        });
                      },
                      validator: (val) {
                        if(val.trim().length < 5 || val.isEmpty) {
                          return 'user name is to short';
                        }else if(val.trim().length > 5) {
                          return 'user name is to long';
                        }else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Id...'),
                  onChanged: (val) {
                    setState(() {
                      this.id = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  void saveData() async {
    await databaseReference.collection("users").document("user").setData({
      'name' : this.name,
      'id': this.id,
      'phone number': this.phoneNo
    });

  }

}
