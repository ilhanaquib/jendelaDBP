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
      this.datecreated,
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

  String? datecreated;
  String? dateModified;
  String? averageRating;
  int? ratingCount;

  // static List<Book> getAllBook() {
  //   List<Book> Books = [
  //     Book(
  //         id: "1A",
  //         name: '100 Persoalan Mengenai Leukemia',
  //         images: 'assets/bookCover2/leukemia.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description:
  //             'Leukemia ialah sejenis kanser darah dan kanser sumsum tulang yang biasa dilihat dalam masyarakat kita. Sebenarnya, leukemia boleh dirawat jika pesakit diberikan rawatan awal. Buku ini mengupas dengan terperinci tentang pelbagai jenis leukemia yang terdapat dalam kamus perubatan, bagaimana penyakit ini berlaku dan tanda klinikal yang perlu diberikan perhatian serius oleh masyarakat.Penerangan yang jelas mengenai segala jenis leukemia dan maklumat terkini mengenai kanser darah yang perlu diketahui oleh pesakit dan masyarakat dihuraikan oleh penulis secara terperinci.',
  //         categories: ["Kesihatan"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 24.00,
  //         sale_price: 16.00,
  //         bookRating: 4.3),
  //     Book(
  //         id: "2A",
  //         name: 'Apresiasi KOMSAS: Antologi Kuingin Berterima Kasih',
  //         images: 'assets/bookCover2/kuingin.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description:
  //             'Buku ini merupakan buku sokongan kepada buku teks KOMSAS Bahasa Melayu Tingkatan 1: Kuingin Berterima Kasih. Buku yang berkonsepkan mesra murid ini dipersembahkan dalam bentuk bimbingan yang mudah. Matlamat penerbitan buku ini secara khusus untuk membimbing pelajar yang akan menjawab soalan peperiksaan dalam Kertas Bahasa Melayu.',
  //         categories: ["Sastera"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 12.00,
  //         sale_price: 8.00,
  //         bookRating: 4.3),
  //     Book(
  //         id: "3A",
  //         name: 'Air Mata Raja',
  //         images: 'assets/bookCover2/airmataraja.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description:
  //             'Karya ini mengisahkan pelbagai peristiwa sebenar yang dialami oleh Datuk Paduka Bendahara Raja Tun Seri Lanang ketika menulis karya besar Sejarah Melayu. Di penghujung kesaksian Tun Seri Lanang, maka bermulalah satu perjalanan liku hidup pewaris Sultan Mahmud Syah, Melaka selama 500 tahun merentasi dimensi masa dan peradaban, saling berputar antara realiti sedar dan impian mistik dunia Melayu.',
  //         categories: ["Buku"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 55.00,
  //         sale_price: 36.00,
  //         bookRating: 4.3),
  //     Book(
  //         id: "4A",
  //         name: 'Apresiasi KOMSAS: Destinasi Impian',
  //         images: 'assets/bookCover2/impian.jpg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description:
  //             'Buku ini merupakan buku sokongan kepada buku teks KOMSAS Bahasa Melayu Tingkatan 1: Destinasi Impian. Buku yang berkonsepkan mesra pelajar ini dipersembahkan dalam bentuk bimbingan yang mudah. Matlamat penerbitan buku ini secara khusus untuk membimbing pelajar yang akan menjawab soalan peperiksaan dalam Kertas Bahasa Melayu.',
  //         categories: ["Sastera"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 15.00,
  //         sale_price: 13.00,
  //         bookRating: 4.3),
  //     Book(
  //         id: "5A",
  //         name: 'Dewan Ekonomi Disember 2020',
  //         images: 'assets/bookCover2/dwanekonomi.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description: 'Synopsis bla bla bla bla bla',
  //         categories: ["Dewan Ekonomi"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 0,
  //         sale_price: 5,
  //         bookRating: 4.3),
  //     Book(
  //         id: "6A",
  //         name: 'Dewan Kosmik Februari 2021',
  //         images: 'assets/bookCover2/dwnkosmik_2.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description:
  //             'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.',
  //         categories: ["Dewan Kosmik"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 0,
  //         sale_price: 5.00,
  //         bookRating: 4.3),
  //     Book(
  //         id: "7A",
  //         name: 'Seri Cicirama Cantik',
  //         images: 'assets/bookCover2/cicirama.jpeg',
  //         author: "Dewan Bahasa dan Pustaka",
  //         description: '..',
  //         categories: ["Kanak-kanak"],
  //         linkEpub:
  //             'https://drive.google.com/uc?export=download&id=1CRsfV5Lo2g7SB1MGTHIX-ue_poHHgak-',
  //         linkPdf:
  //             "https://drive.google.com/uc?export=download&id=1q8hu7L1yeNcNTcydA9yz4aLmgyyGjX6x",
  //         regular_price: 19.00,
  //         sale_price: 15.65,
  //         bookRating: 4.3),
  //   ];
  //   return Books;
  // }

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
      datecreated: data['date_created'],
      dateModified: data['date_modified'],
      ratingCount: data['rating_count'],
    );
  }
}
