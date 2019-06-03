import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

class Individual {

    public ArrayList<Box> chromosome = new ArrayList<Box>();

        chromosome.add(new Box(4, 6, 2, 101));
        chromosome.add(new Box(3, 4, 3, 102));
        chromosome.add(new Box(4, 6, 5, 103));
        chromosome.add(new Box(6, 3, 4, 104));
        chromosome.add(new Box(4, 4, 5, 105));
        chromosome.add(new Box(3, 3, 7, 106));
        chromosome.add(new Box(4, 6, 5, 107));
        chromosome.add(new Box(4, 3, 5, 108));
        chromosome.add(new Box(4, 5, 8, 109));
        chromosome.add(new Box(6, 3, 5, 110));
        chromosome.add(new Box(4, 4, 3, 111));
        chromosome.add(new Box(4, 4, 3, 112));
        chromosome.add(new Box(4, 6, 5, 113));
        chromosome.add(new Box(3, 4, 6, 114));
        chromosome.add(new Box(4, 6, 5, 115));
        chromosome.add(new Box(5, 4, 8, 116));
        chromosome.add(new Box(4, 4, 5, 117));
        chromosome.add(new Box(3, 3, 5, 118));
        chromosome.add(new Box(4, 6, 4, 119));
        chromosome.add(new Box(3, 4, 5, 120));
        chromosome.add(new Box(4, 6, 5, 121));
        chromosome.add(new Box(3, 4, 4, 122));
        chromosome.add(new Box(4, 6, 5, 123));
        chromosome.add(new Box(6, 3, 5, 124));
        chromosome.add(new Box(7, 4, 7, 125));
        chromosome.add(new Box(3, 3, 5, 126));
        chromosome.add(new Box(4, 6, 2, 127));
        chromosome.add(new Box(4, 3, 5, 128));
        chromosome.add(new Box(4, 5, 5, 129));
        chromosome.add(new Box(6, 3, 3, 130));
     
        Collections.shuffle(chromosome);
    }
}
