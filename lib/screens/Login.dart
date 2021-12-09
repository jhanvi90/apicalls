import 'package:apicalls/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:device_unlock/device_unlock.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DeviceUnlock deviceUnlock;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceUnlock = DeviceUnlock();
    pressedButton();
  }
  void pressedButton() async {
    var unlocked = false;
    try {
      unlocked = await deviceUnlock.request(
        localizedReason: "We need to check your credentials",
      );
    } on DeviceUnlockUnavailable {
      unlocked = true;
    } on RequestInProgress {
      unlocked = true;
    }

    print(unlocked);
    if (unlocked) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));


    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
