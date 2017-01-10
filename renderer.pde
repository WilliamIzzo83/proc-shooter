class set_fill_color implements command {
  public color color_;
  
  set_fill_color(int brightness) {
    color_ = color(clamp(brightness, 0, 255));
  }
  
  set_fill_color(int r, int g, int b) {
    color_ = color(clamp(r, 0, 255),
                   clamp(g, 0, 255),
                   clamp(b, 0, 255), 255);
  }
  
  set_fill_color(int r, int g, int b, int a) {
    color_ = color(clamp(r, 0, 255),
                   clamp(g, 0, 255),
                   clamp(b, 0, 255), 
                   clamp(a, 0, 255));
  }
  
  void execute() {
    fill(color_);
  }
}

class set_stroke_color implements command {
  public color color_;
  
  set_stroke_color(int brightness) {
    color_ = color(clamp(brightness, 0, 255));
  }
  
  set_stroke_color(int r, int g, int b) {
    color_ = color(clamp(r, 0, 255),
                   clamp(g, 0, 255),
                   clamp(b, 0, 255), 255);
  }
  
  set_stroke_color(int r, int g, int b, int a) {
    color_ = color(clamp(r, 0, 255),
                   clamp(g, 0, 255),
                   clamp(b, 0, 255), 
                   clamp(a, 0, 255));
  }
  
  void execute() {
    stroke(color_);
  }
}

class draw_rect implements command {
  public float x;
  public float y;
  public float w;
  public float h;
  
  draw_rect(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.w = width;
    this.h = height;
  }
  
  void execute() {
    rect(round(x), round(y), round(w), round(h));
  }
}

class draw_square implements command {
  public float x;
  public float y;
  public float size;
  
  draw_square(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void execute() {
    rect(round(x), round(y), round(size), round(size));
  }
}

class draw_pixmap implements command {
  public float offset_x;
  public float offset_y;
  public float scale;
  private pixmap pix_;
  
  draw_pixmap(float x, float y, float s, pixmap pixmap) {
    offset_x = x;
    offset_y = y;
    pix_ = pixmap;
    scale = s;
  }
  
  void execute() {
    int block_size = round(2.0 * scale);
    int x_cur = round(offset_x);
    int y_cur = round(offset_y);
    
    int width_ = pix_.getWidth();
    int height_ = pix_.getHeight();
    color[][] tiles_ = pix_.getTiles();
    
    
    
    for (int y = 0; y < height_; ++y) {
      for (int x = 0; x < width_; ++x) {
        color c = tiles_[x][y];
        fill(c);
        stroke(c);
        rect(x_cur + block_size * x, 
             y_cur + block_size * y,
             block_size, block_size);
      }
    }
  }
  
}

class renderer implements command, executor {
  private ArrayList<command> scene_graph; 
  
  renderer() {
    scene_graph = new ArrayList<command>();
  }
  
  void issue(command r) {
    scene_graph.add(r);
  }
  
  void issue(ArrayList<command> commands) {
    for (int cIdx = 0; cIdx < commands.size(); ++cIdx) {
      issue(commands.get(cIdx));
    }
  }
  
  void execute() {
    for (int ridx = 0; ridx < scene_graph.size(); ++ridx) {
      command r = scene_graph.get(ridx);
      r.execute();
    }
    scene_graph.clear();
  }
  
}