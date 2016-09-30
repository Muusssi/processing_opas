package hahmot;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

public class Pelikentta {
    
    protected Tasohyppelyhahmo aktiivinen_hahmo = null;

    protected static PApplet papplet;
    protected static boolean koordinaatisto_alustettu = false;

    protected PImage tausta;

    public int maailman_leveys;
    public int maailman_korkeus;

    protected float kameran_siirto_x = 0;
    protected float kameran_siirto_y = 0;
    private int kamera_asetettu_viimeksi = 0;

    protected ArrayList<Taso> tasot = new ArrayList<Taso>();
    protected ArrayList<Taso> tasotKorkeudenMukaan = new ArrayList<Taso>();

    protected ArrayList<Seina> seinat = new ArrayList<Seina>();
    protected ArrayList<Seina> seinatJarjestyksessa = new ArrayList<Seina>();

    public Pelikentta(PApplet papplet, int maailman_leveys, int maailman_korkeus) {
        Pelikentta.papplet = papplet;
        alusta_koordinaatisto();
        this.maailman_leveys = maailman_leveys;
        this.maailman_korkeus = maailman_korkeus;
    }

    public Pelikentta(PApplet papplet, PImage tausta_kuva) {
        Pelikentta.papplet = papplet;
        alusta_koordinaatisto();
        this.maailman_leveys = tausta_kuva.width;
        this.maailman_korkeus = tausta_kuva.height;
        tausta = tausta_kuva;
     }
    
    protected void varmista_kamera() {
        if (papplet.frameCount > kamera_asetettu_viimeksi) {
            kamera_asetettu_viimeksi = papplet.frameCount;
            aktiivinen_hahmo.seuraa_kameralla();
        }
    }

    private static void alusta_koordinaatisto() {
        if (!koordinaatisto_alustettu) {
            papplet.pushMatrix();
            papplet.translate(0, papplet.height + 0);
            papplet.scale(1, -1);
            papplet.pushMatrix();
            koordinaatisto_alustettu = true;
        }
    }

    public float mouse_x() {
        return papplet.mouseX - kameran_siirto_x;
    }

    public float mouse_y() {
        return papplet.height - papplet.mouseY - kameran_siirto_y;
    }

    public Tasohyppelyhahmo luo_tasohyppelyhahmo(PImage kuva) {
        return new Tasohyppelyhahmo(kuva, this);
    }
    
    public void piirra_tausta() {
        if (this.tausta != null) {
            papplet.pushMatrix();
            papplet.image(tausta, kameran_siirto_x, -kameran_siirto_y+papplet.height-tausta.height);
            papplet.popMatrix();
        }
    }

    public Taso luo_taso(float x, float korkeus, float pituus) {
        return new Taso(x, korkeus, pituus, this);
    }

    public void piirra_tasot() {
        this.varmista_kamera();
        for (int i = 0; i < tasot.size(); i++) {
            Taso t = tasotKorkeudenMukaan.get(i);
            if (t.y > papplet.height - kameran_siirto_y) {
                return;
            } else if (t.y > -kameran_siirto_y) {
                if (t.x + t.pituus > -kameran_siirto_x && t.x < papplet.width - kameran_siirto_x)
                    t.piirra();
            }
        }
    }

    public Seina luo_seina(float x, float y, float korkeus) {
        return new Seina(x, y, korkeus, this);
    }

    public void piirra_seinat() {
        this.varmista_kamera();
        for (int i = 0; i < seinat.size(); i++) {
            Seina s = seinatJarjestyksessa.get(i);
            if (s.x > papplet.width - kameran_siirto_x) {
                return;
            } else if (s.x > -kameran_siirto_x) {
                if (s.y + s.korkeus > -kameran_siirto_y && s.y < papplet.height - kameran_siirto_y)
                    s.piirra();
            }
        }
    }

}
