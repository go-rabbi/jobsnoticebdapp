import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late FocusNode _focusNode;
  late TextEditingController controller;
  var data = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    controller = TextEditingController();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(_focusNode);
    // });
  }

  void getPosts() async {
    for (int i = 1; i <= 10; i++) {
      var res = await http.get(Uri.parse(
          'https://jobsnoticebd.com/wp-json/wp/v2/search?search=${controller.text}&page=${i}'));
      var cats = jsonDecode(res.body);
      print('runtime' + cats.toString());
      if (cats.runtimeType == List<dynamic>) {
        for (int j = 0; j < cats.length; j++) {
          var res1 = await http.get(Uri.parse(
              'https://jobsnoticebd.com/wp-json/wp/v2/posts/${cats[j]['id']}'));
          var post = jsonDecode(res1.body);
          setState(() {
            data.add({
              'id': post['id'],
              'title': post['title']['rendered'],
              'image': post['jetpack_featured_media_url'],
            });
            print('data' + data.toString());
          });
        }
      } else {
        break;
      }
    }
    // for (i = 0; i < tempData.length; i++) {
    //   var res1 = await http.get(Uri.parse(
    //       'https://jobsnoticebd.com/wp-json/wp/v2/posts/${tempData[i]['id']}'));
    //   var post = jsonDecode(res1.body);
    //   setState(() {
    //     data.add({
    //       'id': post['id'],
    //       'title': post['title']['rendered'],
    //       'image': post['jetpack_featured_media_url'],
    //     });
    //     print('data' + data.toString());
    //   });
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          TextFormField(
            onEditingComplete: getPosts,
            focusNode: _focusNode,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  var post = data[i];
                  return GestureDetector(
                    child: Card(
                      child: Center(
                        child: Column(
                          children: [
                            Flexible(
                              child: CachedNetworkImage(
                                imageUrl: post['image'],
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                post['title'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
