abstract class Canavar{
  final String isim;

  Canavar({required this.isim});

  void kukre();

}

class Kurt extends Canavar{
  Kurt({required super.isim});

  @override
  void kukre(){
    print("Auuuuuu");
  }
}

class Ejderha extends Canavar{
  Ejderha({required super.isim});

  @override
  void kukre(){
    print("Roarrr, GRrr, ");
  }
}

void canavarlariKukret(List<Canavar> canavarlar) {
  for (var canavar in canavarlar) {
    canavar.kukre();
  }
}

void main(){
  final List<Canavar> canavarTakimi = [
    Kurt(isim: "Kurt"),
    Ejderha(isim: "Ejderha"),
  ];

}