//import 'dart:io';
// 1. Cihaz Tiplerini Oluşturun
import 'dart:io';

enum CihazTipi { sensor, gateway, edgeServer, router }
// 1.

// 2. IoTCihaz Sınıfını Oluşturun
class IotCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;
  final bool acikMi; //8. görevdeki kapalı olma durumu için

  const IotCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    this.sslSertifikasiGecerliMi = false,
    this.acikMi = true,
  });

  bool get guvenlikAcigiVarmi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET"); //contains ile acikPortların required olması gerekiyor.sslserfikayı varsayılan olarak false yaptık her gelen cihaz güvensiz olarak düşünüldüğü için, nesne oluşturulurken duruma göre değer verilmeli.

  bool get riskliMi => guvenlikAcigiVarmi || cpuYukYuzdesi > 85.0;
}
// 2.

// 8. Cihaz Erişilemiyorsa Exception Fırlatın
class CihazErisilemezException implements Exception {
  final String mesaj;
  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj;
}
// 8.

// 6. Seri Numarasına Göre Cihaz Bulma
//direk olarak seriNo dan bulmak için liste lazımdı onuda direk vermedim yönetici class'ından erişsin dedim
({String cihazAdi, CihazTipi tip, bool alarmDurumu}) cihazBul({
  required String seriNo,
  required List<IotCihaz> cihazlar,
}) {
  final eslesenCihazlar = cihazlar.where((c) => c.seriNo == seriNo); //seri no'ları aynı olan birden fazla cihaz olursa diye firstWhere kullandım. daha sonra bu nesnelerin içeriklerinide eşit olmayacak şekilde ayarlanır
  if(eslesenCihazlar.isEmpty){
    throw CihazErisilemezException("[$seriNo] seri numaralı cihaz ağda bulunamadı");
  }
  
  final eslesenCihaz = eslesenCihazlar.first;
  // 8. Görevin isterine uygun olarak cihazın kapalı olma kontrolü:
  if (!eslesenCihaz.acikMi) {
    throw CihazErisilemezException("[$seriNo] seri numaralı cihaz kapalı olduğundan erişilemiyor!");
  }

  return (
    cihazAdi: eslesenCihaz.cihazAdi,
    tip: eslesenCihaz.tip,
    alarmDurumu: eslesenCihaz.riskliMi, //alarm durumunu ödevde belirtildiği gibi cihazın riskli olma durumunu belirlten guvenlikAcigiVarmi getter metodu bool değeri atanacaktır.
  );
}
// 6.

// 7. Cihaz Tipine Göre İzolasyon Bölgesi
String izolasyonBolgeKodu(IotCihaz? cihaz) {
  return switch (cihaz?.tip) {
    CihazTipi.sensor => "ZONE-S",
    CihazTipi.gateway => "ZONE-G",
    CihazTipi.edgeServer => "ZONE-E",
    CihazTipi.router => "ZONE-R",
    _ => "Cihaz Bulunamadi",
  };
}
// 7. 




