mixin YuzmeEgitim{
  void dalisYap(){
    print("Su altına daldı");
  }
}

class Denizci with YuzmeEgitim{
  Denizci();
}

void main(){
  final denizci = Denizci();
  denizci.dalisYap();
}