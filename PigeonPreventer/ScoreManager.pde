class ScoreManager {

  private String pathToFile;
  private PrintWriter writer;
  private String name = "Enter name";
  private String[] lines;
  private boolean firstC = true;

  public ScoreManager(String pathToFile) {
    this.pathToFile = pathToFile;
  }

  public String getHighscore() {
     lines = loadStrings(pathToFile + "/score.txt");

    int topScore1 = 0;
    String highscoreText1 = "";

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].length() > 0) {
        String name = lines[i].substring(0, lines[i].indexOf(";"));
        String score = lines[i].substring(lines[i].indexOf(";") + 1);
        if (parseInt(score) > topScore1) {
          highscoreText1 = score + " by " + name;
          topScore1 = parseInt(score);
        }
      }
    }
    return highscoreText1;
  }

  public void addStringToName(String s) {
    if (firstC) {
      name = s;
      firstC = false;
    }
    else name += s;
  }

  public void clearString() {
    name = "";
  }

  public String getNameString() {
    return name;
  }


  public void writeScore(String score) {
    this.writer = createWriter(pathToFile + "/score.txt");
    for(int i = 0; i < lines.length; i++) {
      writer.println(lines[i]);
    }
    writer.println(name + ";" + score);
    writer.flush();
    writer.close();
    firstC = true;
    name = "Enter your name";

  }
}
