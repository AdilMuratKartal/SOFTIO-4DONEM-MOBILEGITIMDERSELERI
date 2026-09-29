enum OlaySeviyesi { info, warning, error, critical }

String alarmKanaliniBelirle(OlaySeviyesi seviye, int tekrarSayisi) {
  return switch (seviye) {
    OlaySeviyesi.info => "dev-logs",
    OlaySeviyesi.warning => "dev-warning",
    OlaySeviyesi.error when tekrarSayisi >= 5 =>
      "Sms veya Email (mükerrer hata)",
    OlaySeviyesi.error => "Email:dev@site.com",
    OlaySeviyesi.critical => "ACİL DURUM: Kriz odası otomatik node kapanışı",
  };
}

String httpKoduYorumlar(int kod) {
  return switch (kod) {
    >= 200 && < 300 => "2xx Başarılı İstek",
    >= 400 && < 500 => "4xx Başarılı İstek (client error)",
    >= 500 && < 600 => "5xx Başarılı İstek (internal server)",
    _               => "Tanımsız Hata Kodu",
  };
}


void main(){
  print("Switch Exporessions");
  print("Warning Kanalı                  :${(OlaySeviyesi.warning, 1)}");
  print("Tekil Error Kanalı              :${(OlaySeviyesi.error, 2)}");
  print("5 kez Tekrarlanan Error Kanalı                 :${(OlaySeviyesi.warning, 5)}");
  print("Kritik Kanalı                  :${(OlaySeviyesi.warning, 1)}");



  print("HTTP 204  :  ${httpKoduYorumlar(204)}");
  print("HTTP 404  :  ${httpKoduYorumlar(404)}");
  print("HTTP 502  :  ${httpKoduYorumlar(502)}");


}