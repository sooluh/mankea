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
  late Book? book = widget.book;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      init();
    }
  }

  init() async {
    final url = Uri.parse('${ApiConfig.baseUrl.toString()}/${book!.id}');
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
      title: book!.title,
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
          backgroundColor: Color(AppColor.primaryColor),
          elevation: 0,
          title: Text(
            'Detail Buku',
            style: TextStyle(
              fontSize: FontSize.h1,
              color: Colors.white,
            ),
          ),
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
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(book!.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  book!.title,
                  style: TextStyle(
                    fontSize: FontSize.h1,
                    color: Color(AppColor.blackColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  book!.author,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      color: Colors.grey,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      book!.rate != null ? '${book!.rate}/5' : 'n/a',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: book!.description != null
                    ? Text(book!.description!)
                    : Column(
                        children: <Widget>[
                          ...List.generate(3, (index) => index.toString())
                              .expand((i) => <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: Color(AppColor.shimmerColor),
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
            ],
          ),
        ),
      ),
    );
  }
}
