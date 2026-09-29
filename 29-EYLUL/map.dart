void main() {
  print("Map metrikleri");

  final Map<String, Map<String, dynamic>> mikroservisRehberi = {
    "auth-api": {
      "port": 8081,
      "saglik": "Healthy",
      "restrartSayisi": 0,
      "bellekKullanimiMB": 384.5,
      "otonomOlcekleme": true,
    },
    "payment-gateway": {
      "port": 8082,
      "saglik": "Degraded",
      "restartSayisi": 4,
      "bellekKullanimiMB": 1280.0,
      "otonomOlcekleme": false,
    },
  };

  mikroservisRehberi.putIfAbsent(
    "reporting-worker",
    () => {
      "port": 9091,
      "saglik": "Healthy",
      "restartSayisi": 1,
      "bellekKullanimiMB": 512.0,
      "otonomOlcekleme": true,
    },
  );

  //METRİK GÜNCELLEME
  if (mikroservisRehberi.containsKey("payment-gateway")) {
    mikroservisRehberi["payment-gateway"]!["restartSayisi"] =
        (mikroservisRehberi["payment-gateway"]!["restartSayisi"] as int) +
        1; //Null olabilir , biz başta eklemediğimiz için onun kontrolünü yapıyoruz, sistem çökmemesi için . bu sayede null gelirse boş olarak kabul eder(dart'ta bu şekilde kullanabiliyor).
  }

  print("Güncel Servis Durum Raporu");
  print("----------------------------------");
  for (var entry in mikroservisRehberi.entries) {
    final String servis = entry.key;
    final Map<String, dynamic> ozet = entry.value;
    final String saglik = ozet["saglik"]; //tipini string tipine çevirdik, yukarda dynamic tipinde.
    final String durumRozet = saglik == "Healthy" ? "OK" : "Alert";
    print(
      "$durumRozet ${servis.padRight(18)} | Port: ${ozet['port']} | Ram: ${ozet['bellekKullanimiMB']}MB | Restart: ${ozet['restartSayisi']}",
    );
  }




}


/*//Ders içi Ufak Görev minichallange
void main(){
  void printDuty(){
    final Set<String> cloudServiceNames = {
      "google-apis",
      "aws-cloud",
      "cloudflare",
      "render.com",
      "google-firebase"
    };

    final bool isProduction = true;

    final List<String> allServers = [
      ...cloudServiceNames,

      if(isProduction) "vault-secret-manager",
    ];

    if(isProduction){
      allServers.add("vault-secret-manager2");
    }

    print("Tüm servisler: $allServers");
  };
  printDuty();
}
*/