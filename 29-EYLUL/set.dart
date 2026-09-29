//Set ve Ağ güvenlik kümeleri
void main(){
  print("Beyaz Liste ve Küme Analizi");

  final Set<String> istanbulVeriMerkeziIpleri = {
    "10.0.1.10",
    "10.0.1.11",
    "10.0.1.12",
    "10.0.1.13",
    "10.0.1.10",// Çift kayıt Set burayı anında tek hale getirir.
  };
  print("İstanbul İpleri: $istanbulVeriMerkeziIpleri");

  final Set<String> frankfurtVeriMerkeziTipleri = {
    "10.0.1.13",
    "10.0.1.30",
    "10.0.1.45",
  };
  print("Frankurt İpleri: $frankfurtVeriMerkeziTipleri");
  final ortakKopruIpler = istanbulVeriMerkeziIpleri.intersection(frankfurtVeriMerkeziTipleri);//sadece ortakları alıyor
  print("Ortak Ağ İpleri(kesişim): $ortakKopruIpler");

  final tumGlobalIpler = istanbulVeriMerkeziIpleri.union(frankfurtVeriMerkeziTipleri);//ortak olanları bir kere yazar birleşim
  print("Toplam Global Ipler(birleşim): $tumGlobalIpler");

  final sadeceIstanbul = istanbulVeriMerkeziIpleri.difference(frankfurtVeriMerkeziTipleri);//A KÜMESİ nin, B olmayan kısmı gibi düşün left join A-B fark b a nın içine b elemanlarını çıkarma
  print("Sadece İstanbul $sadeceIstanbul");

}

