import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jobs/screens/favelist.dart';
import 'package:jobs/screens/singlepost.dart';
import 'package:jobs/utis/models.dart';

class FavouritePostPage extends StatefulWidget {
  const FavouritePostPage({super.key});

  @override
  State<FavouritePostPage> createState() => _FavouritePostPageState();
}

class _FavouritePostPageState extends State<FavouritePostPage> {
  late var fav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fav = favourites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('img/banner.jpg'),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                              category: post.category)));
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
        ],
      ),
    );
  }
}
