//1.Enumları (derleme Zamanı güvenliği)
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }//ileride seanslar için kullanılacak hizmet kategori türlerini yazdığımız sabit değerleri olan özel enum tipi verini kullandık, seansta verilecek hizmet kategorilerini belirledik

enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }//ileride seanslar için kullanılacak seans durumu türlerini yazdığımız sabit değerleri olan özel enum tipi verini kullandık, seansta verilecek seans durumlarını belirledik

enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }//ileride seanslar için kullanılacak ödeme yöntemi türlerini yazdığımız sabit değerleri olan özel enum tipi verini kullandık, seansta verilecek ödeme yöntemi  belirledik

//Danışan (müşteri) Modeli
class Danisan {//her bir müşteri modelini oluşturmak için açtığımız danışan sınıfı bir constructor birde müşterinin bilgilerini özetleyen string bilgi sınıfı var
  final String id;//her bir müşteriye verilen özel string türünde ıd
  final String adSoyad;//her bir müşterinin adını verdiğimiz string
  final String telefon;//müşterinin string türünde telefon numarası
  final bool vipUyeMi;//müşterinin vip olup olmadığını söyleyen bool değer ya true yada false
  final List<String> alerjiler; // boş olabilir ama null olamaz, müşterinin string olarak alerji değerlerini kaydettiğimiz list özel türü, burda liste halinde bulunuyor
  final String? ozelCiltNotu; // Opsiyonel Null olabilir, müşteri hakkında özel cilt notu varmı onu yazdığımız null da olabilen girilmesi zorunlu olmayan bilgi

  const Danisan({//müşterilerimizin bilgilerini kaydetteğimiz sınıfın constructor'ı müşterinin id,adSoyad,telefon değerlerinin verilmesi zorunlu , vip durumunu varsyılan olarak false, alerjisi boş array, özelciltnotunu ise null olarak ayarladık, girilen değerler ile değişebilir ama constructorda veriler girilmezse burdaki default değerleri alıcaktır
    required this.id,//müşterinin sınıfını oluştururken id bilgisini girmesini zorunlu tutuyoruz
    required this.adSoyad,//müşterinin sınıfını oluştururken adSoyad bilgisini girmesini zorunlu tutuyoruz
    required this.telefon,//müşterinin sınıfını oluştururken telefon bilgisini girmesini zorunlu tutuyoruz
    this.vipUyeMi = false,//vip bilgisini varsayılan olarak false ayarladık, constructor'ı çağırdığımızda istediğimiz değerleri girebiliriz
    this.alerjiler = const [],//alerjiler array'ının bilgisini varsayılan olarak boş ayarladık, constructor'ı çağırdığımızda istediğimiz değerleri girebiliriz
    this.ozelCiltNotu,//ozelCiltNotu bilgisini varsayılan olarak null ayarladık, constructor'ı çağırdığımızda istediğimiz değerleri girebiliriz
  });

  bool get hassasCiltMi => alerjiler.isNotEmpty;//ek olarak alerjiler list'inin boş olup olmadığına bakarak, hassasCilt' i olup olmadığını bool olarak belirliyoruz 

  //Bilgi özet kartı
  String get bilgiOzeti {//müşteri bilgilerini özet olarak printleceğimiz String sınıfımız
    final String alerjiBilgisi = alerjiler.isEmpty//alerjiler list'imiz sınıfımız boşmu yok mu kontrou yapıyoruz
        ? "Kayıtlı Alerji Yok"//eğer alerjiler list'i boşsa bu değer alıcak
        : "Alerjiler: ${alerjiler.join(', ')}";//eğer alerjiler list'i dolu ise bu değer alıcak
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";//ozelCiltNotu null kontrolü yapıyoruz null değil ise onun değerini alıyoruz değil ise özel medikal not girilmemiş olarak değer atıyoruz notBilgisi değişkenine atıyoruz
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";//vip üyesi true olursa VİP olursa false ise standart olarak değer verip vipRozeti değişkenine atıyoruz
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";//fonksiyonun dönüş değeri olarak adsoyad bip bilgiler alerjibilgileri notbilgilerini string interpolation ile döndürüyoruz
  }
}

// Seans (randevu) Modeli

