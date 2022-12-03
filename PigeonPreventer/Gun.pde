public class Gun {
  private SoundFile shotSound;
  private SoundFile noAmmoSound;
  private SoundFile reloadSound;
  
  public int ammo;

  Gun() {
    ammo = 6;
    shotSound = new SoundFile(PigeonPreventer.this, "Audio/gunshot.mp3");
    noAmmoSound = new SoundFile(PigeonPreventer.this, "Audio/noAmmo.mp3");
    reloadSound = new SoundFile(PigeonPreventer.this, "Audio/reload.mp3");
  }

  void firstShot() {
    shotSound.play();
  }

  boolean shot() {
    if (!reloadSound.isPlaying()) {
      if (ammo > 0) {
        ammo--;
        shotSound.play();
        return true;
      } else {
        noAmmoSound.play();        
      }
    }
    return false;
  }

  void reload() {
    reloadSound.play();
    ammo = 6;
  }
  
  int getAmmo(){
    return ammo;
  }
}
