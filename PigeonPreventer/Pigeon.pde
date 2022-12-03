public class Pigeon
{
  PVector pos;
  int size;
  float velocity;
  PImage imgPigeon;

  boolean dead = false;
  
  String[] screamUrls = {"Audio/scream.mp3", "Audio/scream2.mp3"};
  SoundFile scream;
  SoundFile wingFlutter;

  Animation flyAnimation;
  Animation dyingAnimation;

  int PIGEON_MIN_SIZE = 30;
  int PIGEON_MAX_SIZE = 100;

  Pigeon(float x, float y, float velocity) {
    this.pos = new PVector(x, y);
    this.velocity = velocity;
    this.size = (int)random(PIGEON_MIN_SIZE, PIGEON_MAX_SIZE);
    boolean flip = false;
    if (velocity > 0) flip = true;

    scream = new SoundFile(PigeonPreventer.this, screamUrls[round(random(-0.4, 1.4))]);
    wingFlutter = new SoundFile(PigeonPreventer.this, "Audio/WingsFlutter.mp3");

    flyAnimation = new Animation("Assets/pigeon/flying/pigeon", ".png", 4, size, 0.2, flip);
    flyAnimation.setRandomFrame();
    dyingAnimation = new Animation("Assets/pigeon/explosion/feather", ".png", 8, size, 0.2, flip);
  }

  void setPos(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  void calcFlyingPos() {
    pos.x = pos.x + velocity;
    pos.y = pos.y + (float)Math.cos((flyAnimation.getFrame()+1)*90);

    if (pos.x < -50 && velocity < 0) {
      pos.x = width + 50;
      pos.y = random(100, height - 100);
    } else if (pos.x > width + 50 && velocity > 0) {
      pos.x = -50;
      pos.y = random(100, height - 100);
    }
  }

  void calcDyingPos() {
    pos.x = pos.x + (float)Math.cos((dyingAnimation.getFrame()+1)*90);
    pos.y = pos.y + 5;
  }

  int gotShot(PVector mousePos) {
    if (pos.dist(mousePos) < size / 2) {
      dead = true;
      scream.play();
      wingFlutter.play();
      return (int)(50 - Math.abs(this.size * 10 * (1 / this.velocity * 10)*2)/400);
    }
    return 0;
  }

  void spawn() {
    if (velocity < 0) {
      pos.x = width + 50;
      pos.y = random(140, height - 140);
    } else {
      pos.x = -50;
      pos.y = random(140, height - 140);
    }
  }

  void render() {
    if (!dead) {
      calcFlyingPos();
      flyAnimation.displayLoop(pos);
    } else if (dead) {
      calcDyingPos();
      if (!dyingAnimation.display(pos, 127)) {
        dead = false;
        spawn();
      }
    }
  }
}
