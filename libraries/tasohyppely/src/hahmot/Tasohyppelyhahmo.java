package hahmot;

import processing.core.PApplet;
import processing.core.PImage;

public class Tasohyppelyhahmo {

    public float x = 0;
    public float y = 0;
    public PImage kuva;
    public float liikutus_nopeus = 5;
    public float y_nopeus = 0;
    public float putoamiskiihtyvyys = (float) -0.3;
    public float hyppynopeus = 8;
    public boolean viimeksi_vasemmalle = false;

    public boolean kaksoishyppy = false;
    public Pelikentta pelikentta;

    public Tasohyppelyhahmo(PImage kuva, Pelikentta pelikentta) {
        this.kuva = kuva;
        this.pelikentta = pelikentta;
        if (pelikentta.aktiivinen_hahmo == null) {
            pelikentta.aktiivinen_hahmo = this;
        }
    }

    public void ala_seurata_kameralla() {
        pelikentta.aktiivinen_hahmo = this;
    }

    public void aseta(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void aseta_nopeus(float nopeus) {
        this.liikutus_nopeus = nopeus;
    }

    public void aseta_hyppynopeus(float nopeus) {
        this.hyppynopeus = nopeus;
    }

    public float etaisyys_sivusuunnassa(Tasohyppelyhahmo toinen_hahmo) {
        if (x + kuva.width < toinen_hahmo.x) {
            return toinen_hahmo.x - (x + kuva.width);
        } else if (x > toinen_hahmo.x + toinen_hahmo.kuva.width) {
            return x - (toinen_hahmo.x + toinen_hahmo.kuva.width);
        } else {
            return 0;
        }
    }

    public boolean koskee(Tasohyppelyhahmo toinen_hahmo) {
        if (x + kuva.width < toinen_hahmo.x) {
            return false;
        } else if (x > toinen_hahmo.x + toinen_hahmo.kuva.width) {
            return false;
        } else if (y + kuva.height < toinen_hahmo.y) {
            return false;
        } else if (y > toinen_hahmo.y + toinen_hahmo.kuva.height) {
            return false;
        }
        return true;
    }

    public void tyonna(Tasohyppelyhahmo toinen_hahmo) {
        if (this.x < toinen_hahmo.x) {
            toinen_hahmo.x -= toinen_hahmo.x - this.x - this.kuva.width;
        } else {
            toinen_hahmo.x += this.x - toinen_hahmo.x - toinen_hahmo.kuva.width;
        }
    }

    public void piirra() {
        pelikentta.varmista_kamera();
        tipu();
        Pelikentta.papplet.pushMatrix();
        if (viimeksi_vasemmalle) {
            Pelikentta.papplet.scale(-1, -1);
            Pelikentta.papplet.image(kuva, -(x + kuva.width), -y - kuva.height);
        } else {
            Pelikentta.papplet.scale(1, -1);
            Pelikentta.papplet.image(kuva, x, -y - kuva.height);
        }
        Pelikentta.papplet.popMatrix();
    }

    public float seuraava_oikea_seina() {
        float oikea_seina = pelikentta.maailman_leveys;
        for (int i = pelikentta.seinat.size() - 1; i >= 0; i--) {
            Seina s = pelikentta.seinatJarjestyksessa.get(i);
            if (s.x <= this.x) {
                return oikea_seina;
            }
            if (s.kohdalla(this)) {
                oikea_seina = s.x;
            }
        }
        return oikea_seina;
    }

    public float seuraava_vasen_seina() {
        float vasen_seina = 0;
        for (int i = 0; i < pelikentta.seinat.size(); i++) {
            Seina s = pelikentta.seinatJarjestyksessa.get(i);
            if (s.x >= this.x + this.kuva.width) {
                return vasen_seina;
            }
            if (s.kohdalla(this)) {
                vasen_seina = s.x;
            }
        }
        return vasen_seina;
    }

    public void liiku_oikealle() {
        x = PApplet.constrain(x + liikutus_nopeus, 0, seuraava_oikea_seina() - kuva.width);
        viimeksi_vasemmalle = false;
    }

    public void liiku_vasemmalle() {
        x = PApplet.constrain(x - liikutus_nopeus, seuraava_vasen_seina(), pelikentta.maailman_leveys - kuva.width);
        viimeksi_vasemmalle = true;
    }

    public void hyppy() {
        if (y_nopeus == 0) {
            y_nopeus = hyppynopeus;
            kaksoishyppy = false;
        } else if (!kaksoishyppy) {
            y_nopeus = hyppynopeus;
            kaksoishyppy = true;
        }
    }

    public void liiku_itsestaan(float vasen_reuna, float oikea_reuna) {
        if ((x <= vasen_reuna && viimeksi_vasemmalle) || (x >= oikea_reuna && !viimeksi_vasemmalle)) {
            viimeksi_vasemmalle = !viimeksi_vasemmalle;
        }
        if (viimeksi_vasemmalle) {
            liiku_vasemmalle();
        } else if (!viimeksi_vasemmalle) {
            liiku_oikealle();
        }
    }

    public void tipu() {
        float lattia = seuraava_lattia();
        float katto = seuraava_katto();

        if (y > lattia && y <= katto) {
            y_nopeus += putoamiskiihtyvyys;
        } else if (y_nopeus < 0) {
            y_nopeus = 0;
        }
        if (y + kuva.height >= katto && y_nopeus > 0) {
            y_nopeus = 0;
        }
        y = PApplet.constrain(y + y_nopeus, lattia, katto + kuva.height);
        x = PApplet.constrain(x, seuraava_vasen_seina(), seuraava_oikea_seina() + kuva.width);
    }

    public float seuraava_katto() {
        float katto = pelikentta.maailman_korkeus;
        for (int i = pelikentta.tasotKorkeudenMukaan.size() - 1; i >= 0; i--) {
            Taso taso = pelikentta.tasotKorkeudenMukaan.get(i);
            if (taso.y < y) {
                return katto;
            }
            if (taso.y < katto && taso.onko_alla(this)) {
                katto = taso.y;
            }
        }
        return katto;
    }

    public float seuraava_lattia() {
        float lattia = 0;
        for (int i = 0; i < pelikentta.tasotKorkeudenMukaan.size(); i++) {
            Taso taso = pelikentta.tasotKorkeudenMukaan.get(i);
            if (taso.y > y)
                return lattia;
            if (taso.y > lattia && taso.onko_paalla(this)) {
                lattia = taso.y;
            }
        }
        return lattia;
    }

    public void kohdista_kamera() {
        pelikentta.kameran_siirto_x = PApplet.constrain(-x + Pelikentta.papplet.width / 2, -pelikentta.maailman_leveys + Pelikentta.papplet.width, 0);
        pelikentta.kameran_siirto_y = PApplet.constrain(-y + Pelikentta.papplet.height / 2, -pelikentta.maailman_korkeus + Pelikentta.papplet.height, 0);
    }

    public void seuraa_kameralla() {
        float kameran_liikutus_nopeus_x = liikutus_nopeus;
        float kameran_liikutus_nopeus_y = liikutus_nopeus;

        if (x + pelikentta.kameran_siirto_x > Pelikentta.papplet.width || x + pelikentta.kameran_siirto_x < 0) {
            kameran_liikutus_nopeus_x = Pelikentta.papplet.width / 8;
        }
        if (x + pelikentta.kameran_siirto_x > 2 * Pelikentta.papplet.width / 3) {
            pelikentta.kameran_siirto_x = PApplet.constrain(pelikentta.kameran_siirto_x - kameran_liikutus_nopeus_x, -pelikentta.maailman_leveys + Pelikentta.papplet.width, 0);
        } else if (x + pelikentta.kameran_siirto_x < Pelikentta.papplet.width / 3) {
            pelikentta.kameran_siirto_x = PApplet.constrain(pelikentta.kameran_siirto_x + kameran_liikutus_nopeus_x, -pelikentta.maailman_leveys + Pelikentta.papplet.width, 0);
        }

        if (y_nopeus != 0) {
            kameran_liikutus_nopeus_y = -y_nopeus;
        } else if (y <= -pelikentta.kameran_siirto_y) {
            kameran_liikutus_nopeus_y = Pelikentta.papplet.height / 8;
        } else if (y >= Pelikentta.papplet.height + pelikentta.kameran_siirto_y) {
            // else if (y > 0) {
            kameran_liikutus_nopeus_y = -Pelikentta.papplet.height / 8;
        }
        if ((y + pelikentta.kameran_siirto_y > 2 * Pelikentta.papplet.height / 3 && y_nopeus >= 0)
                || (y + pelikentta.kameran_siirto_y < 2 * Pelikentta.papplet.height / 5 && y_nopeus <= 0)) {
            pelikentta.kameran_siirto_y = PApplet
                    .constrain(pelikentta.kameran_siirto_y + kameran_liikutus_nopeus_y, -pelikentta.maailman_korkeus + Pelikentta.papplet.height, 0);
        }
        if (!Pelikentta.koordinaatisto_alustettu) {
            Pelikentta.alusta_koordinaatisto();
        }
        Pelikentta.papplet.popMatrix();
        Pelikentta.papplet.pushMatrix();
        Pelikentta.papplet.translate(pelikentta.kameran_siirto_x, pelikentta.kameran_siirto_y);

    }

}