void main() {
  print("Ödev Çıktısı başlatılıyor....");
  print("-------------------------------------------------------");

  //3. Cihazları Oluşturun
  final cihaz1 = IotCihaz(
    seriNo: "SN-114-214W",
    cihazAdi: "Router-Ana",
    tip: CihazTipi.router,
    cpuYukYuzdesi: 96.5,
    bellekMb: 256,
    acikPortlar: {"192.154", "88.143", "1334.122"},
    sslSertifikasiGecerliMi: false,
  );
  final cihaz2 = IotCihaz(
    seriNo: "SN-114-215W",
    cihazAdi: "Gateway-Giris",
    tip: CihazTipi.gateway,
    cpuYukYuzdesi: 20.5,
    bellekMb: 512,
    acikPortlar: {"51/CELAS", "88.143", "1334.122"},
    sslSertifikasiGecerliMi: true,
  );
  final cihaz3 = IotCihaz(
    seriNo: "SN-114-216W",
    cihazAdi: "Edge-Sunucu-1",
    tip: CihazTipi.edgeServer,
    cpuYukYuzdesi: 20.5,
    bellekMb: 2048,
    acikPortlar: {"14/API", "23/TELNET", "8674.682"},
    sslSertifikasiGecerliMi: true,
  );
  final cihaz4 = IotCihaz(
    seriNo: "SN-114-217W",
    cihazAdi: "Sensor-Sicaklik",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 50.5,
    bellekMb: 256,
    acikPortlar: {"978:112/HOME", "88.143", "23/TELNET"},
    sslSertifikasiGecerliMi: true,
  );
  final cihaz5 = IotCihaz(
    seriNo: "SN-114-218W",
    cihazAdi: "Sensor-Nem",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 85.5,
    bellekMb: 4096,
    acikPortlar: {"192.154", "834.143", "1334.121"},
    sslSertifikasiGecerliMi: false,
  );
  final cihaz6 = IotCihaz(
    seriNo: "SN-114-219W",
    cihazAdi: "Router-Yedek",
    tip: CihazTipi.router,
    cpuYukYuzdesi: 90.5,
    bellekMb: 12800,
    acikPortlar: {"192.524", "812.143", "2344.114"},
    sslSertifikasiGecerliMi: true,
    acikMi: false, // 8. görevin testi için kapalı cihaz
  );

  final List<IotCihaz> agdakiCihazlar = [
    cihaz1,
    cihaz2,
    cihaz3,
    cihaz4,
    cihaz5,
    cihaz6,
  ];

  // 4. Riskli Cihazları Bulun
  final riskliCihazlar = agdakiCihazlar.where(
    (c) => c.guvenlikAcigiVarmi || (c.cpuYukYuzdesi > 85.0),
  ).toList();
  // 4

  // 5. Toplam Bellek Kullanımını Hesaplayın
  final toplamBellek = agdakiCihazlar.fold(
    0,
    (toplam, c) => toplam + c.bellekMb,
  );
  // 5.

  // 6. ve 8. Görevi beraber çağırma, 6. görevede hata atma durumu eklediğimi için
  ({String cihazAdi, CihazTipi tip, bool alarmDurumu})? arananCihaz;
  try {
    // Başarılı arama (final kaldırıldı, dış değişkene atanıyor)
    arananCihaz = cihazBul(seriNo: "SN-114-218W", cihazlar: agdakiCihazlar);

    // 8. Görev Senaryosu 1: Kapalı cihaza erişim hatası testi
    print("\n--- Exception Testi 1 (Kapalı Cihaz) ---");
    cihazBul(seriNo: "SN-114-219W", cihazlar: agdakiCihazlar);
  } on CihazErisilemezException catch (e) {
    print("Hata Yakalandı: $e");
  }

  try {
    // 8. Görev Senaryosu 2: Olmayan cihaza erişim hatası testi
    print("\n--- Exception Testi 2 (Olmayan Cihaz) ---");
    cihazBul(seriNo: "OLMAYAN-SERI-NO", cihazlar: agdakiCihazlar);
  } on CihazErisilemezException catch (e) {
    print("Hata Yakalandı: $e");
  }


  // 7.Görevi cihaz1 için yazdırılacaktır
  final cihaz1IzoBolgeKod = izolasyonBolgeKodu(cihaz1);


  // Görevlerin Yazdırılması
  print("CihazTipi enum'u ve değerleri: ${CihazTipi.values}");
  print("-------------------------------------------------------");
  print("oluşturulanCihazlar: ");
  agdakiCihazlar.forEach((cihaz)=> {
    print("seriNo: ${cihaz.seriNo}, cihazAdi: ${cihaz.cihazAdi}, tip: ${cihaz.tip}, cpuYukYuzdesi: ${cihaz.cpuYukYuzdesi}, bellekMb: ${cihaz.bellekMb}, acikPortlar: ${cihaz.acikPortlar}, sslSertifikasiGecerliMi: ${cihaz.sslSertifikasiGecerliMi}")
  });
  print("-------------------------------------------------------");
  print("Riskli Cihazlar: sslSertifikasiGecerliMi:false , cpuYukYuzdesi > 85 ");
  riskliCihazlar.forEach((cihaz)=> {
    print("seriNo: ${cihaz.seriNo}, cihazAdi: ${cihaz.cihazAdi}, tip: ${cihaz.tip}, cpuYukYuzdesi: ${cihaz.cpuYukYuzdesi}, bellekMb: ${cihaz.bellekMb}, acikPortlar: ${cihaz.acikPortlar}, sslSertifikasiGecerliMi: ${cihaz.sslSertifikasiGecerliMi}")
  });
  print("-------------------------------------------------------");
  print("Üretilen Cihazlarin Toplam Belleği: $toplamBellek");
  print("-------------------------------------------------------");
  print("Aranan Cihaz(Cihaz6 - seriNo): 'SN-114-218W' ");
  if(arananCihaz != null){
    print("Cihaz Adi: ${arananCihaz.cihazAdi}, Cihaz Tipi: ${arananCihaz.tip}, Alarm Durumu: ${arananCihaz.alarmDurumu}");
  }else{
    print("Aranan Cihaz Bulunamadı");
  }
  print("-------------------------------------------------------");
  print("Cihaz 1'in(tipi: router) İzalosyan Bölge Kodu: $cihaz1IzoBolgeKod");
}