import processing.sound.*; //<>//

PImage splash;
PImage background;
PImage window;
PImage crosshair;
PImage imgAmmo;
PImage pressAnyKey;
PImage infoScreen;
PImage highscore;

Pigeon[] pigeons;
Gun gun;
int score;
int pigeonCount = 15;
ScoreManager scoreManager;

int startTime;
int roundTime = 30000;

PFont sancreek;

SoundFile backgroundMusic;
SoundFile startGame;

int game_state = 0;

boolean loaded = false;
boolean showSplash = true;
boolean showPressAnyKey = true;
boolean showInfoScreen = false;

void settings() {
  //set window size
  size(1280, 720);
}

void setup() {
  frameRate(30);
  imageMode(CENTER);

  splash = loadImage("Assets/loadingScreen.png");
  pressAnyKey = loadImage("Assets/pressAnyKey.png");
  image(splash, width/2, height/2);

  sancreek = createFont("fonts/Sancreek-Regular.ttf",40);

  //load scene
  backgroundMusic = new SoundFile(this, "Audio/Cantina Rag.mp3");
  backgroundMusic.loop();

  noCursor();
}

void draw() {
  if (game_state == 0) {
    image(splash, width/2, height/2);
    image(pressAnyKey, width/2, height-150);

    if (!loaded) {
      // load images
      infoScreen = loadImage("Assets/infoscreen.png");
      highscore = loadImage("Assets/scoreboardScreen.png");
      background = loadImage("Assets/backgroundScene.png");
      window = loadImage("Assets/window.png");
      crosshair = loadImage("Assets/crosshair.png");
      imgAmmo = loadImage("Assets/ammo.png");
      imgAmmo.resize(40, 40);

      startGame = new SoundFile(this, "Audio/startgame.mp3");
      scoreManager = new ScoreManager("Score");
      // crosshair setup
      crosshair.resize(64, 64);

      //load gun
      gun = new Gun();

      //load pigeon
      pigeons = new Pigeon[pigeonCount];
      for (int i = 0; i < pigeonCount; i++) {
        float v = random(1, 6);
        if (i % 2 == 0) v *= -1;

        pigeons[i] = new Pigeon(random(0, width), random(140, height - 140), v);
      }
      loaded = true;
      println("loaded");
    }
  } else if (game_state == 1) {
    image(infoScreen, width/2, height/2);
  } else if (game_state == 2) {

    //draw background
    image(background, width/2, height/2);

    //draw pigeon
    for (int i = 0; i < pigeonCount; i++) {
      pigeons[i].render();
    }
    image(window, width/2, height/2);
    drawAmmo();
    image(crosshair, mouseX, mouseY);
    textFont(sancreek);
    text("Score: " + score, 100, 683);

    int time = getTimer();
    if (time < 0) {
      game_state = 3;
      delay(300);  
    }
    text("Time: " + time/1000, 350, 683);
    fill(69, 56, 124);
    textSize(44);
  } else if (game_state == 3) {
    image(highscore, width/2, height/2);
    text("Current high score: ", 200, 300);
    text(scoreManager.getHighscore(), 670, 300);
    text("Your final score: ", 200, 380);
    text(score, 670, 380);
    text("Your name: ", 200, 460);
    text(scoreManager.getNameString(), 670, 460);
    fill(255, 255, 0);
  }
}

void mousePressed() {
  if (!showSplash && loaded && game_state == 2) {
    if (gun.shot()) {
      for (int i = 0; i < pigeonCount; i++) {
        score += pigeons[i].gotShot(new PVector(mouseX, mouseY));
      }
    }
  }
  if (game_state == 3) {
    if (!scoreManager.getNameString().equals("Enter name") && scoreManager.getNameString().length() > 0) {
      gun.reload();
      scoreManager.writeScore(str(score));
      game_state = 2;
      score = 0;
      startTime = millis();      
      // create new Pigeons
      for (int i = 0; i < pigeonCount; i++) {
        pigeons[i].dead = false;
        pigeons[i].spawn();
      }
    }
  }
}

void keyPressed() {
  if (game_state == 0 && loaded) {
    gun.firstShot();
    showSplash = false;
    showPressAnyKey = false;
    showInfoScreen = true;
    game_state = 1;
  } else if (game_state == 1) {
    startGame.play();
    game_state = 2;
    startTime = millis();
  } else if (game_state == 2) {
    if (key == 'r') {
      gun.reload();
    }
  } else if (game_state == 3) {
    if (key == BACKSPACE) scoreManager.clearString();
    else {
      if (key != ENTER) scoreManager.addStringToName(str(key));
    }
  }
}

void drawAmmo() {
  int ammo = gun.getAmmo();
  for (int i = 0; i<ammo; i++) {
    image(imgAmmo, (880 + i*30), 670);
  }
}

int getTimer() {
  return roundTime - (millis() - startTime);
}
