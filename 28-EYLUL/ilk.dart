//void seansKaydiOluştur(){
 /*
 //Jsdeki gibi let x = "ahmet"; x=42;
 // print("İlk dersimiz - Dart SDK aktif olmali");
 //1.Açık belirtilen veri tipleri her bir değişkenin veri tipleri girilmeli her bir satır için satırı bitirmek için; yapılmalı bu makine diline daha yakın o yüzden bunlar gerekiyor
 int seansSuresiDakika = 45;
 double seansUcretiTL = 2750.50;
 String uzmanAdi = "Dr Aygen Yildirim";
 bool aktifMi = true;
 
 //2.String intrerpolation
 //JS deki `${}` bunun yerine sadece $degisken işlem varsa ${degisken*2} kullanılır.
 print("Uzman:$uzmanAdi | Süre: $seansSuresiDakika dk | ücret $seansUcretiTL ₺");
 print("KDV dahil (%20) ${seansUcretiTL*1.20} ₺");

 //3. var ile tip çıkarımı
 var tedaviAdi = "Kahve ile Peeling";//String olduğunu otomatik algılıyor bunun tipini string yapmalısın int olamaz diyor
 //tedaviAdi = 99;

 //4. dynamic veri tipini bağımsız kullanabilirsiniz ancak flutterda önerilmez. veri tipi güvenliğin olmaz çünkü
  dynamic serbestKutu = "Lazer Epilasyon";
  serbestKutu = 1000;//izin verilir ama veri tip güvenliğini yok eder
  */
 
 /*//CONST FİNAL TİPLERİ
 //const: Derleme anında değeri belli olan veriler,bellekte tek bir yerde saklanır
 const String KLINIK_ADI = "SoftIto Güzellik Merkezi";
 const double KDV_ORANI = 0.20;

 //const DateTime suankiZaman = DateTime.now();//Hata derleme anında bunu bilemeyiz.

 //final: Çalışma anında hesaplanır, bir kere atandıktan sonra değişmez.
 final DateTime randevuZamani = DateTime.now();
 final String takipKodu = "SOFT-" + randevuZamani.microsecondsSinceEpoch.toString();
 print("Klinik adi: $KLINIK_ADI");
 print("Oluşturulma tarihi: $randevuZamani | Kod: $takipKodu");
*/

/*
// Dartta değişken varsayılan olarak null olamaz bunun yerine null safety operatörleri kullanırız(?,??,!). Null pointer exception
 String zorunluDanisanAdi = "Meltem Demir";
 String? danisanAlerjiNotu;
 print("alerji notu: $danisanAlerjiNotu");
// ifNull operatörü-null ise varsayılan değer atama
 String goruntulenecekNot = danisanAlerjiNotu ?? "Bilinen bir alerjisi yok";// veri varsa danisanAlerjiNotu, yoksa null ise diğer  Bilinen bir alerjisi yok kısmı çalışacak
 print("Rapor: $goruntulenecekNot");
 // null aware
 print("alerji metin uzunluğu: ${danisanAlerjiNotu?.length}");// ? ile biz hata almasını engelliyoruz null ise 
*/

//Klasik sıralı fonksiyon
 double topla(double a, double b) => a + b;

// Modern Dart / Flutter standartları: Named parameters({})
 void seansKaydiOlustur({
    required String danisan,
    required String tedavi,
    required double birimFiyat,
    int seansSayisi = 1, //default değer
    double indirimOrani = 0.0, //default değer
    String? uzmanHekim, //null olabilir
 }){
    final double brutTutar = birimFiyat * seansSayisi;
    final double indirimTutari = brutTutar * (indirimOrani/100);
    final double netTutar = brutTutar - indirimTutari;

    print("""
    
    ===================================

    Softİto Seans Sözleşmesi

    -----------------------------------

    Danışan         :   $danisan
    Tedavi          :   $tedavi (x$seansSayisi Seans)
    Uzman Hekim     :   ${uzmanHekim ?? "Nöbetçi Estetisyen"}
    Brüt Tutar      :   $brutTutar ₺
    İndirim         :   -$indirimTutari ₺ ($indirimOrani)
    Ödenecek Tutar  :   $netTutar


    ===================================

    """);

 }
//}


void main(){

  seansKaydiOlustur(
    danisan: "Sümeyye Muhammed", 
    tedavi: "Medikal Cilt Yenileme", 
    birimFiyat: 10000.0,
    seansSayisi: 20,
    indirimOrani: 20.0,
    uzmanHekim: "Dr.Shahd",
  );

}