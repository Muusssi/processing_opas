package tui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import processing.core.PApplet;

public abstract class TUI {
    protected static PApplet papplet;
    protected static ArrayList<Painike> painikkeet = new ArrayList<Painike>();
    protected static HashMap<Integer, Boolean> paietut_napit = new HashMap<Integer, Boolean>();

    public static void aloita(PApplet papplet) {
        TUI.papplet = papplet;
    }




    // Nappitarkkailija
    public static boolean nappain_painettu(int painike) {
        if (paietut_napit.containsKey(painike) ) {
            return paietut_napit.get(painike);
        }
        return false;
    }

    public static void huomaa_painallus() {
        paietut_napit.put(TUI.papplet.keyCode, true);

    }

    public static void huomaa_vapautus() {
        paietut_napit.put(TUI.papplet.keyCode, false);
    }

    public static void huomaa_hiiren_painallus() {
        Iterator<Painike> itr = painikkeet.iterator();
        while (itr.hasNext()) {
            Painike painike = itr.next();
            if (painike.kursori_kohdalla()) {
                painike.paina();
            }
        }
    }

    public static void piirra_painikkeet() {
        Iterator<Painike> itr = painikkeet.iterator();
        while (itr.hasNext()) {
            itr.next().piirra();
        }
    }

}
