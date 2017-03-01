package hahmot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class Seina {

    float x, y;
    float korkeus;
    int paksuus = 3;
    private boolean olemassa = true;
    public Pelikentta peli_kentta;

    public Seina(float x, float y, float korkeus, Pelikentta kentta) {
        this.x = x;
        this.y = y;
        this.korkeus = korkeus;
        this.peli_kentta = kentta;
        peli_kentta.seinat.add(this);
        peli_kentta.seinatJarjestyksessa = new ArrayList<Seina>(peli_kentta.seinat);
        Collections.sort(peli_kentta.seinatJarjestyksessa, new SeinaVertailija());
        peli_kentta.paivita_seina_kerros();
    }

    protected void piirra() {
        peli_kentta.seina_kerros.strokeWeight(paksuus);
        peli_kentta.seina_kerros.line(x, y, x, y + korkeus);
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
            peli_kentta.paivita_seina_kerros();
        }
    }

    public void palauta() {
        if (!olemassa) {
            peli_kentta.seinat.add(this);
            peli_kentta.seinatJarjestyksessa = new ArrayList<Seina>(peli_kentta.seinat);
            Collections.sort(peli_kentta.seinatJarjestyksessa, new SeinaVertailija());
            olemassa = true;
            peli_kentta.paivita_seina_kerros();
        }
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
