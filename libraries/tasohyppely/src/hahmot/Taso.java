package hahmot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

//Taso, jonka päällä hahmot voivat hyppiä
public class Taso {

    float x, y;
    float pituus;
    int paksuus = 3;
    private boolean olemassa = true;
    public Pelikentta peli_kentta;

    public Taso(float x, float korkeus, float pituus, Pelikentta kentta) {
        this.x = x;
        this.y = korkeus;
        this.pituus = pituus;
        this.peli_kentta = kentta;
        peli_kentta.tasot.add(this);
        peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
        Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
        peli_kentta.paivita_taso_kerros();

    }

    public void poista() {
        if (olemassa) {
            peli_kentta.tasot.remove(this);
            peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
            Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
            olemassa = false;
            peli_kentta.paivita_taso_kerros();
        }
    }

    public void palauta() {
        if (!olemassa) {
            peli_kentta.tasot.add(this);
            peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
            Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
            olemassa = true;
            peli_kentta.paivita_taso_kerros();
        }
    }

    protected void piirra() {
        // Peli.papplet.stroke(this.vari);
        peli_kentta.taso_kerros.strokeWeight(paksuus);
        peli_kentta.taso_kerros.line(x, y, x + pituus, y);
    }

    public boolean onko_kohdalla(Tasohyppelyhahmo hahmo) {
        // Hahmo on tason kohdalla eli törmää tasoon pystysuunnassa jos vähintään
        // puolet hamon leveydestä on tason päällä.
        if (hahmo.x + hahmo.kuva.width / 2 >= this.x && hahmo.x + hahmo.kuva.width / 2 <= this.x + this.pituus) {
            return true;
        }
        return false;
    }

    public boolean onko_paalla(Tasohyppelyhahmo hahmo) {
        if (hahmo.y >= this.y) {
            return onko_kohdalla(hahmo);
        }
        return false;
    }

    public boolean onko_alla(Tasohyppelyhahmo hahmo) {
        if (hahmo.y < this.y) {
            return onko_kohdalla(hahmo);
        }
        return false;
    }

    private class TasoKorkeusVertailija implements Comparator<Taso> {
        @Override
        public int compare(Taso t1, Taso t2) {
            if (t1.y < t2.y)
                return -1;
            else if (t1.y > t2.y)
                return 1;
            else
                return 0;
        }
    }

}
