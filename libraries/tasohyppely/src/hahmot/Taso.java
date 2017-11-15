package hahmot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

//Taso, jonka päällä hahmot voivat hyppiä
public class Taso {

    public static int oletus_paksuus = 3;
    public static int oletus_r = 0;
    public static int oletus_g = 0;
    public static int oletus_b = 0;

    public float x, y;
    public float pituus;
    public int paksuus;
    private boolean olemassa = true;
    public Pelikentta peli_kentta;
    public int r = 0;
    public int g = 0;
    public int b = 0;

    public Taso(float x, float korkeus, float pituus, Pelikentta kentta) {
        this.x = x;
        this.y = korkeus;
        this.pituus = pituus;
        this.peli_kentta = kentta;
        this.paksuus = oletus_paksuus;
        peli_kentta.tasot.add(this);
        peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
        Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
    }

    public void poista() {
        if (olemassa) {
            peli_kentta.tasot.remove(this);
            peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
            Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
            olemassa = false;
        }
    }

    public void palauta() {
        if (!olemassa) {
            peli_kentta.tasot.add(this);
            peli_kentta.tasotKorkeudenMukaan = new ArrayList<Taso>(peli_kentta.tasot);
            Collections.sort(peli_kentta.tasotKorkeudenMukaan, new TasoKorkeusVertailija());
            olemassa = true;
        }
    }

    protected void piirra() {
        Pelikentta.papplet.pushStyle();
        Pelikentta.papplet.strokeWeight(paksuus);
        Pelikentta.papplet.stroke(r, g, b);
        Pelikentta.papplet.line(x, y, x + pituus, y);
        Pelikentta.papplet.popStyle();
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

    public void vari(int harmaa) {
        this.r = harmaa;
        this.g = harmaa;
        this.b = harmaa;
    }

    public void vari(int r, int g, int b) {
        this.r = r;
        this.g = g;
        this.b = b;
    }

    public static void oletus_vari(int harmaa) {
        oletus_r = harmaa;
        oletus_g = harmaa;
        oletus_b = harmaa;
    }

    public static void oletus_vari(int r, int g, int b) {
        oletus_r = r;
        oletus_g = g;
        oletus_b = b;
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
