
void setup() {
  size(512, 512);
  // Luodaan kaksi eläin instanssia/oliota
  Elain koira = new Elain("Vuf!");
  Elain kissa = new Elain("Miau!");

  // viitataan olioihin 'kissa' ja 'koira' ei luokkaan 'Elain'
  println("---- Eläimet puhuvat:");
  koira.sano(); // "Vuf!"
  kissa.sano(); // "Miau!"
  kissa.sano_yhdessa(koira); // "Miau! Vuf!"

  // Staattinen luokka josta ei voi luoda olioita
  // Viitataan luokkaan 'Matikka'
  println("---- Matikkaa:");
  println("piin arvo on: " + Matikka.pii);
  println("5+6 = " + Matikka.summa(5, 6));
}


// LUOKKA MÄÄRITTELYT ALKAVAT TÄSTÄ:

// Ei staattinen luokka jonka perusteella luodaan olioita/instansseja
// Tällaisia instansseja eli eri eläimiä voi siis olla monta.
// Luokkien nimet isolla alkukirjaimella.
class Elain {
  
  // Kullakin eläimellä on tallessa tekstimuuttuja johon tallenetaan
  // mitä eläin sanoo. Esitellään luokan sisällä, jolloin se on käytössä
  // sellaisenaan luokan sisällä, mutta myös luokan ulkopuolella jos
  // käytössä on viittaus instanssiin. Muuttuja -> pieni alkukirjain.
  String sanoo;
  
  // Konstruktori eli olion luova metodi. Saman niminen kuin luokka ja
  // palauttaa viittauksen Elain instanssiin. Tällä metodilla on myös
  // yksi argumentti: teksti muuttuja 'sanoo' joka on käytössä vain
  // tämän metodin sisällä.
  Elain(String sanoo) {
    // Kun luodaan uusi eläin tallenetaan miten se ääntelee sen omaan
    // 'sanoo' muuttujaan. Koska metodin argumentti ja olion muuttuja
    // 'sanoo' ovat saman nimisiä pitää olion muuttujaan viitata 'this'
    // sanan avulla.
    this.sanoo = sanoo;
  }

  // Ääntely metodi, joka ei palauta mitään mutta kirjoittaa ääntelyn
  // konsoliin.
  void sano() {
    println(sanoo);
  }

  // Metodi, jonka avulla kaksi eläintä puhuu yhdessä. Se tarvitsee
  // argumentin, jonka avulla se voi viitata johonkin toiseen eläimeen
  // tietääkseen miten se eläin puhuu.
  void sano_yhdessa(Elain toinen_elain) {
    // 'this.sanoo' viittaa tämän eläimen 'sanoo'-muttujaan ja 
    // 'toinen_elain.sanoo' vittaa toisen eläimen 'sanoo'-muttujaan 
    println(this.sanoo+" "+toinen_elain.sanoo);
  }
  
}

// STAATTINEN LUOKKA MATIKKA:
// Staattisista luokista ei luoda olioita perinteinen esimerkki olisi
// matematiikka-luokka joita ei tarvitse montaa erilaista.
// Staatisella luokalla voidaan koota vaikka 
static class Matikka {
  // staattinen muuttuja pii jolle ei tarvitse/pidä antaaa eri arvoja
  // eri tilanteissa
  static float pii = 3.14159;

  // Staattinen funktio summa laskee kahden muttujan summan
  static float summa(float a, float b) {
    return a+b;
  }

}
