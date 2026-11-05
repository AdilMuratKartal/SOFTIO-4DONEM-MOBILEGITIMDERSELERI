// Gelen bildirimlerin verilerini (id, başlık, içerik, tarih vb.) tek bir nesne altında düzenli tutmak için oluşturduğumuz veri modeli sınıfımız
class BildirimModeli {
  final String id; //her bildirimi birbirinden ayırt edebilmemiz için tuttuğumuz benzersiz kimlik (id) değeri
  final String baslik; //bildirimin başlık metnini sakladığımız String değişken
  final String icerik; //bildirimin detaylı mesaj gövdesini sakladığımız String değişken
  final DateTime tarih; //bildirimin cihaza ulaştığı anı tarih ve saat olarak tutan DateTime değişkeni
  final bool okunduMu; //kullanıcının bildirime tıklayıp okuyup okumadığını takip ettiğimiz boolean bayrak değişken

  const BildirimModeli({
    //sınıfımızın kurucu (constructor) metodu. const tanımlayarak performans optimizasyonu sağlıyoruz
    required this.id, //bildirim oluşturulurken id verilmesini zorunlu tutuyoruz
    required this.baslik, //bildirim başlığının girilmesini zorunlu kılıyoruz
    required this.icerik, //bildirim içeriğinin girilmesini zorunlu kılıyoruz
    required this.tarih, //bildirim zamanının girilmesini zorunlu kılıyoruz
    this.okunduMu = false, //yeni gelen bir bildirim varsayılan olarak henüz okunmadığı için default değerini false veriyoruz
  });

  BildirimModeli copyWith({
    //mevcut nesneyi bozmadan (immutability), sadece istediğimiz alanları güncelleyip yeni bir kopya nesne üretmek için kullandığımız metod
    String? id, //yeni id verilirse onu almak için nullable String
    String? baslik, //yeni başlık verilirse onu almak için nullable String
    String? icerik, //yeni içerik verilirse onu almak için nullable String
    DateTime? tarih, //yeni tarih verilirse onu almak için nullable DateTime
    bool? okunduMu, //örneğin bildirime tıklandığında okundu bilgisini true yapmak için nullable bool
  }) {
    return BildirimModeli(
      //yeni bir BildirimModeli nesnesi oluşturup geri döndürüyoruz
      id: id ?? this.id, //eğer parametreden yeni id geldiyse onu kullan, gelmediyse mevcut olanı koru (??)
      baslik: baslik ?? this.baslik, //yeni başlık varsa kullan, yoksa mevcut başlığı koru
      icerik: icerik ?? this.icerik, //yeni içerik varsa kullan, yoksa mevcut içeriği koru
      tarih: tarih ?? this.tarih, //yeni tarih varsa kullan, yoksa mevcut tarihi koru
      okunduMu: okunduMu ?? this.okunduMu, //yeni okundu bilgisi varsa kullan, yoksa mevcut durumunu koru
    );
  }
}
