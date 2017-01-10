interface i_process {
void init();
  void update();
  void pause();
  void die();
  void sendEvent(event e);
  boolean isAlive();
  boolean isDead();
}