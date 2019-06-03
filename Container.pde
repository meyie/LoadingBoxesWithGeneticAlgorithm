import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

public class Container {

    final public int crossoverRate = 85;
    final public int mutationRate = 15;
    final public int populationSize = 20;
    final public int elitismCount = 2;
    final public int maxLoop = 1000;
    final public int width = 10;
    final public int height = 10;
    final public int length = 30;
    final public int[][][] container = new int[width][height][length];
    private ArrayList<Individual> population = new ArrayList<Individual>();
    private Individual temp1 = new Individual();
    private Individual temp2 = new Individual();
    private LoadListener loadListener;
    
    public Container(LoadListener loadListener) {
      this.loadListener = loadListener;  
    }
    
    public int[][][] getContainer() {
      return this.container;
    }
    
    public void start() {
        int gCountwithoutChange=0;                                                                                     //efficiency artmayan generation sayısını tutar
        boolean runOnce = true;                                                                                        
        int tempVolume=0;                                                                                              //Loaded box volume ü tutan değer
        int ic=1;                                                                                                      //generation count
        
        for (int i = 0; i < populationSize; i++) {
            population.add(new Individual());
        }
        
        int totalBoxVolume = 0;
        for (Box box : population.get(0).chromosome) {
            totalBoxVolume = totalBoxVolume + box.getVolume();
        }

        //for (int i = 0; i < maxLoop; i++) {
            while(gCountwithoutChange<50){                                                                              //kaç generation değişmezse sonlanıcak sınırı işte onu arttırıp azaltabilirsin
            sortPopulation(population);
            empty();

            for (int j = elitismCount; j < population.size(); j++) {
                Random r = new Random();
                int a = r.nextInt(100) + 1;
                if (a <= crossoverRate) {
                    crossover(population.get(j), roulette());
                    mutation(temp1);
                    mutation(temp2);

                    if (getEfficiency(temp1) > getEfficiency(temp2)) {
                        population.set(j, temp1);
                    } else {
                        population.set(j, temp2);
                    }
                    temp1 = new Individual();
                    temp2 = new Individual();
                }
            }
            empty();
            sortPopulation(population);
            
            if(runOnce){
              tempVolume=getEfficiency(population.get(0));                                                                //tempVolume e değer atamak için tek seferlik çalışan kısım.
              runOnce=false;
            }
            
            System.out.println("Generation: " + ic);
            System.out.println("Loaded Volume/Box Volume/Total Volume: " + getEfficiency(population.get(0)) + "/"+ totalBoxVolume + "/" + width * height * length);

            if(getEfficiency(population.get(0))>tempVolume){
              tempVolume=getEfficiency(population.get(0));                                                                //yeni generation ın efficiency si daha yüksekse tempvolume e onu ata ve gcount u sıfırla
              gCountwithoutChange=0;
            }
            else if(getEfficiency(population.get(0))<=tempVolume){
              gCountwithoutChange++;                                                                                      //yeni generation ın efficiency si daha yüksek değilse gcount u arttır.
            }
            
            ic++;                                                                                                        //hocam senin for döngüsü yerine while koyunca generation count u bununla tutyom kusura bakma.
            
            for(Box box: population.get(0).chromosome){
              load(box);
            }
            
            loadListener.onStep();
            
            if (getEfficiency(population.get(0)) == width * height * length) {
                break;
            }
            
            if (getEfficiency(population.get(0)) == totalBoxVolume) {
                break;
            }
        }

        System.out.println();
        System.out.println("#########################################################################################");
        System.out.print("Best Order of Loading: ");
        for(Box box: population.get(0).chromosome){
          load(box);                                                                                                     //bi alttaki for döngüsündeki kutuların getIsLoaded() fonksyonlarını çağırmak için bi Load etmek gerekti son popülasyonu.
        }
        int onboardbox=0;                                                                                                //yerleştirilen kutu sayısını tutuyo
        for (Box box : population.get(0).chromosome) {
          if(box.getIsLoaded()==true){
            System.out.print(box.id + " ");                                                                              //kutu getIsLoaded dan true döndürürse yerleştirildi demek yani onu sıraya yazabiliriz. false olanları yazmıyor :)
            onboardbox++;
          }
        }
    
        System.out.println();
        System.out.println("Total Loaded Box Count: " + onboardbox);
        System.out.println("Total Box Volume: " + totalBoxVolume);
        System.out.println("Total Container Volume: " + width * height * length);
        System.out.println("Loaded Box Volume: " + getEfficiency(population.get(0)));
        System.out.println("#########################################################################################");
        
        print("start bitti");
        
        for(Box box: population.get(0).chromosome){
          load(box);
        }
       
        loadListener.loadCompleted();
    }

