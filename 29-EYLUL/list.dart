void main(){
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gateway-service:v1.9",
    "payment-processor:v3.0"
  ];
  aktifMikroservisler.add("telemetry-collector:v1.0");
  print("Aktif servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler");

  //sabit uzunluktaki liste(fixed-length)
  final List<String> cekirdekYukDengeleyiciler = List.filled(4, "Port-Kapalı",growable: false);
  cekirdekYukDengeleyiciler[0] = "LB-NODE-01; 192.168 .1.10(Online)";
  cekirdekYukDengeleyiciler[1] = "LB-NODE-02; 192.168 .1.11(Online)";
  //cekirdekYukDengeleyiciler.add("LB-NODE-05");//HATA:fixed-lenght listeye eleman eklenemez
  //örnk: adminpanelinde sadece 2 kullanıcın olsun başka hiçbir kullanıcı eklenmesin
  //bir veri tabanı bağlantısı vardır.
  //otoparkkta 30 boşluk var düşün, 31 boşluk yok. içerisindekiler değişebilir ama sayısı arttırılamaz.
  print("Çekirdek Yük Dengeleyici Portları: $cekirdekYukDengeleyiciler"); 

  //Programatik List Üretici
  final List<String> kubernetPodlari = List.generate(3, (index) => "pod-node-eu-west-${index+1} [Ram:16GB , CPU:4 Cores]");
  print("Oluşturulan K8s Podları: $kubernetPodlari");

  //Değiştirilemez List
  final List<String> guvenlikDuvariPortalari = List.
  unmodifiable([
    "22/TCP (SSH)",
    "443/TCP (HTTPS)",
    "6443/TCP (K8s-API)",
  ]);
  //guvenlikDuvariPortalari[0] = "80/TCP";//HATA: cannot modifitan unmodifiable List Cannot modify an unmodifiable list
  print("Güvenlik Duvarı Korumlaı Portlar $guvenlikDuvariPortalari");

  


}