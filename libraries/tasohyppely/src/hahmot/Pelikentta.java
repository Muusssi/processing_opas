package hahmot;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;

public class Pelikentta {

    private static String VERSION = "3.3";

    protected Tasohyppelyhahmo aktiivinen_hahmo = null;

    protected static PApplet papplet;
    protected static boolean koordinaatisto_alustettu = false;

    public PImage tausta;

    public int maailman_leveys;
    public int maailman_korkeus;

    public float kameran_siirto_x = 0;
    public float kameran_siirto_y = 0;
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

    public Pelikentta(PApplet papplet, PImage tausta_kuva, int maailman_leveys, int maailman_korkeus) {
        Pelikentta.papplet = papplet;
        alusta_koordinaatisto();
        this.maailman_leveys = maailman_leveys;
        this.maailman_korkeus = maailman_korkeus;
        tausta = tausta_kuva;
    }

    public void varmista_kamera() {
        if (papplet.frameCount != kamera_asetettu_viimeksi) {
            kamera_asetettu_viimeksi = papplet.frameCount;
            aktiivinen_hahmo.seuraa_kameralla();
        }
    }

    public static void alusta_koordinaatisto() {
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
            papplet.image(tausta, kameran_siirto_x, -kameran_siirto_y + papplet.height - maailman_korkeus, maailman_leveys, maailman_korkeus);
            papplet.popMatrix();
        }
        varmista_kamera();
    }

    public Taso luo_taso(float x, float korkeus, float pituus) {
        return new Taso(x, korkeus, pituus, this);
    }

    public void piirra_tasot() {
        varmista_kamera();
        for (int i=0; i<tasot.size(); i++) {
            tasot.get(i).piirra();
        }
    }


    public Seina luo_seina(float x, float y, float korkeus) {
        return new Seina(x, y, korkeus, this);
    }

    public void piirra_seinat() {
        this.varmista_kamera();
        for (int i=0; i<seinat.size(); i++) {
            seinat.get(i).piirra();
        }
    }

    public void piirra_naytolle() {
        papplet.popMatrix();
        papplet.popMatrix();
        koordinaatisto_alustettu = false;
    }

    public String kirjasto_versio() {
        return VERSION;
    }

}
