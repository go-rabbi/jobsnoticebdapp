import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobs/screens/singlepost.dart';

import '../utis/methods.dart';

class AllPosts extends StatefulWidget {
  final categoryId, categoryName;
  const AllPosts(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  late int catid;
  late String catname;
  var data = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catid = widget.categoryId;
    catname = widget.categoryName;
    getPosts();
  }

  void getPosts() async {
    int i = 1;
    while (true) {
      var res = await http.get(Uri.parse(
          'https://jobsnoticebd.com/wp-json/wp/v2/posts?categories=${catid}&page=${i}'));
      var cats = jsonDecode(res.body);
      print('runtime' + cats.runtimeType.toString());
      if (cats.runtimeType == List<dynamic>) {
        if (cats.length == 0) {
          setState(() {
            loading = false;
          });
          break;
        }
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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(catname),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.length == 0
              ? Container(
                  child: Center(
                    child: Text(
                      'No Posts To Display',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (_, i) {
                        var post = data[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SinglePostPage(
                                          title: post['title']['rendered'],
                                          date: getDate(post['date']),
                                          image: post[
                                              'jetpack_featured_media_url'],
                                          content: post['content']['rendered'],
                                          category: catid,
                                        )));
                          },
                          child: Card(
                            color: Color(0xfffefefe),
                            child: Center(
                              child: Column(
                                children: [
                                  Flexible(
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      fadeInDuration: Duration.zero,
                                      fadeOutDuration: Duration.zero,
                                      imageUrl:
                                          post['jetpack_featured_media_url'],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Text(
                                      post['title']['rendered'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Publish Date: ${getDate(post['date'])}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
    );
  }
}
