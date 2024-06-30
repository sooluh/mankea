import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mankea/model/book.dart';
import 'package:mankea/service/notification_service.dart';
import 'package:mankea/utils/config.dart';
import 'package:mankea/widget/invisible_expanded_header.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as in_app;
import 'package:url_launcher/url_launcher.dart' as external_browser;

class Detail extends StatefulWidget {
  final Book? book;

  const Detail({super.key, required this.book});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<Detail> {
  NotificationService notification = NotificationService();
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

  Future<void> goto(String url) async {
    try {
      in_app.launch(
        url,
        customTabsOption: in_app.CustomTabsOption(
          toolbarColor: Color(AppColor.primaryColor),
          showPageTitle: true,
          enableInstantApps: true,
        ),
      );
    } catch (e) {
      final Uri parsed = Uri.parse(url);
      final launched = await external_browser.launchUrl(
        parsed,
        mode: external_browser.LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not open $parsed';
      }
    }
  }

  List<Widget> skeletonDescription() {
    return <Widget>[
      ...List.generate(3, (index) => index.toString()).expand((i) => <Widget>[
            Shimmer.fromColors(
              baseColor: Color(AppColor.shimmerColor),
              highlightColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 15,
                decoration: ShapeDecoration(
                  color: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
          ]),
    ];
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
        primaryColor: Color(AppColor.primaryColor),
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              titleSpacing: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: Color(AppColor.primaryColor),
              elevation: 0,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height / 2.7,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: InvisibleExpandedHeader(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      book.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: FontSize.h1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                background: Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                  width: double.infinity,
                  color: Color(AppColor.primaryColor),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage(
                          width: 60 * 3.2,
                          height: 90 * 3.2,
                          image: NetworkImage(book.cover),
                          placeholder:
                              const AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
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
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    await notification.showNotification(
                      book.title,
                      book.author,
                      {},
                    );
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                        size: 16,
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
                                        size: 16,
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
                                      size: 16,
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
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: FontSize.h3),
                                  )
                                : Column(children: skeletonDescription()),
                          ),
                        ),
                      ),
                      if (book.url?.firstOrNull != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 10,
                          ),
                          child: InkWell(
                            onTap: () async {
                              await goto(book.url?.first);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(AppColor.primaryColor),
                                    Color(AppColor.primaryColor),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Selengkapnya',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.h2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
