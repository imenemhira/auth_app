import 'package:auth_app/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController trotinetController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> signInWithTrotinet() async {
    setState(() {
      isLoading = true;
    });

    String trotinetNumber = trotinetController.text.trim();
    String code = codeController.text.trim();

    if (trotinetNumber.isEmpty || code.isEmpty) {
      Fluttertoast.showToast(msg: "Veuillez entrer le numéro et le code");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Générer l'email de connexion
    String email = "${trotinetNumber}@gmail.com";

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: code,
      );

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => Home()),
);
    } catch (e) {
      Fluttertoast.showToast(msg: "Erreur : ${e.toString()}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion Trottinette")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: trotinetController,
              decoration: InputDecoration(labelText: "Numéro de la trottinette"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: "Code d'accès"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signInWithTrotinet,
                    child: Text("Se connecter"),
                  ),
          ],
        ),
      ),
    );
  }
}
