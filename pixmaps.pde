pixmap ship_pixmap() {
    pixmap pix_ = new pixmap(5,3);
    
    pix_.setColor(color(255,0,0), 0, 2);
    pix_.setColor(color(255,0,0), 1, 2);
    pix_.setColor(color(255,0,0), 2, 2);
    pix_.setColor(color(255,0,0), 3, 2);
    pix_.setColor(color(255,0,0), 4, 2);
  
    pix_.setColor(color(255,0,0), 0, 1);
    pix_.setColor(color(255,0,0), 1, 1);
    pix_.setColor(color(255,0,0), 2, 1);
    pix_.setColor(color(255,0,0), 3, 1);
    pix_.setColor(color(255,0,0,0), 4, 1);
    
    pix_.setColor(color(255,0,0), 0, 0);
    pix_.setColor(color(255,0,0,0), 1, 0);
    pix_.setColor(color(255,0,0,0), 2, 0);
    pix_.setColor(color(255,0,0,0), 3, 0);
    pix_.setColor(color(255,0,0,0), 4, 0);
    
    return pix_;
}

pixmap bandit_pixmap() {
  pixmap pix_ = new pixmap(4,4);
  for (int y = 0; y < 4; ++y) {
    for(int x = 0; x < 4; ++x) {
      pix_.setColor(color(255,255,0), x, y);
    }
  }
  
  return pix_;
}

pixmap bullet_pixmap() {
  pixmap pix_ = new pixmap(3,1);
  pix_.setColor(color(0,255,0), 0, 0);
  pix_.setColor(color(0,255,0), 1, 0);
  pix_.setColor(color(0,255,0), 2, 0);
  return pix_;
}