class SeansKaydi {//her bir seans modelini oluşturmak için açtığımız SeansKaydi sınıfı, bir constructor birde seansın ücretlerini,indirimtutarını net tutarını hesaplayan getter değişkenleri(yani her nesne.getterDğişkeni çağırıldığında tekrar => içerisinde yazılanlar çalıştırılır.) ile oluşturduğumuz bir sınıftır
  final String seansKodu;//final: değer verildiğinde daha değiştirlemeyen sabit değerdir. seansınkod değerini tutan string değeridir
  final Danisan danisan;//müşteri bilgilerinide almak için danisan nesnesini çağırıyoruz
  final HizmetKategorisi kategori;//hangi türde hizmet alıcaksa enum tipindeki hizmetKategorisini çağırıyoruz
  final String islemAdi;//hangi islem'i yapacağını anlatan string dğerinde islemAdı değişkeninin oluşturuyoruz
  final double birimFiyat;//her bir seansın değerinin taban değerini tutan double(12.45) olarak tutan değişken
  final int seansSayisi;//her bir seans kayıtında kaç tane seans olduğunu söyleyen int değişkeniimz
  final double indirimOrani; // Örn 10.0 seans ücretini hesaplarken uygulayacağımız indirim tutarı ilerde yüze bölerek indirim uygulanacak yüzdeyi bulucağız
  final String? sorumluUzman;//her bir seans kaydında hangi uzman sorumlu ise onu string olarak tutan boşta olabilen string değişkeni
  SeansDurumu durum; //seans durumunu belirten enum sınıfını çağırıyoruz objesini alıyoruz
  OdemeYontemi? odemeTipi;//ödeme durumunu belirten enum sınıfını çağırıyoruz objesini alıyoruz, null değeride olabilir.

  SeansKaydi({//seanskaydi constructor'ımız, sınıfımızın veri tiplerinin hangilerinin zorunlu olup olmadığını, hangilerine varsayılan değer verilip verilmeceğini, hangilerinin boş olup olmadığını belirttiğimiz constructor.
    required this.seansKodu,//seanskodu verimizi zorunlu olarak alıcağımızı belirtiyoruz
    required this.danisan,//danisan verimizi zorunlu olarak alıcağımızı belirtiyoruz
    required this.kategori,//kategori verimizi zorunlu olarak alıcağımızı belirtiyoruz
    required this.islemAdi,//islemAdi verimizi zorunlu olarak alıcağımızı belirtiyoruz
    required this.birimFiyat,//birimFiyat verimizi zorunlu olarak alıcağımızı belirtiyoruz
    this.seansSayisi = 1,//seansSayisi verimizi varsayılan olarak 1 değerini veriyoruz eğer sınıfın nesnesi oluşturulurken eğer değer atanmazsa 1 değerini alır
    this.indirimOrani = 0.0,//indirimOrani verimizi varsayılan olarak 0.0 değerini veriyoruz eğer sınıfın nesnesi oluşturulurken eğer değer atanmazsa 0.0 değerini alır
    this.sorumluUzman,//sorumluUzman verimiz null olabileceğini bu constructor'da da belirtiyoruz.
    this.durum = SeansDurumu.bekliyor,//seans durumun varsayalıan olarak bekliyor olarak ayarladık
    this.odemeTipi,//odemeTipini verimiz null olabileceğini bu constructor'da da belirtiyoruz.
  });

  double get brutTutar => birimFiyat * seansSayisi;//getter özelliğidir. herbir seansKaydi.brutTutar çağırıldığında => ardındaki değerleri hesaplanıp bu değere atanır , double olarak, fonksiyondan farklı olarak () olmadan çağırılır

  double get indirimTutari {//getter özelliğidir. herbir seansKaydi.indirimTutari çağırıldığında => ardındaki değerleri hesaplanıp bu değere atanır , double olarak, fonksiyondan farklı olarak () olmadan çağırılır
    double toplamOran = indirimOrani;//indirime dahada eklencek oranlar için ilk olarak temel indirmOranını atıyoruz
    if (danisan.vipUyeMi) {//danisan'ını vip olup olmadığını sorguladığımız kısım duruma göre toplam indirim oranına 10.0 ekliyoruz
      toplamOran += 10.0;//danisan'ını vip ise toplam indirim oranına 10.0 ekliyoruz
    }
    return brutTutar * (toplamOran / 100.0);//indirimtutarının ne kadar olduğunu hesaplayıp(brututar'ı toplamoranın 100 bölünüp yüzde olarak beliryleip çarığıyoruz) return olarak indirimTutarına döndürüyoruz
  }

