import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.black),
      home: MyHomePage(title: 'Teste Biométrico de Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Não autorizado";
  List<BiometricType> _availbleBiometricTypes = List<BiometricType>();

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listofBiometrics;
    try {
      listofBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availbleBiometricTypes = listofBiometrics;
    });
  }

  Future<void> _authorizedNow() async {
    bool isauthorized = false;
    try {
      isauthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Autentique-se para completar sua transação",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      if (isauthorized) {
        _authorizedOrNot = "Você está autorizado (Hurrah 😄)";
      } else {
        _authorizedOrNot = "Não autorizado";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Este dispositivo possui um scanner biométrico : $_canCheckBiometric",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RaisedButton(
              onPressed: _checkBiometric,
              textColor: Colors.white,
              child: Text(
                "Verificar biométrico",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.orangeAccent,
              colorBrightness: Brightness.light,
            ),
            Text(
                "Lista de tipos biométricos : ${_availbleBiometricTypes.toString()}",
                style: TextStyle(fontWeight: FontWeight.bold),),
            RaisedButton(
              onPressed: _getListOfBiometricTypes,
              animationDuration: Duration(seconds: 5),
              
              elevation: 10.0,
              textColor: Colors.white,
              child: Text("Lista de tipos biométricos",
              style: TextStyle(fontWeight: FontWeight.bold),),
              color: Colors.red,
              colorBrightness: Brightness.light,
            ),
            Text("autorizado : $_authorizedOrNot",
            style: TextStyle(fontWeight: FontWeight.bold),),
            RaisedButton(
              onPressed: _authorizedNow,
              textColor: Colors.white,
              child: Text("Autorizado Agora",
              style: TextStyle(fontWeight: FontWeight.bold),),
              color: Colors.purple,
              colorBrightness: Brightness.light,
            ),
          ],
        ),
      ),
    );
  }
}