class Categoryy {
  Categoryy({
    this.id,
    this.title,
  });

  String? id;
  String? title;

  static List<Categoryy> getAllCategory() {
    List<Categoryy> Categorys = [
      Categoryy(
        id: "1",
        title: 'Majalah',
      ),
      Categoryy(
        id: "2",
        title: 'Buku',
      ),
      Categoryy(
        id: "3",
        title: 'Novel',
      ),
      Categoryy(
        id: "4",
        title: 'Dokumen',
      ),
      Categoryy(
        id: "5",
        title: 'Komsas',
      ),
      Categoryy(
        id: "6",
        title: 'Berita',
      ),
    ];
    return Categorys;
  }
}
