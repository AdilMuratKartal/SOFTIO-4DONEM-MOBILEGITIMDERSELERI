

//SRP IHLALI (god classs ham veri tutuyor hem db yazıyor hemp epos gonderiyor hem log olusturuyor)
class UserManager{
    void 
    registerUser(String email,String password){
        //1.Validasyon yap
        //2.SQL/Fireabase kaydet
        //3.SMTO uzerinden hos geldin maili at
        //4.Hata olursa log yaz. 
    }
}


//SRP UYUMLU KODLAR
class UserValidator{bool isValid(String email,String password)=>true;}
class UserRepository{void saveToDatebase(User user){/db islemleri/}}
class EmailService{void sendWelcomeEmail(String email){/Mail işlemleri/}}
class LoggerService{void log(String message{/log islemleri/})}


//Open / Close Principle (Geliştirmeye Açık / Değişime Kapalı)

// Soyut Arayuz
abstract class PaymentMethod{
    void pay(double amonut);
}

class CreditCardPayment implements PaymentMethod{
    @override void pay(double amount)=> print('$amount TL KREDI KARTI ILE ODEME ALINDI');
}

class ApplePayPayment implements PaymentMethod{
    @override void pay(double amount)=> print('$amount TL APPLE PAY ILE ODENDI');
}



class Rectangle{
    double width = 0;
    double height = 0;

    void setWidth(double w)=>width=w;
    void setHeight(double h)=>height=h;
    double get area => width * height;
}

// LSKIV IHLAHLI
class Square extends Rectangle{
@override void setWidth(double w) {width=w; height=w}// kare oldugu igin boyu efitlendi
@override void setHeight(double h) {width=h; height=h}// kare oldugu igin boyu esitlendi

// test fonksiyonu
void testRectangle(Rectangle r)
    r.setWidth(5);
    r.setHeight(4);
    //Ust siner kuratina gore alan 5*4=20 olmallor
    // parametre olarak square gønderilirse 4*4=16
    //beklenen davranıs bozuldu! LISKOV İHLALI
    assert(r.area == 20); 
}

//SISKIN ARAYUZ
abstract class SmartDevice{
    void printDocument();
    void scanDocument();
    void scanFax();
}

//Normalş bir ev yazıcısı (fax cekemez)
class BasicPrintr implements SmartDevice{
    @override void printDocument()=>print('Yazdiriliyor');
    @override void scanDocument()=>print('Taraniyor');
    @override void scanFax()=>throw UnimplementedError('fax ozellıgım yok')//ISP IHLALI
}


// ISP UYUMLU
abstract class Printer{ void printDocument();}
abstract class Scanner{void scanDocument();}
abstract class FaxMachine(void sendFax();)

class BasicPrintirClean implements Printer, Scannert{
    @override void printDocument()=>print('Yazdiriliyor');
    @override void scanDocument()=>print('Taraniyor');|
}//olay ne BİR SINIF SOYUT SINIFIN SADECE 2 METODUNA İHTİYACI VAR AMA GERKSİZ YERE 3 METOD
//ÇAĞIRIYOR GEREKSİZ ONUN YERİNE BİZ FARKLI 3 SOYUT SINIF OLUŞTURURUZ HER BİR AYRI BİR METODU ALIR
//SONRA GEREKEN SINIFLARI BUNLAR MİRAS ALIR İMPLEMENT EDER HANGİLERİE GEREKİYORSA O SINFLARDAN EDER


abstract class AuthRemote{
    Future<String> login (String email,String password);
}

class FireabaseAuthService implements AuthRemote{
    @override Future<String> login(String email, String password) async =>"MOCKTOKEN_SUCCESS";
}

class LoginViewModel{
    final AuthRemote authSource;
    LoginViewModel({required this.authSource});

    Future<void> handleLogin(String email, String pass) async{
        final token = await authSource.login(email,pass);
        print('giris basarili: $token');
    }
}