// PONG MENTAL 2
// PROJETO HACKLAB 2011

// bibliotecas
import hypermedia.video.*;
import codeanticode.gsvideo.*;
import java.awt.Rectangle;

// 
public final boolean MOSTRAIMAGEM = false;

// constants
public final int BALLDIM = 50;
public final int PADDLESCALE = 5;
public final int CVSF = 5; // cv scale factor: fator para analise do OpenCV dado a resolucao do video que vc quer assistir

OpenCV opencv;
GSCapture cam;

BolaQuadrada aBola;
ArrayList paddles;

void setup() {
  size (960, 580);
  frameRate(30);
  smooth();

  cam = new GSCapture(this, width, height);
  cam.start();
  //cam.play();
  opencv = new OpenCV(this);
  opencv.allocate(width/CVSF, height/CVSF);

  // Load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_DEFAULT );

  // paddles
  paddles = new ArrayList();
  // bouncing ball
  aBola = new BolaQuadrada(BALLDIM/2);
}

/*
void captureEvent(GSCapture c) {
 c.read();
 }
 */

void draw() {
  println(frameRate);
  background(0);

  if (cam.available()) {
    cam.read();
  }

  PImage camtemp = new PImage(cam.getImage());
  camtemp.resize(width/CVSF, 0);
  opencv.copy(camtemp);

  // Detecçao de rostos
  opencv.flip(OpenCV.FLIP_HORIZONTAL);
  Rectangle[] faces = opencv.detect(1.2, 3, OpenCV.HAAR_DO_CANNY_PRUNING, 30, 30);

  // Mostra imagem
  if (MOSTRAIMAGEM) {
    pushMatrix();
    scale(-1, 1);
    image(cam, -cam.width, 0);
    popMatrix();
  }

  // se existir mais bolas que caras
  for (int i=faces.length; i<paddles.size(); i++) {
    paddles.remove(i);
  }

  // se existir mais caras que bolas
  for (int i=paddles.size(); i<faces.length; i++) {
    paddles.add(i, new Paddle(1, 1, BALLDIM));
  }

  // set paddle location and dimensions
  for (int i=0; i<faces.length; i++) {
    Paddle p = (Paddle)paddles.get(i);
    p.set((faces[i].x+faces[i].width/2)*CVSF, (faces[i].y+faces[i].height/2)*CVSF, faces[i].width*CVSF/PADDLESCALE, faces[i].height*CVSF);
  }

  // move ball
  aBola.move();

  // check for collisions
  for (int i=0; i< paddles.size(); i++) {
    Paddle p = (Paddle)paddles.get(i);

    if (aBola.colisao(p) == true) {
      // create a new graphic image of the same size as the face
      PGraphics faceGraphic = createGraphics((int)max(p.getW()*PADDLESCALE, p.getH()), (int)max(p.getW()*PADDLESCALE, p.getH()), P2D);

      // grab the camera image
      PImage pim = new PImage(cam.getImage());

      // copy the right pixels. some hacks to deal with mirror-ness of the camera
      faceGraphic.beginDraw();
      faceGraphic.background(255, 0);
      faceGraphic.copy(pim, (int)(pim.width-p.getX()-p.getW()*PADDLESCALE/2), (int)(p.getY()-p.getH()/2), faceGraphic.width, faceGraphic.height, 0, 0, faceGraphic.width, faceGraphic.height);

      // fuck this!!!
      faceGraphic.scale(-1, 1);
      faceGraphic.image(new PImage(faceGraphic.getImage()), -faceGraphic.width, 0);
      faceGraphic.resetMatrix();
      faceGraphic.endDraw();

      // have pgraphic, send it to bouncing ball...
      aBola.setGraphic(faceGraphic);
    }

    // mostra a paddle
    p.display();
  }
  // mostra a bola
  aBola.display();
}

void keyReleased() {
  if (key == 'r') {
    aBola.resetFaces();
  }
}

public void stop() {
  opencv.stop();
  super.stop();
}

