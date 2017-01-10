// TODO: eventually this should implement a 'resource' interface
class pixmap {
  private int width_;
  private int height_;
  
  private color[][] tiles_;
  
  
  pixmap(int width, int height) {
    width_ = width;
    height_ = height;
  
    tiles_ = new color[width_][height_];
    for (int y = 0; y < height_; ++y) {
      for (int x = 0; x < width_; ++x) {
        tiles_[x][y] = color(255,255,255,255);
      }
    }
  }
  
  void setColor(color c, int x, int y) {
    // TODO: A better way to draw would be to group
    // by adjacent tiles by color, thus reducing
    // the number of required tiles.
    tiles_[x][y] = c;
  }
  
  int getWidth() { return width_; }
  int getHeight() { return height_; }
  color[][] getTiles() { return tiles_; }
}