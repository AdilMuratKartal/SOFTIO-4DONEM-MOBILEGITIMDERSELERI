import 'dart:ffi';
import 'dart:isolate';

///1-kargoucretihesapla sıkıntı, ISP İHLALİ URUN tipine göre kargo ücreti hesaplanmaz
///2-siparişişlemleri gereğinden fazla işlem yapıyor kargo açma sms,mail,fatura vs. arayüz şişmiş OCP hatası
///3-SiparisYoneticisi db'e kaydetme işlemleri yapıyor,fiyat hesaplıyor bu sınıftada fazla sorumluluk var, SRP
///4-Yeni ödeme türleri geldiğinde çalışan koda dokunulup if-else mi ellenecek yoksa
///5-SiparisYoneticisi içerisinde direk çağırdın sql vs sınıfları bir arayüz dfen gelme direk somut olduğu için
///yani new diyerek oluşturuluyor sonra sen farklı tür bir sql yada sms , mail sağlayıcısı sağladığında ne olacak
///çalışan kod içine dokunmak zorunda kalırız
///EKLEME


class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;

  Urun(this.id, this.ad, this.fiyat, this.stok);

  bool stoktaVarmi() => (stok > 0) ? true : false ;

  void stokDus(){
    if (stoktaVarmi()) stok--;
  } 
}

abstract class Kargolanabilir{
  double kargoUcretiHesapla();
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok);
}

class FizikselUrun extends Urun implements Kargolanabilir{
  FizikselUrun(String id, String ad, double fiyat, int stok)
    : super(id, ad, fiyat, stok);

  @override
  double kargoUcretiHesapla() => 29.90;   
}

abstract class BildirimServisi {
  void gonder(String alici, String icerik);
}

class SmtpMailServisi implements BildirimServisi {
  @override
  void gonder(String alici, String icerik) {
    print("SMTP Mail gonderildi: $alici -> $icerik");
  }
}

class NetgsmSmsServisi implements BildirimServisi {
  @override
  void gonder(String alici, String icerik) {
    print("SMS iletildi: $alici -> $icerik");
  }
}

abstract class KuponStratejisi {
  double indirimUygula(double tutar);
}

class YuzdeIndirimKuponu implements KuponStratejisi {
  final double yuzde;
  YuzdeIndirimKuponu(this.yuzde);

  @override
  double indirimUygula(double tutar) => tutar * (1 - yuzde);
}

class SabitIndirimKuponu implements KuponStratejisi {
  final double miktar;
  SabitIndirimKuponu(this.miktar);

  @override
  double indirimUygula(double tutar) => tutar - miktar;
}

abstract class OdemeYontemi {
  bool islemiYap(double tutar);
}

class KrediKartiOdeme implements OdemeYontemi {
  @override
  bool islemiYap(double tutar) {
    print("$tutar TL Kredi kartindan tahsil edildi.");
    return true;
  }
}

class HavaleOdeme implements OdemeYontemi {
  @override
  bool islemiYap(double tutar) {
    print("$tutar TL Havale kontrol edildi ve onaylandi.");
    return true;
  }
}

class KriptoOdeme implements OdemeYontemi {
  @override
  bool islemiYap(double tutar) {
    print("$tutar TL USDT transferi agda onaylandi.");
    return true;
  }
}

abstract class KargoServisi {
  void kargoGonder(String orderId, String adres);
}

class MngKargoServisi implements KargoServisi {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fisi basildi: $adres (Siparis: $orderId)");
  }
}

abstract class FaturaServisi {
  void faturaOlustur(String orderId, double tutar);
}

class PdfFaturaServisi implements FaturaServisi {
  @override
  void faturaOlustur(String orderId, double tutar) {
    print("Fatura PDF cikarildi: $orderId, Tutar: $tutar TL");
  }
}

abstract class SiparisDAO {
  void siparisKaydet(String orderId, double tutar);
}

