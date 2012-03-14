//classe Bola
public final int BALLVEL = (int)frameRate/2;

public class BolaQuadrada {
  private float ballR;
  private PVector vel, pos;

  PGraphics pg;

  PaddleFaces pf;

  // constructor
  public BolaQuadrada(float fr) {
    ballR = fr;
    vel = new PVector((random(-1, 1)<0)?(-BALLVEL):(BALLVEL), (random(-1, 1)<0)?(-BALLVEL):(BALLVEL));
    pos = new PVector(random(ballR, width-ballR), random(ballR, height-ballR));

    pg = null;
    pf = null;
  }

  public float getX() {
    return pos.x;
  }
  public float getY() {
    return pos.y;
  }
  public float getDim() {
    return ballR*2;
  }

  public void move() {
    pos.add(vel);

    // using vectors
    if ((pos.x > width-ballR)||(pos.x < ballR)) {
      vel.x = -vel.x;
      pos.x = constrain(pos.x, ballR, width-ballR);
    }
    if ((pos.y > height-ballR)||(pos.y < ballR)) {
      vel.y = -vel.y;
      pos.y = constrain(pos.y, ballR, height-ballR);
    }
  }

  public void set(float fx, float fy, float fr) {
    pos.set(fx, fy, 0.0f);
    ballR = fr;
  }

  public void resetFaces() {
    if (pf != null) {
      pf.resetFaces();
      pg.beginDraw();
      pg.background(255, 255);
      pg.endDraw();
    }

    // new random start
    pos.set(random(ballR, width-ballR), random(ballR, height-ballR), 0.0f);
    vel.set((random(-1, 1)<0)?(-BALLVEL):(BALLVEL), (random(-1, 1)<0)?(-BALLVEL):(BALLVEL), 0.0f);
  }

  public void setGraphic(PGraphics pg_) {
    if (pg == null) {
      pg = createGraphics((int)ballR*2, (int)ballR*2, P2D);
      pg.beginDraw();
      pg.background(255, 0);
      pg.endDraw();
    }
    if (pf == null) {
      pf = new PaddleFaces(ballR*2);
    }

    pg_.resize((int)ballR*2, (int)ballR*2);

    pf.addFace(new PImage(pg_.getImage()));

    // copy ballFace onto pg.
    pg.beginDraw();
    pg.background(255, 0);
    pg.copy(pf.getFace(), 0, 0, pg.width, pg.height, 0, 0, pg.width, pg.height);
    pg.endDraw();
  }


  public void display() {
    if (pg != null) {
      image(pg, pos.x-ballR, pos.y-ballR);
    }
    else {
      fill(255, 255);
      noStroke();
      rectMode(CENTER);
      rect(pos.x, pos.y, ballR*2, ballR*2);
    }
  }

  // colisao: verifica se bola bateu na paddle pp
  public boolean colisao(Paddle pp) {
    // vector with pos diff, points away from pp
    PVector posDiff = PVector.sub(pos, pp.getPos());

    // vector with the sum of the ball and paddle dimensions
    PVector dimSum = new PVector(ballR+pp.getW()/2, ballR+pp.getH()/2);

    // if overlapping...
    if ((abs(posDiff.x) < dimSum.x) && (abs(posDiff.y) < dimSum.y)) {

      // mutiply the diff vector by the shortest distance to an edge
      // posDiff now points from center of paddle to where ball should be
      posDiff.mult(min(abs(dimSum.x/posDiff.x), abs(dimSum.y/posDiff.y)));

      // move ball
      pos = PVector.add(pp.getPos(), posDiff);

      // side hit
      if (abs(posDiff.x)>=dimSum.x) {
        vel.x = ((posDiff.x<0)?-1.0:1.0) * abs(vel.x);
      }
      else {
        vel.y = ((posDiff.y<0)?-1.0:1.0) * abs(vel.y);
      }

      return true;
    }
    return false;
  }
  // colisao
}

