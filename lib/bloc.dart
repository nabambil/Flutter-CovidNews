import 'package:CovidNewsMY/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_model.dart';

abstract class Bloc {
  dispose() {
    print('dispose');
  }
}

class NewsBloc extends Bloc {
  // VARIABLES
  final BehaviorSubject<List<Items>> _news = BehaviorSubject<List<Items>>();
  final TextEditingController _searchController = new TextEditingController();
  List<Items> _tempPlacementNews = List<Items>();
  final FocusNode node = FocusNode();

  // INITIALIZER
  NewsBloc() {
    refreshNews();

    _searchController
        .addListener(() => filterSearch(value: _searchController.text));
  }

  // GETTER
  get news$ => _news.stream;
  get controller => _searchController;

  // SETTER
  set news(List<Items> values) => _news.sink.add(values);

  // METHODS
  Future<void> refreshNews() async {
    try {
      final result = await NewsProvider.news;

      news = result.items;
    } catch (e) {}
  }

  // TODO : define functio to load more
  void getNext() {
    print('next 20 item');
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void filterSearch({String value = ''}) async {
    if (value == '' && _tempPlacementNews.length > 0) {
      news = _tempPlacementNews;
      _tempPlacementNews = List<Items>();

      return;
    } else {
      _tempPlacementNews.addAll(_news.value);
    }

    final List<Items> filteredNews = List<Items>();

    _tempPlacementNews.forEach((item) {
      if (item.title.toLowerCase().contains(value.toLowerCase()))
        filteredNews.add(item);
    });

    news = filteredNews;
  }

  void clearField() {
    node.unfocus();
    _searchController.text = '';
  }

  // DISPOSALE
  @override
  dispose() {
    _news.close();
    _searchController.dispose();
    super.dispose();
  }
}
