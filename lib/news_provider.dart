import 'package:CovidNewsMY/constant.dart';
import 'package:CovidNewsMY/network.dart';
import 'package:CovidNewsMY/news_model.dart';

class NewsProvider {
  static Future<News> get news async {
    try {
      final Network network = Network(getURL: get_endpoint_news);
      final result = await network.getMethod;

      final News news = News.fromJson(result);

      return news;
    } catch (err) {
      throw err;
    }
  }
}
