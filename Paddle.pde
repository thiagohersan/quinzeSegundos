//classe Paddle
public class Paddle {
  private float faceDim;
  private PVector pos, dim;

  // constructor
  public Paddle(float w, float h, float fd) {
    faceDim = fd;

    pos = new PVector(0,0);
    dim = new PVector(w, h);
  }

  // for paddle!
  public float getX() {
    return pos.x;
  }
  public float getY() {
    return pos.y;
  }
  public float getW() {
    return dim.x;
  }
  public float getH() {
    return dim.y;
  }
  public PVector getPos() {
    return pos;
  }

  public void set(float fx, float fy, float fw, float fh) {
    pos.set(fx, fy, 0.0f);
    dim.set(fw, fh, 0.0f);
  }

  // display a paddle
  public void display() {
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}

