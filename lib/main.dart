import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc.dart';
import 'constant.dart';
import 'news_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NewsBloc _bloc = NewsBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ground,
      body: StreamBuilder<List<Items>>(
        stream: _bloc.news$,
        builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              children: [
                searchbar,
                if (snapshot.data == null)
                  Expanded(child: Center(child: CircularProgressIndicator())),
                if (snapshot.hasError)
                  Expanded(
                    child: Center(
                        child: InkWell(
                      onTap: () => _bloc.refreshNews(),
                      child: Text(
                        'Please Reload, tap here.',
                        style: TextStyle(color: red, fontSize: 32),
                      ),
                    )),
                  ),
                if (snapshot.hasData)
                  Expanded(
                    child: new RefreshIndicator(
                      onRefresh: _bloc.refreshNews,
                      child: ListView(
                          children: snapshot.data
                              .map(
                                (e) => _BuildTile(
                                  item: e,
                                  onLaunch: () => _bloc.launchUrl(e.url),
                                ),
                              )
                              .toList()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget get searchbar {
    InputDecoration decoration() {
      return InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
        hintText: 'Search',
      );
    }

    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _bloc.controller,
                focusNode: _bloc.node,
                decoration: decoration()),
          ),
          if (_bloc.node.hasFocus)
            IconButton(
              icon: Icon(Icons.close, color: black),
              onPressed: _bloc.clearField,
            ),
        ],
      ),
    );
  }
}

class _BuildTile extends StatelessWidget {
  final Items item;
  final Function onLaunch;

  const _BuildTile({Key key, this.item, this.onLaunch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: new EdgeInsets.symmetric(
        vertical: 9.0,
        horizontal: 16.0,
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new CachedNetworkImage(
            imageUrl: item.urlToImage,
            imageBuilder: (_, child) => Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    color: white,
                    image: DecorationImage(image: child))),
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[50],
              highlightColor: Colors.grey[500],
              child: Container(
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: new Text(
              item.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: new Text(
              item.description,
            ),
          ),
          FlatButton(
            onPressed: onLaunch,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text("READ MORE",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.end),
            ),
          )
        ],
      ),
    );
  }
}
