class Book {
  Book(
      {this.id,
      this.name,
      this.permalink,
      this.images,
      this.description,
      this.categories,
      this.linkEpub,
      this.linkPdf,
      this.regular_price,
      this.sale_price,
      this.average_rating,
      this.date_created,
      this.date_modified,
      this.rating_count});

  int? id;
  String? name;
  String? images;
  String? permalink;
  String? description;

  var categories;
  String? linkEpub;
  String? linkPdf;
  String? regular_price;
  String? sale_price;

  String? date_created;
  String? date_modified;
  String? average_rating;
  int? rating_count;

  factory Book.fromJson(Map<String, dynamic> data) {
    var linkEpub = "";
    var linkPdf = "";

    for (int i = 0; i < data['downloads'].length; i++) {
      if (data['downloads'][i]['name'] == "PDF") {
        linkPdf = data['downloads'][i]['file'];
      } else if (data['downloads'][i]['name'] == "EPUB") {
        linkEpub = data['downloads'][i]['file'];
      }
    }

    return Book(
      id: data['id'],
      name: data['name'],
      permalink: data['permalink'],
      images: data['images'][0]['src'],
      description: data['description'],
      categories: data['categories'],
      linkEpub: linkEpub,
      linkPdf: linkPdf,
      regular_price: data['regular_price'],
      sale_price: data['sale_price'],
      average_rating: data['average_rating'],
      date_created: data['date_created'],
      date_modified: data['date_modified'],
      rating_count: data['rating_count'],
    );
  }
}
