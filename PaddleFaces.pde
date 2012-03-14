
public class PaddleFaces {
  private ArrayList faces;
  private int numOfFaces;
  private PImage theFace;
  private final int maxFaces = 10;
  private float faceDim;

  private PVector pos;

  public PaddleFaces(float dim) {
    faces = new ArrayList(maxFaces);
    for (int i=0; i<maxFaces; i++) {
      faces.add(null);
    }

    numOfFaces = 0;
    faceDim = dim;
    theFace = this.getNewBlankImage();
  }

  // on reset: reset number of faces, and get blank image
  public void resetFaces() {
    numOfFaces = 0;
    theFace = this.getNewBlankImage();
  }

  private PImage getNewBlankImage() {
    PGraphics tpg = createGraphics((int)faceDim, (int)faceDim, P2D);
    tpg.beginDraw();
    tpg.background(0, 0);
    tpg.endDraw();

    return (new PImage(tpg.getImage()));
  }

  // assume face is always up to date.
  //   pretty good assumption since everytime it hits something it should 
  //   also update 
  public PImage getFace() {
    return theFace;
  }

  private void genFace() {
    // when numOfFace < maxFace, only add up to numOfFaces
    for (int i=0; i < min(numOfFaces,maxFaces); i++) {
      PImage tpi = (PImage)faces.get(i);
      //this.setAlpha(tpi, 255/min(numOfFaces, maxFaces)+1);
      theFace.blend(tpi, 0, 0, tpi.width, tpi.height, 0, 0, theFace.width, theFace.height, BLEND);
    }
  }

  // add a face and up the face counter.
  public void addFace(PImage newFace) {
    this.setAlpha(newFace, 255/min(numOfFaces+1, maxFaces)+1);
    faces.set(numOfFaces%maxFaces, newFace);
    numOfFaces += 1;
    this.genFace();
  }

  // set alpha on image pim
  private void setAlpha(PImage pim, int a) {
    a = constrain(a, 0, 255);
    pim.loadPixels();
    for (int i=0; i<(pim.width*pim.height); i++) {
      if (alpha(pim.pixels[i]) > 5) {
        pim.pixels[i] = color(red(pim.pixels[i]), green(pim.pixels[i]), blue(pim.pixels[i]), a);
      }
    }
    pim.updatePixels();
  }
}

