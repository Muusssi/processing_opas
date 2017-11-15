package hahmot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class Seina {

    public static int oletus_paksuus = 3;
    public static int oletus_r = 0;
    public static int oletus_g = 0;
    public static int oletus_b = 0;

    public float x, y;
    public float korkeus;
    public int paksuus;
    private boolean olemassa = true;
    public Pelikentta peli_kentta;
    public int r = 0;
    public int g = 0;
    public int b = 0;

    public Seina(float x, float y, float korkeus, Pelikentta kentta) {
        this.x = x;
        this.y = y;
        this.korkeus = korkeus;
        this.peli_kentta = kentta;
        this.paksuus = oletus_paksuus;
        peli_kentta.seinat.add(this);
        peli_kentta.seinatJarjestyksessa = new ArrayList<Seina>(peli_kentta.seinat);
        Collections.sort(peli_kentta.seinatJarjestyksessa, new SeinaVertailija());
    }

    protected void piirra() {
        Pelikentta.papplet.pushStyle();
        Pelikentta.papplet.strokeWeight(paksuus);
        Pelikentta.papplet.stroke(r, g, b);
        Pelikentta.papplet.line(x, y, x, y + korkeus);
        Pelikentta.papplet.popStyle();
    }

    public boolean kohdalla(Tasohyppelyhahmo hahmo) {
        if (hahmo.y + hahmo.kuva.height > this.y && hahmo.y < this.y + this.korkeus) {
            return true;
        }
        return false;
    }

    public void poista() {
        if (olemassa) {
            peli_kentta.seinat.remove(this);
            peli_kentta.seinatJarjestyksessa = new ArrayList<Seina>(peli_kentta.seinat);
            Collections.sort(peli_kentta.seinatJarjestyksessa, new SeinaVertailija());
            olemassa = false;
        }
    }

    public void palauta() {
        if (!olemassa) {
            peli_kentta.seinat.add(this);
            peli_kentta.seinatJarjestyksessa = new ArrayList<Seina>(peli_kentta.seinat);
            Collections.sort(peli_kentta.seinatJarjestyksessa, new SeinaVertailija());
            olemassa = true;
        }
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

    public class SeinaVertailija implements Comparator<Seina> {
        @Override
        public int compare(Seina t1, Seina t2) {
            if (t1.x < t2.x)
                return -1;
            else if (t1.y > t2.y)
                return 1;
            else
                return 0;
        }
    }

}
