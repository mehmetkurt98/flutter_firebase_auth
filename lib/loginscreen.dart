import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/homepage.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/registerscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Geçerli bir email adresi giriniz';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Parolanız en az 6 karakter olmalıdır';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String email = "", parola = "";
  static bool rememberMe = false;
  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      String enteredEmail = _emailController.text;
      List<String>? storedEmails = prefs.getStringList('lastEnteredEmails');
      if (storedEmails == null) {
        storedEmails = [];
      }
      if (!storedEmails.contains(enteredEmail)) {
        storedEmails.insert(0, enteredEmail);
      }
      prefs.setStringList('lastEnteredEmails', storedEmails);
    } else {
      prefs.remove('lastEnteredEmails');
    }
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        List<String>? storedEmails = prefs.getStringList('lastEnteredEmails');
        if (storedEmails != null && storedEmails.isNotEmpty) {
          _emailController.text = storedEmails[0];
        } else {
          _emailController.text = '';
        }
      } else {
        _emailController.text = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Align(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/cw-logo.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.8,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 120,
                      ),
                      FutureBuilder<String?>(
                        future: getName(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Hoşgeldin " +
                                    snapshot.data! +
                                    String.fromCharCodes(Runes('\u{1F60A}')),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Text(
                              "Hoşgeldin " +
                                  String.fromCharCodes(Runes('\u{1F60A}')),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold),
                            );
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (alinanMail) {
                        email = alinanMail;
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                      ),
                      validator: _validateEmail,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (alinanParola) {
                        setState(() {
                          parola = alinanParola;
                        });
                      },
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Parola',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                            _savePreferences();
                          });
                        },
                      ),
                      Text(
                        'Beni Hatırla',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => login(),
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        "Hesabım yok mu? Kaydol",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      if (parola.isEmpty) {
        Fluttertoast.showToast(msg: 'Şifre alanı boş bırakılamaz');
        return;
      }

      String enteredEmail = _emailController.text.trim();
      String enteredPassword = _passwordController.text.trim();

      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: enteredEmail, password: enteredPassword)
          .then((user) {
        // Giriş başarılı olduğunda yapılacak işlemler
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => HomePage(
                      mail: enteredEmail,
                    )),
            (Route<dynamic> route) => false);
      }).catchError((error) {
        String errorMessage = error.toString();
        if (errorMessage.contains('user-not-found')) {
          Fluttertoast.showToast(msg: 'Bu kullanıcı bulunamadı');
        } else if (errorMessage.contains('wrong-password')) {
          Fluttertoast.showToast(msg: 'Geçersiz şifre');
        } else {
          Fluttertoast.showToast(msg: errorMessage);
        }
      });
    }
  }
}

Future<String?> getName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sonuc = prefs.getString('name');
  return sonuc;
}
