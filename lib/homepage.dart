import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cw_food_quality_tracking_system_version2/service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';
import 'borsa_service.dart';

class HomePage extends StatefulWidget {
  String mail;
  HomePage({required this.mail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menü öğelerinin listesi
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Ana Sayfa", "icon": Icons.home},
    {"title": "Yemek", "icon": Icons.restaurant},
    {"title": "Anket", "icon": Icons.poll},
    {"title": "İletişim", "icon": Icons.contact_mail},
    {"title": "Çıkış", "icon": Icons.logout},
  ];
  // Menü öğelerinin ListTile widget'ına dönüştürülmesi
  List<Widget> getMenuItems() {
    return menuItems.map((item) {
      return ListTile(
        leading: Icon(
          item["icon"],
          color: Colors.white,
        ),
        title: Text(
          item["title"],
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          if (item["title"] == "Çıkış") {
            _handleLogout();
          }
          // Menü öğesi tıklandığında yapılacak işlemler buraya yazılabilir.
        },
      );
    }).toList();
  }

  void _handleLogout() {
    // Burada SharedPreferences veya diğer yöntemlerle kullanıcının oturumunu sonlandırabilirsiniz.
    // Login sayfasına yönlendirme işlemi:
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  final _service = FirebaseNotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _service.connectNotification();
  }

  String name = "";
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<List<dynamic>> _getMenu() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('yemekler')
        .where('tarih', isEqualTo: formattedDate)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No data found');
      return []; // Return an empty list if no data found
    }

    List<dynamic> adanaMenuList = [];
    snapshot.docs.forEach((doc) {
      final menuList = doc.data()['yemek'];
      adanaMenuList.add(menuList);
    });

    return adanaMenuList; // Return a list of menus containing "adana"
  }

  /////////////////////
  Future<List<dynamic>> _getCorbaMenu() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('yemekler')
        .where('tarih', isEqualTo: formattedDate)
        .get();

    if (snapshot.docs.isEmpty) {
      print('No data found');
      return []; // Return an empty list if no data found
    }

    List<dynamic> corbaMenuList = [];
    snapshot.docs.forEach((doc) {
      final menuList = doc.data()['corba'];
      corbaMenuList.add(menuList);
    });

    return corbaMenuList; // Return a list of menus containing "corba"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text("CW ENERJİ"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
          ),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white)),
                ),
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue.shade900),
                  accountName: Text(name),
                  accountEmail: Text(widget.mail),
                  currentAccountPicture: CircleAvatar(
                    child: Text("M"),
                  ),
                ),
              ),
              // Menü öğeleri
              ...getMenuItems(),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu: $formattedDate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.soup_kitchen, size: 48),
                            SizedBox(height: 8),
                            Text('Çorba'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.restaurant, size: 48),
                            SizedBox(height: 8),
                            Text('Yemek'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.local_drink_outlined, size: 48),
                            SizedBox(height: 8),
                            Text('İçecek'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.cake, size: 48),
                            SizedBox(height: 8),
                            Text('Tatlı'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<dynamic>(
                future: _getMenu(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final menuList = snapshot.data!;
                    return ListView.builder(
                      itemCount: menuList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final menuItem = menuList[index];
                        return ListTile(
                          title: Text(menuItem.toString()),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                },
              ),
            ),
            /////////////
            Expanded(
              child: FutureBuilder<dynamic>(
                future: _getCorbaMenu(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    final menuList = snapshot.data!;
                    return ListView.builder(
                      itemCount: menuList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final menuItem = menuList[index];
                        return ListTile(
                          title: Text(menuItem.toString()),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                },
              ),
            )
            ///////////////////////
          ],
        ),
      ),
    );
  }
}
