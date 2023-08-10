class BookContentModel{
  final String title;
  final String chapter;
  final String paragraph;

  BookContentModel({
    required this.title,
    required this.chapter,
    required this.paragraph
  });

  static List<BookContentModel> fetchBookContent(){
    return [
      BookContentModel(title: 'Book Title', chapter: 'Chapter 1: Perjuangan Yang Belum Selesai', paragraph: '''    “Kita teruskan dengan bahagian yang seterusnya, yakni bahagian teknologi siber, Kapten Eng. Silakan.” Komander Zarnoush bergerak ke bahagian seterusnya. “Baiklah, Komander Zarnoush. Salam sejahtera semua. Di sini saya akan membentangkan maklumat berkenaan teknologi siber.” Kapten Eng memulakan bicaranya dengan kedengaran sedikit loghat cina. “Setakat hari ini, tidak ada lagi sebarang petanda mengenai ancaman serangan siber mahupun penggodam yang datanganya daripada bahagian dalam stesen angkasa ini. Namun, sensor luar stesen angkasa ini tidak dapat mengesan sebarang tindak balas peranti yang berdekatan. Ini disebabkan kebanyakan stesen angkasa milik negara lain sudah lama meninggalkan orbit bumi.” Kapten Eng menerangkan dengan jelas. “Bagaimana pula dengan tanda-tanda radiasi di permukaan bumi?” Bertanya Komander Zarnoush, masih menaruh harapan yang tinggi.''')
    ];
  }
}

