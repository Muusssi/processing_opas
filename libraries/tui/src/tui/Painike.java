package tui;

import processing.core.PConstants;

public class Painike {

    public int x, y;
    public int leveys;
    public int korkeus = 30;
    public String teksti;

    public int tausta_r = 255;
    public int tausta_g = 255;
    public int tausta_b = 255;

    public int aktiivinen_tausta_r = 230;
    public int aktiivinen_tausta_g = 230;
    public int aktiivinen_tausta_b = 230;

    public int teksti_r = 0;
    public int teksti_g = 0;
    public int teksti_b = 0;

    public boolean jaa_pohjaan = false;
    public boolean painettu = false;

    public Painike(String teksti, int x, int y) {
        this.teksti = teksti;
        this.x = x;
        this.y = y;
        if (teksti.length() < 4) {
            this.leveys = 40;
        }
        else {
            this.leveys = teksti.length()*10;
        }
        TUI.painikkeet.add(this);
    }

    public boolean kursori_kohdalla() {
        if (TUI.papplet.mouseX >= x && TUI.papplet.mouseX <= x + leveys &&
            TUI.papplet.mouseY >= y && TUI.papplet.mouseY <= y + korkeus) {
            return true;
        }
        else {
            return false;
        }
    }

    public void piirra() {
        if (painettu ||kursori_kohdalla()){
            if (painettu || TUI.papplet.mousePressed) {
                TUI.papplet.fill(teksti_r, teksti_g, teksti_b);
            }
            else {
                TUI.papplet.fill(aktiivinen_tausta_r, aktiivinen_tausta_g, aktiivinen_tausta_b);
            }
        }
        else {
            TUI.papplet.fill(tausta_r, tausta_g, tausta_b);
        }
        TUI.papplet.stroke(teksti_r, teksti_g, teksti_b);
        TUI.papplet.rect(x, y, leveys, korkeus, 10);

        if (painettu || (kursori_kohdalla() && TUI.papplet.mousePressed)) {
            TUI.papplet.stroke(aktiivinen_tausta_r, aktiivinen_tausta_g, aktiivinen_tausta_b);
            TUI.papplet.fill(aktiivinen_tausta_r, aktiivinen_tausta_g, aktiivinen_tausta_b);
        }
        else {
            TUI.papplet.stroke(teksti_r, teksti_g, teksti_b);
            TUI.papplet.fill(teksti_r, teksti_g, teksti_b);
        }

        TUI.papplet.textAlign(PConstants.CENTER, PConstants.CENTER);
        TUI.papplet.text(teksti, x + leveys/2, y + korkeus/2);

    }

    public void tausta_vari(int r, int g, int b) {
        this.tausta_r = r;
        this.tausta_g = g;
        this.tausta_b = b;
    }

    public void tausta_vari(int c) {
        tausta_vari(c, c, c);
    }

    public void aktiivinen_tausta_vari(int r, int g, int b) {
        this.aktiivinen_tausta_r = r;
        this.aktiivinen_tausta_g = g;
        this.aktiivinen_tausta_b = b;
    }

    public void aktiivinen_tausta_vari(int c) {
        aktiivinen_tausta_vari(c, c, c);
    }

    public void teksti_vari(int r, int g, int b) {
        this.teksti_r = r;
        this.teksti_g = g;
        this.teksti_b = b;
    }

    public void teksti_vari(int c) {
        teksti_vari(c, c, c);
    }

    public void paina() {
        if (jaa_pohjaan) {
            if (painettu) painettu = false;
            else painettu = true;
        }
        napin_toiminto();
    }

    public void napin_toiminto() {
        System.out.println("Painiketta '" + teksti + "' painettu");
    }



}