class SiparisDAOSqlite implements SiparisDAO {
  @override
  void siparisKaydet(String orderId, double tutar) {
    print("DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }
}

class FiyatHesaplayici {
  static const double varsayilanKdvOrani = 0.20;

  double toplamHesapla(List<Urun> sepet, {KuponStratejisi? kupon}) {
    double urunlerToplami = 0;
    double kargoToplami = 0;

    for (var urun in sepet) {
      urunlerToplami += urun.fiyat;
      if (urun is Kargolanabilir) {
        kargoToplami += urun.kargoUcretiHesapla();
      }
    }

    double indirimliTutar = kupon != null 
        ? kupon.indirimUygula(urunlerToplami) 
        : urunlerToplami;

    double kdvTutari = indirimliTutar * varsayilanKdvOrani;
    return indirimliTutar + kdvTutari + kargoToplami;
  }
}


class MusteriBilgisi {
  final String ad;
  final String email;
  final String telefon;
  final String adres;

  MusteriBilgisi({
    required this.ad,
    required this.email,
    required this.telefon,
    required this.adres,
  });
}

class SiparisTalep {
  final String orderId;
  final List<Urun> sepet;
  final MusteriBilgisi musteri;
  final OdemeYontemi odemeYontemi;
  final KuponStratejisi? kupon;

  SiparisTalep({
    required this.orderId,
    required this.sepet,
    required this.musteri,
    required this.odemeYontemi,
    this.kupon,
  });
}

class SiparisYoneticisi {
  final SiparisDAO _db;
  final BildirimServisi _mailServisi;
  final BildirimServisi _smsServisi;
  final KargoServisi _kargoServisi;
  final FaturaServisi _faturaServisi;
  final FiyatHesaplayici _hesaplayici;

  SiparisYoneticisi({
    required SiparisDAO db,
    required BildirimServisi mailServisi,
    required BildirimServisi smsServisi,
    required KargoServisi kargoServisi,
    required FaturaServisi faturaServisi,
    FiyatHesaplayici? hesaplayici,
  })  : _db = db,
        _mailServisi = mailServisi,
        _smsServisi = smsServisi,
        _kargoServisi = kargoServisi,
        _faturaServisi = faturaServisi,
        _hesaplayici = hesaplayici ?? FiyatHesaplayici();

  void siparisTamamla(SiparisTalep talep) {
    for (var urun in talep.sepet) {
      if (!urun.stoktaVarmi()) {
        print("Hata: ${urun.ad} tukenmis!");
        return;
      }
    }

    double sonTutar = _hesaplayici.toplamHesapla(
      talep.sepet, 
      kupon: talep.kupon,
    );

    bool odemeBasarili = talep.odemeYontemi.islemiYap(sonTutar);
    if (!odemeBasarili) {
      print("Odeme basarisiz oldu. Siparis iptal edildi.");
      return;
    }

   
    for (var urun in talep.sepet) {
      urun.stokDus();
    }

    _db.siparisKaydet(talep.orderId, sonTutar);
    _faturaServisi.faturaOlustur(talep.orderId, sonTutar);
    _mailServisi.gonder(talep.musteri.email, "Sayin ${talep.musteri.ad}, siparisiniz alindi. Tutar: $sonTutar TL");
    _smsServisi.gonder(talep.musteri.telefon, "Siparisiniz onaylandi: ${talep.orderId}");

    bool fizikselUrunVar = talep.sepet.any((u) => u is Kargolanabilir);
    if (fizikselUrunVar) {
      _kargoServisi.kargoGonder(talep.orderId, talep.musteri.adres);
    }
  }
}

void main() {
  final siparisYoneticisi = SiparisYoneticisi(
    db: SqliteVeritabaniServisi(),
    mailServisi: SmtpMailServisi(),
    smsServisi: NetgsmSmsServisi(),
    kargoServisi: MngKargoServisi(),
    faturaServisi: PdfFaturaServisi(),
  );

  var mouse = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5);
  var eKitap = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var musteri = MusteriBilgisi(
    ad: "Selahaddin",
    email: "selahaddin@kodvance.com",
    telefon: "05551112233",
    adres: "Kadikoy / Istanbul",
  );

  var talep = SiparisTalep(
    orderId: "SP-9921",
    sepet: [mouse, eKitap],
    musteri: musteri,
    odemeYontemi: KrediKartiOdeme(),
    kupon: YuzdeIndirimKuponu(0.10), // %10 İndirim
  );

  siparisYoneticisi.siparisTamamla(talep);
}