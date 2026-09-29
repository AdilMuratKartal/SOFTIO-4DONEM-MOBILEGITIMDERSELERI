typedef MetikUyariKurali = bool Function(double deger) ;//Tip güvenli fonksiyon imzalari

void metrikDenetle({
  required String metrikAdi,
  required double mevcutDeger,
  required MetikUyariKurali kural,
  required void Function(String mesaj) alertTetikleyici,
}){
  if(kural(mevcutDeger)){
    alertTetikleyici(
      "Uyarı: $metrikAdi eşik değerini aştı. Mevcut:$mevcutDeger",
    );
  }else{
    print("$metrikAdi normal sınırlar içinde ($mevcutDeger)");
  }
}

void main(){
  print("Metrik Uyarıları");
  final MetikUyariKurali yuksekCpu = (deger) => deger >= 85.0; //%85 ve üstü 
  final MetikUyariKurali yuksekRam = (deger) => deger >= 90.0; //%85 ve üstü
  
  metrikDenetle(
    metrikAdi: "Cpu", 
    mevcutDeger: 92.4, 
    kural: yuksekCpu, 
    alertTetikleyici: (msg) => print(("Bildirim Gönderildi -> $msg")),
  );
  metrikDenetle(
    metrikAdi: "Ram", 
    mevcutDeger: 62.4, 
    kural: yuksekRam,
    alertTetikleyici: (msg) => print(("Bildirim Gönderildi -> $msg")),
  );//bence burada callback function verdik kural ile bool döndü duruma görede metrikDenetle alertTetikleyici'yi çalıştırdı


}