  double get netTutar => brutTutar - indirimTutari;//bruttutarı indirim tutarından çıkartarak seansın nettutarını belirledğimiz getter özelliği
}

// Yönetim Servisi

class KlinikYoneticisi {//kliniği yöneten sınıfımız,klinkteki seansları , müşterileri , özeti cirosu vs. klinik bilgelerini hesapladığımız , print le yazdırdığımız metodlarımızın olduğu sınıftır
  final String subeAdi;//kliniğe hangi subeye ait olduğunu söyleyen subeadi değişkenimiz her bir sınıf için sabittir.
  final List<SeansKaydi> _seanslar = [];//klinkteki seansları tutan list tipindeki array değişkenimiz dir .
  final Map<String, Danisan> _danisanRehberi = {};//klinkteki müşterilerin bilgelerini key(string),value(danisan(müşteri)) olarak map türünde olan _danısanRehberi değişkeni oluşturuyoruz  

  KlinikYoneticisi({required this.subeAdi});//constructor fonksiyonumuz sadece subeadı bilgisi bize gereklidir(required). klinkte seans yada danisan bilgleri gelememiş olabilir boştur, istenildiği zaman girilebilir bu bilgilerde.

  //Danışan kaydetme
  void danisanKaydet(Danisan danisan) {//danisan bilgilerini kaydettiğimiz fonksiyonumuz şuanlık sadece bize print olarak yazdırıyoruz, bunun içinde danisan nesnemizi girdi olarak alıcağız
    _danisanRehberi[danisan.id] = danisan;//girdi olarak alınan danisan nesnenimiz klink sınıfımızdaki danisanRehberi map'inden  getirtiyoruz
    print(//bu danisan bilgilerinin özeti olarak adsoyadı vip üyemi değilmi olup olmadığını yazdırdığımız metod
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",//danisan bilgilerinin özet olarak string interpolation yapıyoruz
    );
  }

