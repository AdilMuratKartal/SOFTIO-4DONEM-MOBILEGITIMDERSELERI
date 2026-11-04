// Zindan ve Eşya (crafting) sistemi
extension AltinFormatUzantisi on int {
  //sayıyı formallı altın metnine çevir
  String get toAltinKese => "${this} Altin";
}

extension AgirlikFormatuzantisi on double {
  //Ağırlık Kg olarak göster
  String get toAgirlikKg => "${this.toStringAsFixed(1)} kg";
}

// eşyaların nadirlik dereceleri
enum EsyaNadirligi { yaygin, nadir, destansi, efsanevi }
//genel zindan hata sınıflarz

class ZindanException implements Exception {
  final String hataKodu;
  final String mesaj;
  final DateTime zaman = DateTime.now();

  ZindanException(this.hataKodu, this.mesaj);

  @override
  String toString() => "[$hataKodu] $mesaj ($zaman)";
}

//çanta ağırlık aşıldığında hata kodu
class CantadaYerYorException extends ZindanException {
  CantadaYerYorException(double asim)
    : super(
        "ERR__BAG_FULL",
        "Çanta Kapasitesi $asim kg Aşıldı.Eşyayı Alamazsınız",
      );
}

//Yetersiz altın durumdan hata
class YetersizAltinException extends ZindanException {
  YetersizAltinException(int eksik)
    : super("ERR_NO_GOLD", "Bu işlem için $eksik altın daha gerekiyor");
}

//----------------
// Mixler
//----------------

//parçalanıp büyü tozuna dönüşebilen eşyalar
mixin ParcalanabilirYetisi {
  void tozaDonustur(String esyaAdi) {
    print("Demirci $esyaAdi parçalandı ve 5 adet 'Mavi büyü tozu' elde edildi");
  }
}

//ürün basılarak extra güç kazandıran eşyalar
mixin RuneBasmaYetisi {
  void runKusan(String runeTuru) {
    print("Rüm Büyüsü: Eşyaya '$runeTuru' rünü mühürlendi. (+15 Büyü hasarı)");
  }
}

//----------------
//Eşya/item modeli
//----------------

class Esya with ParcalanabilirYetisi, RuneBasmaYetisi {
  final String id;
  final String ad;
  final double agirlik;
  final EsyaNadirligi nadirlik;
  final String? aciklama;
  bool efsunlumu;

  Esya({
    required this.id,
    required this.ad,
    required this.agirlik,
    required this.nadirlik,
    this.aciklama,
    this.efsunlumu = false,
  });

  Esya.kucukCanIskisi()
    : id = "POT-001",
      ad = "Küçük Şifa İksiri",
      agirlik = 0.5,
      nadirlik = EsyaNadirligi.yaygin,
      aciklama = "İçildiğinde anında 30 can yeniler",
      efsunlumu = false;

  //records
  ({String etiket, double carpan, int satisFiyati}) degerlemeYap() {
    final (etiket, carpan, bazFiyat) = switch (nadirlik) {
      EsyaNadirligi.yaygin => ("Yaygın", 1.0, 50),
      EsyaNadirligi.nadir => ("Nadir", 1.0, 200),
      EsyaNadirligi.destansi => ("Destansı", 2.5, 750),
      EsyaNadirligi.efsanevi when efsunlumu => ("Kadim Efsanevi", 5.0, 3000),
      EsyaNadirligi.efsanevi => ("Efsanevi", 4.0, 2000),
    };
    return (
      etiket: etiket,
      carpan: carpan,
      satisFiyati: (bazFiyat * carpan).toInt(),
    );
  }
}

//Oyuncunun Cantası
class OyuncuCantasi {
  final String sahipAdi;
  final double maxAgirlikKapasitesi;
  final List<Esya> _esyalar = [];
  int _altin = 500;

  OyuncuCantasi({required this.sahipAdi, this.maxAgirlikKapasitesi = 25.0});

  int get altin => _altin;

  //altın harcama metodu
  void altinHarca(int miktar) {
    if (miktar > altin) {
      throw YetersizAltinException(miktar - _altin);
    }
    _altin -= miktar;
    print(
      "[Ticaret] : $miktar altın harcandı.Kalan Cüzdan: ${_altin.toAltinKese}",
    );
  } //NORMAL SINIFLARIN METODLARIN SONUNA VİRGÜL KONMAZ

