import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobs/screens/allposts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  var data = [];
  List allCategories = [6, 7, 8, 21, 1, 9, 0, 10, 11, 12];
  List allCategoryName = [
    'সরকারি চাকরি',
    'বেসরকারি চাকরি',
    'ডিফেন্স চাকরি',
    'ব্যাংক চাকরি',
    'ষধ কোম্পানি চাকরি',
    'এনজিও চাকরি',
    'সকল চাকরির খবর',
    'সাপ্তাহিক চাকরির পত্রিকা',
    'চাকরির পরীক্ষার সময়সূচি',
    'চাকরির পরীক্ষার ফলাফল',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCategories();
  }

  void getCategories() async {
    int i = 1;
    while (true) {
      var res = await http.get(Uri.parse(
          'https://jobsnoticebd.com/wp-json/wp/v2/categories?_fields=id,name&page=${i}'));
      var cats = jsonDecode(res.body);
      print('runtime' + cats.runtimeType.toString());
      if (cats.runtimeType == List<dynamic>) {
        setState(() {
          data.addAll(cats);
          loading = false;
        });
        i++;
      } else {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('img/banner.jpg'),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllPosts(
                            categoryId: allCategories[i],
                            categoryName: allCategoryName[i],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Image.asset('img/${allCategories[i]}.jpg'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
