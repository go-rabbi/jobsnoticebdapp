import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobs/models/favouritepost.dart';
import 'package:jobs/utis/models.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/singlepost.dart';

class SinglePostPage extends StatefulWidget {
  final String title, image, content;
  final int category;

  const SinglePostPage(
      {super.key,
      required this.title,
      required this.image,
      required this.content,
      required this.category});

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  late final String title, image, content;
  late int category;
  late WebViewController controller;
  bool isfav = false;
  int index = -1;
  @override
  void initState() {
    super.initState();
    title = widget.title;
    image = widget.image;
    content = widget.content;
    category = widget.category;
    content.replaceAll('<img', '<img style="width=100%;"');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(content)
      ..enableZoom(true);
    for (int i = 0; i < favourites.length; i++) {
      var post = favourites.getAt(i)!.singlePosts;
      if (post.title == title) {
        isfav = true;
        index = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Add To Favourites',
            onPressed: () async {
              if (isfav) {
                setState(() {
                  favourites.deleteAt(index);
                  isfav = false;
                });
                await Fluttertoast.showToast(
                    msg: "Deleted From Favourites",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                favourites.add(
                  FavouritePost(
                    singlePosts: SinglePost(
                      title: title,
                      img: image,
                      content: content,
                      category: category,
                    ),
                  ),
                );
                setState(() {
                  isfav = true;
                  index = favourites.length - 1;
                });
                await Fluttertoast.showToast(
                    msg: "Added To Favourites",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            icon: Icon(
              isfav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: image),
            InteractiveViewer(
              maxScale: 4,
              minScale: 1,
              clipBehavior: Clip.none,
              child: Container(
                padding: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height * 2,
                width: MediaQuery.of(context).size.width,
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
