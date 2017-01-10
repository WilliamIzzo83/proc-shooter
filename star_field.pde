class star_layer {
  private PVector position_;
  private float width;
  private float height;
  
  private ArrayList<command> stars;
  
  star_layer(PVector position, float width, float height, int star_count, int stars_size) {
    this.position_ = position;
    this.width = width;
    this.height = height;
  
    stars = new ArrayList<command>();
    
    for(int sIdx = 0; sIdx < star_count; ++sIdx) {
      float x = random(0, width);
      float y = random(0, height);
      
      stars.add(new draw_square(position.x + x, position.y + y, stars_size));
    }
  }
  
  void update(PVector velocity) {
    
    float min_x = position_.x;
    float max_x = position_.x + width;
    float min_y = position_.y;
    float max_y = position_.y + height;
    
    for(int sIdx = 0; sIdx < stars.size(); ++sIdx) {
      draw_square draw_command = (draw_square)stars.get(sIdx);
      draw_command.x+= velocity.x;
      draw_command.y+= velocity.y;
      
      if (draw_command.y > max_y) {
        draw_command.y = min_y;
      }
      
      if (draw_command.y < min_y) {
        draw_command.y = max_y;
      }
       
      if (draw_command.x > max_x) {
        draw_command.x = min_x;
      }
      
      if (draw_command.x < min_x) {
        draw_command.x = max_x;
      }
    }
  }
  
  ArrayList<command> render_commands() {
    return (ArrayList<command>)stars;
  }
}

class star_field {
  private PVector position_;
  private float width_;
  private float height_;
  private ArrayList<command> stars_;
  private ArrayList<PVector> velocities_;
  private ArrayList<star_layer> layers_;
  private int layers_count_;
  
  star_field(PVector position, float width, float height, int star_count) {
    layers_count_ = 3;
    position_ = position;
    width_ = width;
    height_ = height;
    
    PVector base_velocity = new PVector(-1.4, 0.0);
    int base_color = 80;//100;
    stars_ = new ArrayList<command>();
    velocities_ = new ArrayList<PVector>();
    layers_ = new ArrayList<star_layer>();
    
    
    
    for(int lIdx = 0; lIdx < layers_count_; ++lIdx) {
      int mult = lIdx + 1;
      int mult_q = mult; //* mult;
      stars_.add(new set_fill_color(base_color * mult));
      stars_.add(new set_stroke_color(base_color * mult));
      star_layer layer = new star_layer(position_,
                              width_,
                              height_, 
                              star_count,
                              1 + (lIdx));
                                   
      
      
      
      ArrayList<command> layer_commands = layer.render_commands();
      
      for(int sIdx = 0; sIdx < layer_commands.size(); ++sIdx) {
        stars_.add(layer_commands.get(sIdx));
      }
      
      layers_.add(layer);
      PVector layer_velocity = new PVector(base_velocity.x * mult_q,
                                           base_velocity.y * mult_q);
      
      velocities_.add(layer_velocity);
    }
    
    
  }
  
  void update() {
    for (int lIdx = 0; lIdx < layers_count_; ++lIdx) {
      layers_.get(lIdx).update(velocities_.get(lIdx));
    }
  }
  
  ArrayList<command> render_commands() {
    return stars_;
  }
}