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
      this.regularPrice,
      this.salePrice,
      this.averageRating,
      this.dateCreated,
      this.dateModified,
      this.ratingCount});

  int? id;
  String? name;
  String? images;
  String? permalink;
  String? description;

  dynamic categories;
  String? linkEpub;
  String? linkPdf;
  String? regularPrice;
  String? salePrice;

  String? dateCreated;
  String? dateModified;
  String? averageRating;
  int? ratingCount;

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
      regularPrice: data['regular_price'],
      salePrice: data['sale_price'],
      averageRating: data['average_rating'],
      dateCreated: data['date_created'],
      dateModified: data['date_modified'],
      ratingCount: data['rating_count'],
    );
  }
}
