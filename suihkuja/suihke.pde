
class Suihke {
    float x, y, x_suunta, y_suunta;
    float nopeus = 0.4;
    int hiukasTiheys = 100;
    int syke_vali = 0;
    float hajonta = 3;
    int elin_aika = 100;

    ArrayList<Hiukkanen> hiukkaset = new ArrayList<Hiukkanen>();
    IntList poistettavat = new IntList();

    int pun = 250;
    int sin = 0;
    int vih = 200;
    int punaHajonta = 0;
    int viherHajonta = 50;
    int siniHajonta = 50;

    private int edellinen_hiukkanen = 0;

    Suihke(float x, float y, float x_suunta, float y_suunta) {
        this.x = x;
        this.y = y;
        float suunnan_pituus = sqrt(sq(x_suunta)+sq(y_suunta));
        this.x_suunta = nopeus*x_suunta/suunnan_pituus;
        this.y_suunta = nopeus*y_suunta/suunnan_pituus;
    }

    void aseta(float x, float y) {
        this.x = x;
        this.y = y;
    }

    void aseta_suunta(float x_suunta, float y_suunta) {
        float suunnan_pituus = sqrt(sq(x_suunta)+sq(y_suunta));
        this.x_suunta = nopeus*x_suunta/suunnan_pituus;
        this.y_suunta = nopeus*y_suunta/suunnan_pituus;
    }

    void aseta_vari(int pun, int vih, int sin) {
        this.pun = pun;
        this.vih = vih;
        this.sin = sin;
    }

    void aseta_vari_hajonta(int punHajo, int vihHajo, int sinHajo) {
        punaHajonta = punHajo;
        viherHajonta = vihHajo;
        siniHajonta = sinHajo;
    }

    void aseta_nopeus(float nopeus) {
        this.nopeus = nopeus;
    }

    boolean osuuko(float x, float y, float sade) {
        Hiukkanen h;
        for (int i=0; i<hiukkaset.size(); i++) {
            h = hiukkaset.get(i);
            if (dist(h.x, h.y, x, y) < sade)
                return true;
        }
        return false;
    }

    void piirra(boolean jatka) {
        if (jatka && syke_vali<(frameCount-edellinen_hiukkanen)) {
            edellinen_hiukkanen = frameCount;
            for (int i=0; i<hiukasTiheys; i++) {
                hiukkaset.add(new Hiukkanen(
                    x, y,
                    x_suunta+randomGaussian()*hajonta,
                    y_suunta+randomGaussian()*hajonta,
                    color(
                        pun+random(-punaHajonta, punaHajonta),
                        vih+random(-viherHajonta, viherHajonta),
                        sin+random(-siniHajonta, siniHajonta)
                    ),
                    elin_aika
                ));
            }
        }
        Hiukkanen h;
        for (int i=0; i<hiukkaset.size(); i++) {
            h = hiukkaset.get(i);
            h.piirra();
            if (h.elin_aika <= 0) {
                poistettavat.append(i);
            }
        }
        for (int i=poistettavat.size()-1; i>=0; i--) {
            hiukkaset.remove(poistettavat.get(i));
        }
        poistettavat.clear();
    }

}


class Hiukkanen {
    float x, y, x_nopeus, y_nopeus;
    int elin_aika;
    color vari;

    Hiukkanen(float x, float y, float x_nopeus, float y_nopeus, color vari, int elin_aika) {
        this.x = x;
        this.y = y;
        this.x_nopeus = x_nopeus;
        this.y_nopeus = y_nopeus;
        this.vari = vari;
        this.elin_aika = elin_aika+int(randomGaussian()*5);
    }

    void piirra() {
        fill(vari);
        stroke(vari);
        ellipse(x,y,10,10);
        x += x_nopeus;
        y += y_nopeus;
        elin_aika--;
    }


}