  void randevuOlustur(SeansKaydi seans) {//seans bilgilerini kullanarak randevu oluşturduğumuz fonksiyonumuz şuanlık sadece bize print olarak yazdırıyoruz, bunun içinde seans nesnemizi girdi olarak alıcağız
    _seanslar.add(seans);//klinikyöneticisi sınıfımızdaki _seanslar liste'mize yeni oluşturucağımzı randevunun bilgilerini seans objesini ekleyiyoruz
    print(//randevu bilgileri özetini yazdırdığımız metod
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",//seanskodu,seanstaki müşteririn adısoyadı , yapılan işlem'in adını yazdırdığımız string
    );
  }

  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {//seansı tamamlamak için oluşturduğumuz sınıf seansın ücretiin ödeme yöntemi ve seans kodu ile seans durumunu tamamladı yapılcak , seans odeme tipi güncellenecek ve print olarak yazdıracak metodu'muz
    for (var seans in _seanslar) {//seansKodu'nu hangi seans'a ait olduğunu bulmak için seanslar listesindeki bütün seansları döndüreceğimiz döngü oluşturuyoruz 
      if (seans.seansKodu == seansKodu) {//her bir seans'ın seanskodunu dışarıdan aldığımız seanskodu ile eşleşiyormu onu kontrol ediyoruz
        seans.durum = SeansDurumu.tamamlandi;//eğer eşleşiyorsa bu seans'ın durumunu tamamladi olarak güncelliyoruz.
        seans.odemeTipi = odeme;//eğer eşleşiyorsa bu seans'ın ödemeTipini girilen ödeme tipi olarak güncelliyoruz.
        print(//tamamlanan seansın özetini yazdırdığımız metod
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",//tamamlanan seansın kodu, nettutarı(boolen olduğu için sadece ilk 2 değerini alıyoruz(12.20->12)) , odeme tipini interpolation olarak birleştiriyoruz. yazdırıyoruz.
        );
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı");//eğer seanskodu ile seans bulamazsak bulamacağınımızı belirttiğimiz print'i yazdırıyoruz
    return;//sadece print işlemlerini yaptırdığımız için boş döndürüyoruz
  }

  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {//seans'ı iptal ettirmek için oluşturduğumuz sınıf, hangi seans olduğunu bulmak için seanskodu ile iptal nedenin yazdıracağımız string iptalNedenimizi aldığımız metod
    for (var seans in _seanslar) {//seansKodu'nu hangi seans'a ait olduğunu bulmak için seanslar listesindeki bütün seansları döndüreceğimiz döngü oluşturuyoruz 
      if (seans.seansKodu == seansKodu) {//her bir seans'ın seanskodunu dışarıdan aldığımız seanskodu ile eşleşiyormu onu kontrol ediyoruz
        seans.durum = SeansDurumu.iptalEdildi;//eğer eşleşiyorsa bu seans'ın durumunu iptalEdildi olarak güncelliyoruz.
        print(//iptal edilen seansın özetini yazdırdığımız metod
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",//hangi seans'ın iptal edileceğini gösteren seansKodu ve iptalNedenini yazdırdımığız string, iptal nedeni boş null ise gerekçe belirtilmedi null değil ise iptalNedenini yazdırdığımız string
        );
        return;//sadece print işlemlerini yaptırdığımız için boş döndürüyoruz
      }
    }
  }

  // Finansal Rapor Metotları(fonksiyonel dart)
  double get toplamTahsilEdilenCiro => _seanslar // klinkteki tüm ciro'yu hesaplayan getter değişkenimiz tamamlanan seansların netTutarını toplayarak hesaplıyoruz
      .where((s) => s.durum == SeansDurumu.tamamlandi)//seans'ların durumları tamamlandi olan seansları where ile döndürüyoruz
      .fold(0.0, (toplam, s) => toplam + s.netTutar);//tamamlanan seansların net tutarlarını fold metodu ile hepsini topluyoruz. fold(başlangıç değeri, callbackfunction(her bir eleman içinde çalıştırılacak fonksiyon)(toplam,s(seans))) 

  double get beklenenPotansiyelCiro => _seanslar // klinkteki potansiyel ciro'yu hesaplayan getter değişkenimiz bekliyor,odadaIslemde olan seansların netTutarını toplayarak hesaplıyoruz
      .where(//seans'ların durumları bekliyor,odadaIslemde olan seansları where ile döndürüyoruz
        (s) =>//her bir seans ta calıcasacak callback function
            s.durum == SeansDurumu.bekliyor || //seans durumu bekliyor durumda olan seansları buluyoruz veya
            s.durum == SeansDurumu.odadaIslemde,////seans durumu odadaIslemde durumda olan seansları buluyoruz
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);//bekliyor,odadaIslemde seansların net tutarlarını fold metodu ile hepsini topluyoruz. fold(başlangıç değeri, callbackfunction(her bir eleman içinde çalıştırılacak fonksiyon)(toplam,s(seans))) 

  // kategori bazlı seans sayıları

  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {//seansları kategorisel olarak ayıran <kategorisi,seanssayısi> olarak map değerinde döndüren , seansları kategori olarak ayıran, ve bu her bir kategorinin kaç sayıda olduğunu söyleyen mapi döndüren fonksiyonumuz
    final Map<HizmetKategorisi, int> dagilim = {};//kategori ve sayılarının tutulduğu verileri tutmak için ilk olarak boş bir şekilde bunun map tipinde boş bir map oluşturuyoruz
    for (var kat in HizmetKategorisi.values) {//hizmetkategorisi enum'undaki tüm değerlerin hepsini döndürüyoruz kategorisel olarak map değişkenimize atamak için
      dagilim[kat] = 0;//her bir kategorideki seans sayısını 0 olarak atıyoruz
    }
    for (var s in _seanslar) {//klinkteki tüm seansları döndüren for döngüsünü açıyoruz
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;//klinkteki tüm seansları hangi kategoride ise map değişkenimizde ki o kategori varsa onun değerini 1 arttırıyoruz yok ise 0 olarak ayarlıyoruz. 
    }
    return dagilim;//bu kategori ve sayısını tutan map değişkenimizi döndürüyoruz
  }

  Set<String> gorevliUzmanKadrosu() {//klinkteki tüm seansların doktorlarını yazdırdığımız metod
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();//kinlikteki seansları map ile dönerek , doktorlarını string tipine dönüştürüp set tipinde döndürüyoruz
  }

  //Uzmansız kalan seanslar
  List<SeansKaydi> uzmansizSeanslariGetir() {//klinkteki tüm seansların uzmansız olan doktorlarını yazdırdığımız metod
    return _seanslar.where((s) => s.sorumluUzman == null).toList();//where ile seanslarda döngü oluşturup seansın doktorunu null olan yani doktoru olmayanları toList ile listeleyip döndürüyoruz 
  }

  void gunSonuRaporuYazdir() {//kliniğin gün sonu raporunu print ile yazdırdığımız metoddur. bu raporda seansların kodları danışanı işlemi tutarı ve durumunu, tüm doktarları cirolar yazdırdığımız metoddur. 
    print("Günlük Seans ve İşlem Çizelgesi");//raporun başlığını yazdırıyoruz
    print("---------------------------------------");//yazıların karışmaması için aralarına önceden tire yazdırıp ayırıyoruz
    print(//gün sonu raporundaki bilgilerinden hangi bilgeleri yazdırcağımız verilerin başlıklarını yazdırıyoruz
      "${'Kod'.padRight((10))} | " //seans kodunu başlığını yazdırıp sağına 7 boşluk bırakıyoruz 3 karakter + 7 boşluk
      "${'Danışan'.padRight(16)} | " //seans danışanını başlığını yazdırıp sağına 9 boşluk bırakıyoruz 7 karakter + 9 boşluk
      "${'İşlem'.padRight(20)} | " //seans işlemini başlığını yazdırıp sağına 15 boşluk bırakıyoruz 5 karakter + 15 boşluk
      "${'Uzman'.padRight(18)} | " //seans uzman başlığını doktorunu yazdırıp sağına 5 boşluk bırakıyoruz 5 karakter + 13 boşluk
      "${'Tutar'.padRight(10)} | " //seans tutarını başlığını yazdırıp sağına 5 boşluk bırakıyoruz 5 karakter + 5 boşluk
      "${'Durum'} | ", //sean durumunu başlığını yazdırıyoruz 
    );
    print("---------------------------------------");//yazıların karışmaması için aralarına önceden tire yazdırıp ayırıyoruz

    for (var s in _seanslar) {//tüm seansların öztini bilgilerini aldırmak için döngüye sokuyoruz
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor";//her seansın doktor bilgilerini alıyoruz
      final String durumRozet = switch (s.durum) {//her seansın durumlarını string olarak kaydediyoruz, switch ile seansdurumu enumundaki değerleri string değerlerini yazdırıyoruz
        SeansDurumu.tamamlandi => "Tamamlandı",//seansdurumu tamamlandi ise string olarak Tamamlandı olarak atıyoruz
        SeansDurumu.odadaIslemde => "İşlemde",//seansdurumu odadaIslemde ise string olarak İşlemde olarak atıyoruz
        SeansDurumu.bekliyor => "Bekliyor",//seansdurumu bekliyor ise string olarak tamamlandı Bekliyor atıyoruz
        SeansDurumu.iptalEdildi => "İptal",//seansdurumu iptalEdildi ise string olarak İptal olarak atıyoruz
      };

      print(//bu seans verilerini yazdırdığımız print metodudur.
        "${s.seansKodu.padRight(10)} | " //seansın kodunu yazdırıp 10 karakter boşluk bırakıyoruz sağa
        "${s.danisan.adSoyad.padRight(10)} | " //seansın müşterinin adısoyadını yazdırıp 10 karakter boşluk bırakıyoruz sağa
        "${s.islemAdi.padRight(10)} | " //seansın islemAdi'ını yazdırıp 10 karakter boşluk bırakıyoruz sağa
        "${uzman.padRight(10)} | " //seansın doktorunu yazdırıp 10 karakter boşluk bırakıyoruz sağa
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | " //seansın netTutar ını yazdırıp 10 karakter boşluk bırakıyoruz sağa
        "$durumRozet", //seansın durumunu yukarıda belirttiğimiz durumRozet'i verisi ile yazdırıyoruz
      );
    }

    print("---------------------------------------");//yazıların karışmaması için aralarına önceden tire yazdırıp ayırıyoruz
    print("Finansal Özet:");//gün sonu raporundaki finanasl özet yapacağımız durumun başlığı
    print(//gün sonundaki net ciroyu yazdırdığımız metod
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",//yukarı belirttiğimiz toplamTahsilEdilenCiro getter değişkenimizi çağırıp toStringAsFixed(2) ile sayının 2 basamağını alıp string olarak yazdırıyoruz 
    );
    print(//gün sonundaki beklenen ciroyu yazdırdığımız metod
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",//yukarı belirttiğimiz beklenenPotansiyelCiro getter değişkenimizi çağırıp toStringAsFixed(2) ile sayının 2 basamağını alıp string olarak yazdırıyoruz 
    );
    print(" * Toplam Seans : ${_seanslar.length} Randevu");//_seanslar.length ile seans listesinin uzunluğunu alıp kaç seans olduğunu yazdırıyoruz
    print("---------------------------------------");//yazıların karışmaması için aralarına önceden tire yazdırıp ayırıyoruz
    print("Aktif Uzmanlar"); //doktorların ismini yazdırmadan önce başlığını yazdırıyoruz
    final uzmanlar = gorevliUzmanKadrosu();//gorevliUzmanKadrosu() ile seanslarımızdaki doktorların Set tipimde(her bir verinin benzersiz olduğu) döndürüyoruz.
    if (uzmanlar.isEmpty) {//seansların doktorları boş mu değilmi ona bakıyoruz
      print("Kayıtlı Uzman Bulunamadı");//eğer boşsa Kayıtlı Uzman Bulunamadı yazdırıyoruz.
    } else {//seansların doktorları boş olmadığı durumlarda ne olacağını yapacağımız else bloğunu aççıyoruz
      print(" ${uzmanlar.join(', ')}");//seansların doktorları boş olmadığı durumlarda hepsini string interpolatin ile her bir doktor ismi ve ", " ile birleştirerek hepsini bütün olarak yazdırıyoruz
    }
    final uzmansizlar = uzmansizSeanslariGetir();//uzmansizSeanslariGetir() ile seanslarımızdaki doktorlar boş olan List tipinde döndürüyoruz, eğer boş ise aynı tipte olacağı için yada aynı veri ile doldurulacağı için list tipinde yapıyoruz 
    if (uzmansizlar.isNotEmpty) {//seansların doktorları olmayanı boş mu değilmi ona bakıyoruz
      print(//doktorları boş olanların sayısını yazdırdığımız metod
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",//doktorları boş olanların sayısını uzmansizlar.length ile alıp string interpolation ile bilgisini veriyoruz 
      );
      for (var u in uzmansizlar) {//doktorları boş olanların her bir elemanını döndürecek döngüyü döndürüyoruz, bunların bilgilerini yazdırıcağız
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");//doktorsuz seansların seanskodunu müşterisinin adsoyadını islemadını yazdırıyoruz printle
      }
    }
    print("---------------------------------------");//yazıların karışmaması için aralarına önceden tire yazdırıp ayırıyoruz
  }
}

void main() {//kodlarımızın çalışmasını başlatan ana fonksiyonumuz main'i açıyoruz. Burada müşterileri seanslarımızın nesnesini oluşturup bunların verileri yukarıda belirttiğimiz metodlarla verilerini, özetlerini yazdırıyoruz.DART SDK ile bu dosyayı çalıştırdığımızda main deki kodlarımızı çalıştıracağımız
  print("Klinik yönetim sistemi başlatılıyor....");//sistemin başladığını belirten yazıyı ekrana yazdırıyoruz
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");//kliniğimizi yönetmesi için subeAdı nı vererek KlinikYoneticisi sınıfından yonetici adında yeni bir nesne oluşturuyoruz

  //danışanları oluşturalım
  final d1 = Danisan(//birinci müşterimizi oluşturmak için d1 adında Danisan nesnesi tanımlıyoruz
    id: "DAN-101",//müşterinin id bilgisini zorunlu olarak veriyoruz
    adSoyad: "Ahmet Yılmaz",//müşterinin adSoyad bilgisini zorunlu olarak veriyoruz
    telefon: "0555 555 55 55",//müşterinin telefon numarasını zorunlu olarak veriyoruz
    vipUyeMi: true,//müşterinin vip durumunu true olarak ayarlıyoruz
    alerjiler: ["Retinol,Aspirin"],//müşterinin alerji listesine alerji değerlerini veriyoruz
    ozelCiltNotu: "Cilt bariyeri hassas",//müşteriye özel cilt notu giriyoruz
  );
  final d2 = Danisan(//ikinci müşterimizi oluşturmak için d2 adında Danisan nesnesi tanımlıyoruz
    id: "DAN-102",//müşterinin id bilgisini zorunlu olarak veriyoruz
    adSoyad: "Ahmet Yılan",//müşterinin adSoyad bilgisini zorunlu olarak veriyoruz
    telefon: "0555 555 55 55",//müşterinin telefon numarasını zorunlu olarak veriyoruz
    vipUyeMi: false,//müşterinin vip olmadığını false vererek ayarlıyoruz
    alerjiler: [],//müşterinin alerjisi olmadığını boş liste vererek ayarlıyoruz
  );
  final d3 = Danisan(//üçüncü müşterimizi oluşturmak için d3 adında Danisan nesnesi tanımlıyoruz
    id: "DAN-103",//müşterinin id bilgisini zorunlu olarak veriyoruz
    adSoyad: "Mehmet Yılmaz",//müşterinin adSoyad bilgisini zorunlu olarak veriyoruz
    telefon: "0555 555 55 55",//müşterinin telefon numarasını zorunlu olarak veriyoruz
    vipUyeMi: true,//müşterinin vip durumunu true olarak ayarlıyoruz
    alerjiler: ["Retinol,Aspirin"],//müşterinin alerji listesine alerji değerlerini veriyoruz
  );
  final d4 = Danisan(//dördüncü müşterimizi oluşturmak için d4 adında Danisan nesnesi tanımlıyoruz
    id: "DAN-104",//müşterinin id bilgisini zorunlu olarak veriyoruz
    adSoyad: "Ahmet Mehmet Yılmaz",//müşterinin adSoyad bilgisini zorunlu olarak veriyoruz
    telefon: "0555 555 55 55",//müşterinin telefon numarasını zorunlu olarak veriyoruz
    vipUyeMi: true,//müşterinin vip durumunu true olarak ayarlıyoruz
    alerjiler: [],//müşterinin alerjisi olmadığını boş liste vererek ayarlıyoruz
    ozelCiltNotu: "Cilt bariyeri hassas",//müşteriye özel cilt notu bilgisini giriyoruz
  );

  yonetici.danisanKaydet(d1);//yonetici nesnemizin danisanKaydet metodunu çağırarak d1 müşterisini klinik rehberine ekliyoruz
  yonetici.danisanKaydet(d2);//yonetici nesnemizin danisanKaydet metodunu çağırarak d2 müşterisini klinik rehberine ekliyoruz
  yonetici.danisanKaydet(d3);//yonetici nesnemizin danisanKaydet metodunu çağırarak d3 müşterisini klinik rehberine ekliyoruz
  yonetici.danisanKaydet(d4);//yonetici nesnemizin danisanKaydet metodunu çağırarak d4 müşterisini klinik rehberine ekliyoruz

  print("Danışan güvenlik kontrolü");//danışan kontrol kısmına geçtiğimizi belirten başlığı yazdırıyoruz
  print(d1.bilgiOzeti);//d1 müşterimizin bilgiOzeti getter'ını çağırarak ekrana özet bilgilerini yazdırıyoruz
  print(d2.bilgiOzeti);//d2 müşterimizin bilgiOzeti getter'ını çağırarak ekrana özet bilgilerini yazdırıyoruz
  print("----------------------------------");//çıktılar karışmasın diye araya çizgi çekiyoruz

  // randevular oluşturuluyor
  final seans1 = SeansKaydi(//birinci randevumuzu oluşturmak için seans1 adında SeansKaydi nesnesi oluşturuyoruz
    seansKodu: "SNS-2026-1",//seansın kodunu zorunlu olarak veriyoruz
    danisan: d1,//seansın müşterisi olarak d1 danışanını veriyoruz
    kategori: HizmetKategorisi.Lipo,//seansın kategorisini enumdan Lipo olarak seçip veriyoruz
    islemAdi: "Lipo gerisini bilmiyorum",//seansın işlem adını zorunlu string olarak giriyoruz
    birimFiyat: 6500.0,//seansın birim fiyatını double olarak veriyoruz
    seansSayisi: 2,//seans adedini 2 olarak giriyoruz
    indirimOrani: 5.0,//uygulanacak temel indirim oranını double olarak veriyoruz
    sorumluUzman: "Sümeyye Arab",//seansla ilgilenecek sorumlu uzmanın adını veriyoruz
  );
  final seans2 = SeansKaydi(//ikinci randevumuzu oluşturmak için seans2 adında SeansKaydi nesnesi oluşturuyoruz
    seansKodu: "SNS-2026-2",//seansın kodunu zorunlu olarak veriyoruz
    danisan: d2,//seansın müşterisi olarak d2 danışanını veriyoruz
    kategori: HizmetKategorisi.ciltYenileme,//seansın kategorisini enumdan ciltYenileme olarak veriyoruz
    islemAdi: "Siverex ile tyüz temizleme",//seansın işlem adını zorunlu string olarak giriyoruz
    birimFiyat: 2500.0,//seansın birim fiyatını double olarak veriyoruz
    seansSayisi: 5,//seans adedini 5 olarak veriyoruz
    indirimOrani: 15.0,//uygulanacak temel indirim oranını double olarak veriyoruz
    sorumluUzman: null,//sorumlu uzman atanmadığı için null olarak bırakıyoruz
  );
  final seans3 = SeansKaydi(//üçüncü randevumuzu oluşturmak için seans3 adında SeansKaydi nesnesi oluşturuyoruz
    seansKodu: "SNS-2026-3",//seansın kodunu zorunlu olarak veriyoruz
    danisan: d3,//seansın müşterisi olarak d3 danışanını veriyoruz
    kategori: HizmetKategorisi.lazerEpilasyon,//seansın kategorisini enumdan lazerEpilasyon olarak veriyoruz
    islemAdi: "Tüm Vücut",//seansın işlem adını zorunlu string olarak giriyoruz
    birimFiyat: 25000.0,//seansın birim fiyatını double olarak veriyoruz
    seansSayisi: 15,//seans adedini 15 olarak veriyoruz
    indirimOrani: 0.0,//indirim yapılmayacağı için indirim oranını 0.0 veriyoruz
    sorumluUzman: "Tuba Aydın",//seansla ilgilenecek sorumlu uzmanın adını veriyoruz
  );
  final seans4 = SeansKaydi(//dördüncü randevumuzu oluşturmak için seans4 adında SeansKaydi nesnesi oluşturuyoruz
    seansKodu: "SNS-2026-4",//seansın kodunu zorunlu olarak veriyoruz
    danisan: d4,//seansın müşterisi olarak d4 danışanını veriyoruz
    kategori: HizmetKategorisi.medikalEstetik,//seansın kategorisini enumdan medikalEstetik olarak veriyoruz
    islemAdi: "Burun Estetiği",//seansın işlem adını zorunlu string olarak giriyoruz
    birimFiyat: 1500.0,//seansın birim fiyatını double olarak veriyoruz
    seansSayisi: 3,//seans adedini 3 olarak veriyoruz
    sorumluUzman: "Alaaddin Odabaşı",//seansla ilgilenecek sorumlu uzmanın adını veriyoruz
  );
  yonetici.randevuOlustur(seans1);//yonetici nesnemizin randevuOlustur metodunu çağırıp seans1 randevusunu seanslar listesine ekliyoruz
  yonetici.randevuOlustur(seans2);//yonetici nesnemizin randevuOlustur metodunu çağırıp seans2 randevusunu seanslar listesine ekliyoruz
  yonetici.randevuOlustur(seans3);//yonetici nesnemizin randevuOlustur metodunu çağırıp seans3 randevusunu seanslar listesine ekliyoruz
  yonetici.randevuOlustur(seans4);//yonetici nesnemizin randevuOlustur metodunu çağırıp seans4 randevusunu seanslar listesine ekliyoruz
  print("Seanslar Gönderiliyor");//seansların işleme gönderildiğini belirten yazıyı ekrana yazdırıyoruz

  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansiTamamla(//yonetici üzerinden seansiTamamla metodunu çağırıyoruz
    seansKodu: "SNS-2026-1",//tamamlanacak seansın kodunu named parametre olarak veriyoruz
    odeme: OdemeYontemi.krediKarti,//ödeme tipini krediKarti enum değeri olarak bildiriyoruz
  );
  //seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);//seans2'yi tamamlamak için kodunu ve nakit ödeme yöntemini verip metodumuzu çağırıyoruz
  //seans 4 iptal ediliyor
  yonetici.seansiIptalEt(//seansiIptalEt metodunu çağırarak seansı iptale çekiyoruz
    "SNS-2026-04",//iptal edilmek istenen seansın kodunu giriyoruz
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",//isteğe bağlı olan iptalNedeni parametresine gerekçeyi string olarak veriyoruz
  );

  yonetici.gunSonuRaporuYazdir();//tüm işlemler bittikten sonra yonetici nesnemizin gunSonuRaporuYazdir metodunu çağırarak tablosuyla cirosuyla tüm klinik özetini ekrana bastırıyoruz
}