  //Çanta Ağırlığı Hesaplama
  double get mevcutAgirlik => _esyalar.fold(0.0, (acc, e) => acc + e.agirlik);

  //Çantaya Eşya Ekleme
  void esyaEkle(Esya yeniEsya) {
    if (mevcutAgirlik + yeniEsya.agirlik > maxAgirlikKapasitesi) {
      final double asim =
          (mevcutAgirlik + yeniEsya.agirlik) - maxAgirlikKapasitesi;
      throw CantadaYerYorException(asim);
    }
    _esyalar.add(yeniEsya);
    print(
      "[Çanta]: '${yeniEsya.ad}' çantaya yerleştirildi (${yeniEsya.agirlik.toAgirlikKg})",
    );
  }

  //sadece değerli eşyaları listele
  List<Esya> get degerliEsyalar => _esyalar
      .where(
        (e) =>
            e.nadirlik == EsyaNadirligi.destansi ||
            e.nadirlik == EsyaNadirligi.efsanevi,
      )
      .toList();

  //Çanta Döküm Raporu

  void envanterRaporuBas() {
    print("""
    
    =============================================
    Kahraman Envanter Raporu
    Sahip:$sahipAdi | Altın: ${_altin.toAltinKese} | Yük: ${mevcutAgirlik.toAgirlikKg}/${maxAgirlikKapasitesi.toAgirlikKg};
    =============================================
    """);

    for (var esya in _esyalar) {
      final deger = esya.degerlemeYap();
      final aciklamalar = esya.aciklama ?? "Özel Nitelik Belirtilmemiş";
      print(
        "${deger.etiket.padRight(20)} | ${esya.ad.padRight(24)} | ${esya.agirlik.toAgirlikKg.padLeft(8)} | Değer: ${deger.satisFiyati.toAltinKese.padLeft(12)}    Not: ${aciklamalar}",
      );
      
      print("==========================================");
    }
    print("Değerli Esya Sayısı: ${degerliEsyalar.length} Adet");
  }
}

void main() {
  print("Zindan & Envanter Motoru Başlatılıyor....");

  final bool vipUyelik = true;

  //çantamızı oluşturuyoruz
  final canta = OyuncuCantasi(
    sahipAdi: "Elf Okçusu Ayberk",
    maxAgirlikKapasitesi: 20.0,
  );
  final List<Esya> zindanGirisPaketi = [
    Esya.kucukCanIskisi(),
    Esya(
      id: "SWD-101",
      ad: "Gümüş Ejder Kılıcı",
      agirlik: 4.5,
      nadirlik: EsyaNadirligi.destansi,
      aciklama: "Karanlık yaratıklara karşı %25 ek hasar",
      efsunlumu: true,
    ),
    if (vipUyelik)
      Esya(
        id: "RNG-999",
        ad: "Zamanın Sonu Yüzüğü",
        agirlik: 0.2,
        nadirlik: EsyaNadirligi.efsanevi,
        aciklama: "Bekleme Sürelerini %20 azaltır",
        efsunlumu: true,
      ),
  ];

  //Eşyalarıa çantaya ekleme
  for (var esya in zindanGirisPaketi){
    canta.esyaEkle(esya);
  }

  print("Zanaat ve büyü masası");
  final kilic = zindanGirisPaketi[1];
  kilic.runKusan("Kutsal Işık");
  kilic.tozaDonustur(kilic.ad);

  print("Ticaret ve altın harcama");
  try{
    canta.altinHarca(200);
    canta.altinHarca(800);
  } on YetersizAltinException catch(e) {
    print("Hata Yakalandı ${e.mesaj}");
  }catch (e){
    print("Genel hata $e");
  }

  //Kapasite Aşım Testi
  print("Çanta Kapasite Aşımı"); 
  try{
    final devKaya = Esya(id: "BLD-777", ad: "Göktaşı Parçası", agirlik: 28.0, nadirlik: EsyaNadirligi.yaygin);
    canta.esyaEkle(devKaya);
  } on CantadaYerYorException catch(e){
    print("Aşırı yük Engellendi -> ${e.mesaj}");
  }

  canta.envanterRaporuBas();



}
