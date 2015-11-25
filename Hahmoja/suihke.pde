
class Suihke {
    private float x, y, x_suunta, y_suunta;
    private float nopeus = 3.2;
    private int hiukasTiheys = 10;
    private float hajonta = 0.1;

    private ArrayList<Hiukkanen> hiukkaset = new ArrayList<Hiukkanen>();
    private IntList poistettavat = new IntList();

    private int pun = 100;
    private int sin = 250;
    private int vih = 100;
    private int punaHajonta = 50;
    private int viherHajonta = 50;
    private int siniHajonta = 50;

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
        y += 0.1;
        if (jatka) {
            for (int i=0; i<hiukasTiheys; i++) {
                hiukkaset.add(new Hiukkanen(
                    x, y, x_suunta+randomGaussian()*hajonta,y_suunta+randomGaussian()*hajonta,
                    color(
                        pun+random(-punaHajonta, punaHajonta),
                        vih+random(-viherHajonta, viherHajonta),
                        sin+random(-siniHajonta, siniHajonta)
                    )
                ));
            }
        }
        Hiukkanen h;
        for (int i=0; i<hiukkaset.size(); i++) {
            h = hiukkaset.get(i);
            h.piirra();
            if (h.elinAika <= 0) {
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
    int elinAika;
    color vari;

    Hiukkanen(float x, float y, float x_nopeus, float y_nopeus, color vari) {
        this.x = x;
        this.y = y;
        this.x_nopeus = x_nopeus;
        this.y_nopeus = y_nopeus;
        this.vari = vari;
        elinAika = 100+int(randomGaussian()*5);
    }

    private void piirra() {
        fill(vari);
        stroke(vari);
        ellipse(x,y,10,10);
        x += x_nopeus;
        y += y_nopeus;
        elinAika--;
    }


}

