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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('img/banner.jpg'),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AllPosts(category: data[i])));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Center(
                                    child: Image.asset(
                                        'img/${data[i]['id']}.jpg')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
