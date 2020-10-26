class News {
  int total;
  List<Items> items;

  News({this.total, this.items});

  News.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int nid;
  String title;
  String description;
  String content;
  String author;
  String url;
  String urlToImage;
  String publishedAt;
  String addedOn;
  String siteName;
  String language;
  String countryCode;
  int status;

  Items(
      {this.nid,
      this.title,
      this.description,
      this.content,
      this.author,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.addedOn,
      this.siteName,
      this.language,
      this.countryCode,
      this.status});

  Items.fromJson(Map<String, dynamic> json) {
    nid = json['nid'];
    title = json['title'];
    description = json['description'];
    content = json['content'];
    author = json['author'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    addedOn = json['addedOn'];
    siteName = json['siteName'];
    language = json['language'];
    countryCode = json['countryCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['author'] = this.author;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['addedOn'] = this.addedOn;
    data['siteName'] = this.siteName;
    data['language'] = this.language;
    data['countryCode'] = this.countryCode;
    data['status'] = this.status;
    return data;
  }
}
