import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/model/book.dart';
import 'package:mankea/page/detail.dart';
import 'package:mankea/page/profile.dart';
import 'package:mankea/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String? name, username;
  List<Book>? books;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  void init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      name = preferences.getString('name');
      username = preferences.getString('username');
    });
  }

  Future<List<Book>?> fetchBooks() async {
    final response = await http.get(ApiConfig.baseUrl);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data buku');
    }

    Map<String, dynamic> body = json.decode(response.body);

    if (!body.containsKey('data')) {
      throw Exception('Gagal memuat data buku');
    }

    List<dynamic> data = body['data'];
    books = data.map((item) => Book.fromJson(item)).toList();

    return books;
  }

  Future<void> refresh() async {
    GlobalKey<RefreshIndicatorState>().currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 0));
    final data = await fetchBooks();

    setState(() {
      books = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Mankea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Color(AppColor.primaryColor),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Mank-Ea',
              style: TextStyle(
                fontSize: FontSize.h1,
                color: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/mankea.png'),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          key: GlobalKey<RefreshIndicatorState>(),
          child: FutureBuilder(
            future: fetchBooks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7.5,
                    vertical: 15,
                  ),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 7.5,
                      ),
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Shimmer.fromColors(
                              baseColor: Color(AppColor.shimmerColor),
                              highlightColor: Colors.white,
                              child: Container(
                                width: 60 * 1.2,
                                height: 90 * 1.2,
                                decoration: ShapeDecoration(
                                  color: Colors.grey[400],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7.5),
                                      bottomLeft: Radius.circular(7.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.5,
                                      horizontal: 10,
                                    ),
                                    child: Shimmer.fromColors(
                                      baseColor: Color(AppColor.shimmerColor),
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: double.infinity,
                                        height: 20,
                                        decoration: ShapeDecoration(
                                          color: Colors.grey[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.5,
                                      horizontal: 10,
                                    ),
                                    child: Shimmer.fromColors(
                                      baseColor: Color(AppColor.shimmerColor),
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height: 15,
                                        decoration: ShapeDecoration(
                                          color: Colors.grey[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2.5,
                                      horizontal: 10,
                                    ),
                                    child: Shimmer.fromColors(
                                      baseColor: Color(AppColor.shimmerColor),
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height: 15,
                                        decoration: ShapeDecoration(
                                          color: Colors.grey[400],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/no-internet.png',
                          height: 180,
                        ),
                      ),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: FontSize.h3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Gagal memuat data buku',
                        style: TextStyle(
                          fontSize: FontSize.h3,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            refresh();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: Color(AppColor.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            'Coba Lagi',
                            style: TextStyle(
                              fontSize: FontSize.h3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (books!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/no-data.png',
                          height: 130,
                        ),
                      ),
                      Text(
                        'Tidak Ditemukan',
                        style: TextStyle(
                          fontSize: FontSize.h3.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Belum ada data buku',
                        style: TextStyle(
                          fontSize: FontSize.h3.toDouble(),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7.5,
                  vertical: 15,
                ),
                itemCount: books!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 7.5,
                    ),
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => Detail(book: books![index]),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(7.5),
                                bottomLeft: Radius.circular(7.5),
                              ),
                              child: FadeInImage(
                                width: 60 * 1.2,
                                height: 90 * 1.2,
                                image: NetworkImage(books![index].cover),
                                placeholder: const AssetImage(
                                    'assets/images/placeholder.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      books![index].title,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: FontSize.h2),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      books![index].author,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: FontSize.h4,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          books![index].rate != null
                                              ? '${books![index].rate}/5'
                                              : 'n/a',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: FontSize.h4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
