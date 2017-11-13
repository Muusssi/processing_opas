package hahmot;

import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PGraphics;
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
    protected PGraphics taso_kerros;
    protected boolean tasokerros_vanhentunut = true;

    protected ArrayList<Seina> seinat = new ArrayList<Seina>();
    protected ArrayList<Seina> seinatJarjestyksessa = new ArrayList<Seina>();
    protected PGraphics seina_kerros;
    protected boolean seinakerros_vanhentunut = true;

    public Pelikentta(PApplet papplet, int maailman_leveys, int maailman_korkeus) {
        Pelikentta.papplet = papplet;
        this.maailman_leveys = maailman_leveys;
        this.maailman_korkeus = maailman_korkeus;
        this.taso_kerros = papplet.createGraphics(maailman_leveys, maailman_korkeus);
        this.seina_kerros = papplet.createGraphics(maailman_leveys, maailman_korkeus);
    }

    public Pelikentta(PApplet papplet, PImage tausta_kuva) {
        Pelikentta.papplet = papplet;
        this.maailman_leveys = tausta_kuva.width;
        this.maailman_korkeus = tausta_kuva.height;
        tausta = tausta_kuva;
     }

    protected void varmista_kamera() {
        alusta_koordinaatisto();
        if (papplet.frameCount != kamera_asetettu_viimeksi) {
            kamera_asetettu_viimeksi = papplet.frameCount;
            if (aktiivinen_hahmo != null) {
                aktiivinen_hahmo.seuraa_kameralla();
            }
            this.paivita_seina_kerros();
            this.paivita_taso_kerros();
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

    public void piirra_naytolle() {
        koordinaatisto_alustettu = false;
        papplet.popMatrix();
        papplet.popMatrix();
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
        varmista_kamera();
    }

    public Taso luo_taso(float x, float korkeus, float pituus) {
        return new Taso(x, korkeus, pituus, this);
    }

    protected void paivita_taso_kerros() {
        if (tasokerros_vanhentunut) {
            taso_kerros = papplet.createGraphics(maailman_leveys, maailman_korkeus);
            taso_kerros.beginDraw();
            for (int i=0; i<tasot.size(); i++) {
                tasot.get(i).piirra();
            }
            taso_kerros.endDraw();
            tasokerros_vanhentunut = true;
        }
    }

    public void piirra_tasot() {
        varmista_kamera();
        if (this.taso_kerros != null) {
            papplet.image(this.taso_kerros, 0, 0);
        }
    }

    protected void paivita_seina_kerros() {
        if (seinakerros_vanhentunut) {
            seina_kerros = papplet.createGraphics(maailman_leveys, maailman_korkeus);
            seina_kerros.beginDraw();
            for (int i=0; i<seinat.size(); i++) {
                seinat.get(i).piirra();
            }
            seina_kerros.endDraw();
            seinakerros_vanhentunut = false;
        }
    }


    public Seina luo_seina(float x, float y, float korkeus) {
        return new Seina(x, y, korkeus, this);
    }

    public void piirra_seinat() {
        this.varmista_kamera();
        if (this.seina_kerros != null) {
            papplet.image(seina_kerros, 0, 0);
        }
    }

}
