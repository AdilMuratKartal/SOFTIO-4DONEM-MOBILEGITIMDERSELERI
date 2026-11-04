// mixin and with

mixin UcmaYetisi{
  int ucusIrtifasiMetre = 100;

  void gogeYuksel(){
    print(
      "Uçus Yetisi: Kanatlarını Açtı ve $ucusIrtifasiMetre meterye Yükseldi",
    );
  }
}

mixin GorunmezlikYetisi{
  void pelerinOrt(){
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetisi{
  void alevSaldirisi(){
    print("Ateş Gücü: Kılıcını alevlendirdi ve alanmı yaktı");
  }
}

class TemelKarakter{
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviEjderBinicisi extends TemelKarakter with UcmaYetisi,AtesGucuYetisi{
  final String ejderhaAdi;

  EfsaneviEjderBinicisi({
    required this.ejderhaAdi,
    required super.ad,
  });

  void hucumEt(){
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }

}

class GolgeSuikastci extends TemelKarakter with GorunmezlikYetisi{
  GolgeSuikastci({required super.ad});

  void suikastYap(){
    print("$ad hedefe sessizce yaklaşıyor");
    pelerinOrt();
    print("Kritik Darbe Vurdu");
  }
}


//En BÜYÜK FARK BİR SINIF BİR ABSTRACT ALABİLİRKEN , BİR SINIF BİRDEN FAZLA MİXİN ALABİLİR.
void main(){
  print("Süper Güçler Başlatılıyor");
  final birici = EfsaneviEjderBinicisi(ejderhaAdi: "Aslıhan", ad: "Gencer");
  birici.hucumEt();
  final ikinci = GolgeSuikastci(ad: "AdilMurat ");
  ikinci.suikastYap();
}
