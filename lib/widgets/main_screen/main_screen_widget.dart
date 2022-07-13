import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:movieapp/domain/factoryes/screen_factory.dart';
import 'package:movieapp/widgets/main_screen/main_screen_view_model.dart';
import 'package:provider/provider.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  final _screenFactory = ScreenFactory();

  int _selectedTab = 1;

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(
          () {
        _selectedTab = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MovieApp', textAlign: TextAlign.center,),
        actions: [
          IconButton(
              onPressed: () => model.logoutAccount(context),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: LazyLoadIndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeMovieHome(),
          _screenFactory.makeMovieList(),
          _screenFactory.makeMovieFavorite(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_rounded),
            label: 'Films',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
