import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  const Paragraph({super.key});
  

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Text(
            '''    “Kita teruskan dengan bahagian yang seterusnya, yakni bahagian teknologi siber, Kapten Eng. Silakan.” Komander Zarnoush bergerak ke bahagian seterusnya.

“Baiklah, Komander Zarnoush. Salam sejahtera semua. Di sini saya akan membentangkan maklumat berkenaan teknologi siber.” Kapten Eng memulakan bicaranya dengan kedengaran sedikit loghat cina.

“Setakat hari ini, tidak ada lagi sebarang petanda mengenai ancaman serangan siber mahupun penggodam yang datanganya daripada bahagian dalam stesen angkasa ini. Namun, sensor luar stesen angkasa ini tidak dapat mengesan sebarang tindak balas peranti yang berdekatan. Ini disebabkan kebanyakan stesen angkasa milik negara lain sudah lama meninggalkan orbit bumi.” Kapten Eng menerangkan dengan jelas.

    “Bagaimana pula dengan tanda-tanda radiasi di permukaan bumi?” Bertanya Komander Zarnoush, masih menaruh harapan yang tinggi. ''',
            style: TextStyle(
                color: Color.fromARGB(255, 123, 123, 123),
                fontSize: 15,
                height: 1.5),
          )
        ],
      ),
    );
  }
}
