import 'package:flutter/material.dart';
import 'package:restaurant_app/models/menus_model.dart';
import 'package:restaurant_app/widgets/menu_listtile.dart';

class MenusScreen extends StatelessWidget {
  const MenusScreen({Key? key, required this.menus}) : super(key: key);

  final Menus menus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                title: const Text('Select Your Menu'),
                centerTitle: true,
                pinned: true,
                snap: true,
                floating: true,
                bottom: TabBar(
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.coffee),
                          SizedBox(width: 10),
                          Text('Drinks'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lunch_dining),
                          SizedBox(width: 10),
                          Text('Foods'),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              buildDrinksPage(context),
              buildFoodsPage(context),
            ],
          )),
    ));
  }

  Widget buildFoodsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: menus.foods
            .map((food) => MenuListTile(
                  imgUrl: 'assets/images/drink.jpg',
                  name: food.name,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Ok',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            }),
                        backgroundColor: Colors.black,
                        content: Text(
                          'Maaf untuk saat ini belum bisa melakukan pembelian',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 14,
                                    color: Colors.amber,
                                  ),
                        ),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget buildDrinksPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: menus.drinks
            .map((drink) => MenuListTile(
                  imgUrl: 'assets/images/drink.jpg',
                  name: drink.name,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                            label: 'Ok',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            }),
                        backgroundColor: Colors.black,
                        content: Text(
                          'Maaf untuk saat ini belum bisa melakukan pembelian',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 14,
                                    color: Colors.amber,
                                  ),
                        ),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
