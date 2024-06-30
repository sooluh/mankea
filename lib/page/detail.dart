import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/db/model/book.dart';
import 'package:mankea/utils/config.dart';
import 'package:shimmer/shimmer.dart';

class Detail extends StatefulWidget {
  final Book? book;

  const Detail({super.key, required this.book});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<Detail> {
  late Book book = widget.book!;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  init() async {
    final url = Uri.parse('${ApiConfig.baseUrl.toString()}/${book.id}');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data buku');
    }

    Map<String, dynamic> body = json.decode(response.body);

    if (!body.containsKey('data')) {
      throw Exception('Gagal memuat data buku');
    }

    Map<String, dynamic> data = body['data'];

    setState(() {
      book = Book.fromJson(data);
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
      title: book.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_none),
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                // TODO: notif
              },
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: double.infinity,
                      color: Color(AppColor.primaryColor),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FadeInImage(
                              width: 60 * 2.5,
                              height: 90 * 2.5,
                              image: NetworkImage(book.cover),
                              placeholder: const AssetImage(
                                  'assets/images/placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book.title,
                              style: TextStyle(
                                color: Color(AppColor.blackColor),
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.h2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    book.author,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: FontSize.h3,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        book.rate != null
                                            ? '${book.rate}/5'
                                            : 'n/a',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: FontSize.h4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (book.isbn != null)
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 12,
                                      color: Color(AppColor.primaryColor),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'ISBN ${book.isbn}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: FontSize.h3,
                                      ),
                                    ),
                                  ],
                                ),
                              if (book.publisher != null)
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 12,
                                      color: Color(AppColor.primaryColor),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Penerbit ${book.publisher}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: FontSize.h3,
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 12,
                                    color: Color(AppColor.primaryColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Tahun Terbit ${book.publication}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: FontSize.h3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: book.description != null
                              ? Text(
                                  book.description!,
                                  style: TextStyle(fontSize: FontSize.h3),
                                )
                              : Column(
                                  children: <Widget>[
                                    ...List.generate(
                                        3,
                                        (index) => index
                                            .toString()).expand((i) => <Widget>[
                                          Shimmer.fromColors(
                                            baseColor:
                                                Color(AppColor.shimmerColor),
                                            highlightColor: Colors.white,
                                            child: Container(
                                              width: double.infinity,
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
                                          const SizedBox(height: 5),
                                        ]),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
