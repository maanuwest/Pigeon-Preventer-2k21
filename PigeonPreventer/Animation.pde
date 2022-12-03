public class Animation {
  PImage[] images;
  private int count;
  private float frame;
  private int size;
  private float speed;
  private boolean flip;

  Animation(String pathAndName, String fileType, int count, int size, float speed, boolean flip) {
    this.size = size;
    this.count = count;
    this.speed = speed;
    this.flip = flip;
    images = new PImage[count];
    for (int i = 0; i < count; i++) {
      images[i] = loadImage(pathAndName + i + fileType);
      images[i].resize(size, size);
    }
  }

  void displayLoop(PVector pos) {
    frame = (frame + speed) % count;
    push();
    translate(pos.x, pos.y);
    if (flip) {
      scale(-1, 1);
    }
    image(images[(int)frame], 0, 0);
    pop();
  }
  
  void setRandomFrame() {
    frame = random(0, count);
  }

  boolean display(PVector pos, int alpha) {
    frame = (frame + speed);
    if (frame < count) {
      push();
      translate(pos.x, pos.y);
      alpha(alpha);
      if (flip) {
        scale(-1, 1);
      }
      image(images[(int)frame], 0, 0);
      pop();
      return true;
    } 
    frame = 0;
    return false;
  }

  int getFrame() {
    return (int)frame;
  }
}
