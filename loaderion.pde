import peasy.*;

Container container;
LoadListener loadListener;
int[][][] result;
int[][][] preResult;
Individual boxes;
color[] colors;
PeasyCam cam;
boolean resultReady = false;
boolean processStarted = false;

color bgColor = color(0, 0, 0), 
  primaryColor = color(255, 255, 255);

int fRate = 60;

void setup() {
  
  

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  frameRate(fRate);
  background(bgColor);

  loadListener = new LoadListener() {
    public void loadCompleted() {
      result = container.getContainer();
      print("sonuç geldi = " + result);
      resultReady = true;
      processStarted = false;
    }

    public void onStep() {
      preResult = container.getContainer();

      if (boxes == null || boxes.chromosome.isEmpty()) {
        boxes = container.population.get(0);
        colors = new color[boxes.chromosome.size()];
        int i = 0;
        for (Box box : boxes.chromosome) {
          colors[i] = color(random(0, 255), random(0, 255), random(0, 255));
          i++;
        }
      }
    }
  };

  container = new Container(loadListener);
}

public void settings() {
  size(640, 360, "processing.opengl.PGraphics3D");
   fullScreen("processing.opengl.PGraphics3D");
}

int getIndex(int id) {
  if (boxes == null || boxes.chromosome == null) return -1;

  int i = 0;
  for (Box box : boxes.chromosome) {
    if (box.id == id)
      return i;

    i++;
  }

  return -1;
}

void requestData() {
  container.start();

  boxes = container.population.get(0);
  colors = new color[boxes.chromosome.size()];
  int i = 0;
  for (Box box : boxes.chromosome) {
    colors[i] = color(random(0, 255), random(0, 255), random(0, 255));
    i++;
  }
  processStarted = true;
}

void draw() {
  //print("draw");
  background(0);
  noStroke();
  ambientLight(220, 64, 255);
  directionalLight(128, 200, 64, 0, 0, -1);
  fill(255);
  text("FRONT", 100,0);
  fill(255);
  text("BACK", 100,0,-300);

  if (!resultReady && !processStarted) {
    print("process başlatılıyor\n");
    processStarted = true;
    thread("requestData");
  } else if (processStarted) {
    //print("gelinen aşama gösteriliyor\n");
    if (preResult != null) {
      for (int k = 0; k < container.length; k++) {
        for (int j = 0; j < container.height; j++) {
          for (int i = 0; i < container.width; i++) {
            if (preResult[i][j][k] != 100) {
              pushMatrix();
              translate(i * -10, j * -10, k * -10);
              rotateY(0);
              rotateX(0);
              noStroke();
              //stroke(255);
              int colorIndex = getIndex(preResult[i][j][k]);
              if (colorIndex != -1)
                fill(colors[colorIndex]);
              box(10);
              popMatrix();
            } else {
              pushMatrix();
              translate(i * -10, j * -10, k * -10);
              rotateY(0);
              rotateX(0);
              //noStroke();
              stroke(255);
              noFill();
              box(10);
              popMatrix();
            }
          }
        }
      }
    }
  } else {
    print("sonuç gösteriliyor");
    for (int k = 0; k < container.length; k++) {
      for (int j = 0; j < container.height; j++) {
        for (int i = 0; i < container.width; i++) {
          if (container.container[i][j][k] != 100) {
            pushMatrix();
            translate(i * 10, j * 10, k * 10);
            rotateY(0);
            rotateX(0);
            stroke(255);
            fill(colors[getIndex(container.container[i][j][k])]);
            box(10);
            popMatrix();
          } else {
            pushMatrix();
            translate(i * 10, j * 10, k * 10);
            rotateY(0);
            rotateX(0);
            stroke(255);
            noFill();
            box(10);
            popMatrix();
          }
        }
      }
    }
  }
}
