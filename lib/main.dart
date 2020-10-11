import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data;
  var items;
  var originalItems;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
    searchController.addListener(filterSearch);
  }

  filterSearch() async {
    var value = searchController.text;
    var newList = [];
    items.forEach((item) {
      if (item['title'].contains(value)) { 
          newList.add(item);
      }  
    });
    setState(() {
      if (value.isEmpty) {
        getData();
      } else {
        items= newList;
      }
    });
  }

  void getData() async {
    http.Response response =
        await http.get("http://api.coronatracker.com/news/trending?limit=20&country=Malaysia&countryCode=MY");
    if (response.statusCode == 200) {
      data = response.body; 
      setState(() {
        items = jsonDecode(data)['items']; 
      });
    } else {
      print(response.statusCode);
    }
  }

  launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
            controller: searchController,
            decoration:
                InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none, 
                  hintText: 'Search'
                  ),
          ),
        ),
      ),
      body: new ListView.builder(itemBuilder: 
      (context, index) {
        var item = items[index];
        return new Padding(
          padding: new EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10.0,
          ) ,
          child: new Card(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  <Widget> [
                new Image.network(item['urlToImage']),
                new Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: new Text(
                  item['title'], 
                  style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: new Text(
                  item['description'], 
                  ),
                ),
                FlatButton(
                onPressed: () {
                  launchURL(item['url']);
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "READ MORE",
                    style: TextStyle(color:  Colors.blue),
                    textAlign: TextAlign.end
                  ),
                )
              )
              ]
            ),
          ),
        );
      },
      itemCount: items  == null ? 0 : items.length,
      ));
  }
}
