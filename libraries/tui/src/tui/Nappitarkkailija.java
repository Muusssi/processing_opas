package tui;

import java.util.HashMap;

import processing.core.PApplet;

public abstract class Nappitarkkailija {


	private static PApplet papplet;

	private static HashMap<Integer, Boolean> paietut_napit = new HashMap<Integer, Boolean>();


	public static void aloita(PApplet papplet) {
	    Nappitarkkailija.papplet = papplet;
	}


	public static boolean painettu(int painike) {
	    if (paietut_napit.containsKey(painike) ) {
	        return paietut_napit.get(painike);
	    }
        return false;
	}

	public static void huomaa_painallus() {
        paietut_napit.put(papplet.keyCode, true);

	}

	public static void huomaa_vapautus() {
        paietut_napit.put(papplet.keyCode, false);
    }


}
