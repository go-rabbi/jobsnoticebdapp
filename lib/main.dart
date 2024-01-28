import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jobs/bottombar.dart';
import 'package:http/http.dart' as http;
import 'package:jobs/models/favouritepost.dart';
import 'package:jobs/utis/models.dart';

import 'models/appsettings.dart';
import 'models/postcategory.dart';
import 'models/singlepost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostCategoryAdapter());
  Hive.registerAdapter(SinglePostAdapter());
  Hive.registerAdapter(FavouritePostAdapter());
  Hive.registerAdapter(AppsettingsAdapter());
  categories = await Hive.openBox<PostCategory>('category');
  singlePost = await Hive.openBox<SinglePost>('posts');
  favourites = await Hive.openBox<FavouritePost>('favourites');
  settings = await Hive.openBox<Appsettings>('settings');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  bool dark = false;

  @override
  void initState() {
    super.initState();
    if (settings.length == 0) {
      settings.add(Appsettings(dark: false));
    }
    dark = settings.getAt(0)!.dark;
    nextScreen();
  }

  void nextScreen() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs Notice BD',
      debugShowCheckedModeBanner: false,
      theme: dark
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
      home: !loading
          ? BottomBar()
          : Scaffold(
              body: SafeArea(
                child: Center(
                  child: Image.asset(
                    'img/splash.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
    );
  }

  // Future<void> getCategories() async {
  //   var res1 = await http.get(Uri.parse(
  //       'https://jobsnoticebd.com/wp-json/wp/v2/categories?_fields=id,name'));
  //   var cats = jsonDecode(res1.body);
  //
  //   for (var cat in cats) {
  //     List<SinglePost> postss = [];
  //     for (int i = 0; i < singlePost.length; i++) {
  //       var p = singlePost.getAt(i);
  //       if (p!.category == cat['id']) {
  //         postss.add(p);
  //         // print('${p!.category}+${cat['id']}');
  //       }
  //     }
  //     categories.put(
  //         cat['id'], PostCategory(name: cat['name'], singlePosts: postss));
  //   }
  // }

  // void getPosts() async {
  //   int i = 1;
  //   while (true) {
  //     var response = await http.get(Uri.parse(
  //         'https://jobsnoticebd.com/wp-json/wp/v2/posts?page=1&limit=10'));
  //     var data = jsonDecode(response.body);
  //     print(data);
  //     // if (data.length == 0) {
  //     //   break;
  //     // }
  //
  //     // for (var post in data) {
  //     //   print(post);
  //     //   singlePost.put(
  //     //       post['id'],
  //     //       SinglePost(
  //     //         title: post['title']['rendered'],
  //     //         content: post['content']['rendered'],
  //     //         img: post['jetpack_featured_media_url'],
  //     //         category: post['categories'][0],
  //     //       ));
  //     // }
  //     i++;
  //     print('number:${i}');
  //   }
  //   // await getCategories();
  // }
}