    private Individual roulette() {
        int a = population.size() * population.size();
        Random r = new Random();
        int b = r.nextInt(a);
        Double x = Math.sqrt(b);
        int y = x.intValue();

        return population.get(population.size() - y - 1);
    }

    private void sortPopulation(ArrayList<Individual> population) {
        for (int i = 0; i < population.size(); i++) {
            for (int j = 0; j < population.size(); j++) {
                if (getEfficiency(population.get(j)) < getEfficiency(population.get(i))) {
                    Collections.swap(population, i, j);
                }
            }
        }
    }

    private void empty() {
        for (int k = 0; k < length; k++) {
            for (int j = 0; j < height; j++) {
                for (int i = 0; i < width; i++) {
                    container[i][j][k] = 100;
                }
            }
        }

        for (Individual ind : population) {
            for (Box box : ind.chromosome) {
                box.isLoaded = false;
            }
        }
    }

    private boolean isAvailable(int x, int y, int z, int a, int b, int c) {

        for (int k = z; k < c + z; k++) {
            for (int j = y; j < b + y; j++) {
                for (int i = x; i < a + x; i++) {
                    if (x + a > width) {
                        return false;
                    } else if (y + b > height) {
                        return false;
                    } else if (z + c > length) {
                        return false;
                    } else if (container[i][j][k] != 100) {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    private void load(Box box) {

        boolean scanned = false;
        while ((!box.isLoaded) && (!scanned)) {

            for (int k = 0; k < length; k++) {
                for (int j = 0; j < height; j++) {
                    for (int i = 0; i < width; i++) {
                        if (isAvailable(i, j, k, box.width, box.height, box.length)) {
                            for (int d = k; d < box.length + k; d++) {
                                for (int s = j; s < box.height + j; s++) {
                                    for (int a = i; a < box.width + i; a++) {
                                        container[a][s][d] = box.id;
                                    }
                                }
                            }

                            box.isLoaded = true;
                            return;
                        }
                    }
                }
            }
            scanned = true;
        }
        //System.out.println("There in no enough space for Box " + box.id + "(" + box.width + "," + box.length + ")");
    }

    private void crossover(Individual p1, Individual p2) {
        Random r = new Random();
        int place = r.nextInt(p1.chromosome.size() - 1);
        //System.out.println("place" + place);

        for (int i = 0; i < place; i++) {
            temp2.chromosome.set(i, p1.chromosome.get(i));
            temp1.chromosome.set(i, p2.chromosome.get(i));
        }

        for (int j = place; j < p1.chromosome.size(); j++) {
            boolean isThere1 = false;
            boolean isThere2 = false;

            for (int i = 0; i < place; i++) {

                if (temp1.chromosome.get(i).id == p1.chromosome.get(j).id) {
                    isThere1 = true;
                }

                if (temp2.chromosome.get(i).id == p2.chromosome.get(j).id) {
                    isThere2 = true;
                }
            }

            if (!isThere1) {
                temp1.chromosome.set(j, p1.chromosome.get(j));
            } else {
                temp1.chromosome.set(j, new Box(10, 10, 5, 999));
            }

            if (!isThere2) {
                temp2.chromosome.set(j, p2.chromosome.get(j));
            } else {
                temp2.chromosome.set(j, new Box(10, 10, 5, 999));
            }
        }

        for (int i = 0; i < p1.chromosome.size(); i++) {
            if (temp1.chromosome.get(i).id == 999) {
                temp1.chromosome.set(i, getMissing(p1, temp1));
            }
        }

        for (int i = 0; i < p1.chromosome.size(); i++) {

            if (temp2.chromosome.get(i).id == 999) {
                temp2.chromosome.set(i, getMissing(p2, temp2));
            }
        }
    }

    private void mutation(Individual ind) {
        Random r = new Random();
        int a1 = r.nextInt(ind.chromosome.size());
        int a2 = r.nextInt(ind.chromosome.size());
        int a3 = r.nextInt(100) + 1;

        if (a3 <= mutationRate) {
            Collections.swap(ind.chromosome, a2, a1);
        }
    }

    private int getEfficiency(Individual individual) {
        int empty = 0;

        empty();
        for (Box box : individual.chromosome) {
            load(box);
        }

        for (int k = 0; k < length; k++) {
            for (int j = 0; j < height; j++) {
                for (int i = 0; i < width; i++) {
                    if (container[i][j][k] == 100) {
                        empty++;
                    }
                }
            }
        }


        empty();

        return width * height * length - empty;
    }

    private Box getMissing(Individual parent, Individual child) {
        for (Box box1 : parent.chromosome) {
            boolean isThere = false;
            for (Box box2 : child.chromosome) {
                if (box1.id == box2.id) {
                    isThere = true;
                }
            }
            if (!isThere) {
                return box1;
            }
        }
        return new Box(10, 10, 5, 777);
    }
}
