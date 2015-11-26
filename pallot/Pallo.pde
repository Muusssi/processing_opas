ArrayList<Pallo> kaikki_pallot = new ArrayList<Pallo>();

void piirra_kaikki_pallot() {
    for (int i=0; i<kaikki_pallot.size(); i++) {
        kaikki_pallot.get(i).piirra();
    }
}

void liikuta_kaikkia_palloja() {
    for (int i=0; i<kaikki_pallot.size(); i++) {
        kaikki_pallot.get(i).liiku();
    }
}


public class Pallo {

    float x,y;
    float x_nopeus = 0;
    float y_nopeus = 0;
    float halkaisija;
    float putoamis_kiihtyvyys = 0;

    public Pallo (float x, float y, float halkaisija) {
        this.x = x;
        this.y = y;
        this.halkaisija = halkaisija;
        kaikki_pallot.add(this);
    }

    void liiku() {
        x += x_nopeus;
        y += y_nopeus;
        y_nopeus += putoamis_kiihtyvyys;
    }

    void piirra() {
        ellipse(x, y, halkaisija, halkaisija);
    }

    boolean on_ulkona() {
        if (x+halkaisija/2 < 0 || x-halkaisija > width) {
            return true;
        }
        if (y+halkaisija/2 < 0 || y-halkaisija > height) {
            return true;
        }
        return false;
    }

}


public class PomppuPallo extends Pallo {
    float vaimennus = 0.995;

    public PomppuPallo(float x, float y, float halkaisija) {
        super(x, y, halkaisija);
    }

    void liiku() {
        x += x_nopeus;
        y += y_nopeus;
        if ((x-halkaisija/2 < 0 && x_nopeus < 0) || (x+halkaisija/2 > width && x_nopeus > 0)) {
            x_nopeus = -x_nopeus*vaimennus;
        }
        if ((y-halkaisija/2 < 0 && y_nopeus < 0) || (y+halkaisija/2 > height && y_nopeus > 0)) {
            y_nopeus = -y_nopeus*vaimennus;
        }
        else {
            y_nopeus += putoamis_kiihtyvyys;
        }
    }
}

public class RandomPallo extends Pallo {

    float maksimi_nopeus = 4;

    public RandomPallo(float halkaisija) {
        super(0, 0, halkaisija);
        float laita = random(4);
        if (laita < 1) {
            x = 0;
            y = random(height);
        }
        else if (laita < 2) {
            x = width;
            y = random(height);
        }
        else if (laita < 3) {
            x = random(width);
            y = 0;
        }
        else {
            x = random(width);
            y = height;
        }
    }

    public void liiku() {
        x_nopeus = constrain(x_nopeus+random(-1,1), -maksimi_nopeus, maksimi_nopeus);
        y_nopeus = constrain(y_nopeus+random(-1,1), -maksimi_nopeus, maksimi_nopeus);
        x = constrain(x+x_nopeus, 0, width);
        y = constrain(y+y_nopeus, 0, height);
        if (x < halkaisija) {
            x_nopeus += 1;
        }
        else if (x > width-halkaisija) {
            x_nopeus -= 1;
        }
        if (y < halkaisija) {
            y_nopeus += 1;
        }
        else if (y > height-halkaisija) {
            y_nopeus -= 1;
        }
    }

}









