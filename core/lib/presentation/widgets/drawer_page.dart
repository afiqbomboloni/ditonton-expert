import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:about/about.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:core/presentation/widgets/tab_pager.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.tv_outlined),
              title: Text('Tv'),
              onTap: () {
                Navigator.pushNamed(context, HomeTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, TabPager.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
    );
  }
}