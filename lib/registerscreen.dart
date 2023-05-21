import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/LoginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Ad/Soyad en az 6 karakter olmalıdır';
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
  final _passwordController2 = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  String email = "", parola = "", name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset("assets/cw-logo.png"),
                Row(
                  children: [
                    Container(
                      height: 120,
                    ),
                    Text(
                        "    Hoşgeldin " +
                            String.fromCharCodes(Runes('\u{1F60A}')),
                        style: TextStyle(
                            fontSize: 20,
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (alinanName) {
                      setState(() {
                        name = alinanName;
                      });
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Ad/Soyad',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    validator: _validateName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (alinanMail) {
                      setState(() {
                        email = alinanMail;
                      });
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
                      labelText: 'E-mail',
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
                    obscureText: _obscureText,
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _obscureText = true;
                            });
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (alinanParola) {
                      setState(() {
                        parola = alinanParola;
                      });
                    },
                    controller: _passwordController2,
                    obscureText: _obscureText2,
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _obscureText2 = true;
                            });
                          });
                        },
                        icon: Icon(
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      saveName(name);
                      addUser();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
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
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Hesabım var/Giriş Yap",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 320,
                    ),
                    Text(
                      "CW ENERJİ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "GÜNEŞTEN ELEKTRİK",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addUser() {
    if (_passwordController.value == _passwordController2.value) {
      if (_formKey.currentState!.validate()) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: parola)
            .then((user) async {
          String? token = await FirebaseMessaging.instance.getToken();
          String uid = user.user!.uid;

          // Token bilgisini users koleksiyonuna kaydet
          FirebaseFirestore.instance.collection('users').doc(uid).set({
            'token': token,
          }).then((value) {
            // Kayıt başarılı olduğunda devam edilecek işlemler
            saveName(name);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (Route<dynamic> route) => false);
          }).catchError((error) {
            // Hata durumunda mesajı göster
            Fluttertoast.showToast(msg: error.toString());
          });
        }).catchError((error) {
          if (error.code == 'email-already-in-use') {
            Fluttertoast.showToast(
              msg: 'Bu mail adresi zaten kullanımda!',
              backgroundColor: Colors.white,
              textColor: Colors.blue.shade900,
            );
          } else {
            Fluttertoast.showToast(msg: error.message);
          }
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Şifreler Uyuşmuyor',
        backgroundColor: Colors.white,
        textColor: Colors.blue.shade900,
      );
    }
  }
}

Future<void> saveName(String name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
}
