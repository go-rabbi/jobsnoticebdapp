import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jobs/screens/favelist.dart';
import 'package:jobs/screens/favouritepostpage.dart';
import 'package:jobs/screens/singlepost.dart';

import '../utis/models.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  late var fav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fav = favourites;
    });
    print('length:${fav.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        titleSpacing: 0,
      ),
      body: fav.length == 0
          ? Container(
              child: Center(
                child: Text(
                  'No Posts To Display',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
            )
          : ListView.separated(
              itemCount: fav.length,
              itemBuilder: (_, i) {
                var post = fav.getAt(i)!.singlePosts;
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SinglePostPage(
                                  title: post.title,
                                  image: post.img,
                                  content: post.content,
                                  category: post.category,
                                  date: post.date,
                                )));
                  },
                  onLongPress: () {
                    showAdaptiveDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: ListTile(
                                title: Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showAdaptiveDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('Are you Sure?'),
                                            content: Text(
                                                'Do you really want to delete this item?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No')),
                                              TextButton(
                                                  onPressed: () {
                                                    favourites.deleteAt(i);
                                                    setState(() {
                                                      fav = favourites;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Yes')),
                                            ],
                                          ));
                                },
                              ),
                            ));
                  },
                  title: Text(post.title),
                  leading: CachedNetworkImage(imageUrl: post.img),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
    );
  }
}
