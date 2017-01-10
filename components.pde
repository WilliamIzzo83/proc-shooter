class position extends component {
  final static int COMPONENT_TYPE_POSITION = 2;
  PVector position_;
  
  position(int component_id, PVector position) {
    super(component_id);
    position_ = position.copy();
  }
  
  int componentType() { return COMPONENT_TYPE_POSITION; }
  
  i_component copy() {
    return new position(component_id_, position_);
  }
  
  void init() {}
  void update() {
    actor_position_event pe = new actor_position_event(position_);
    this.parent_.sendEvent(pe);
  }
  
  void sendEvent(event e) {
    if(e.event_type() != actor_position_update_event.EVENT_ACTOR_POSITION_UPDATE) { return; }
    actor_position_update_event pu = (actor_position_update_event)e;
    position_ = pu.position();
  }
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; }
}

class drawable extends component {
  final static int COMPONENT_TYPE_DRAWABLE = 3;
  renderer renderer_;
  pixmap pixmap_;
  draw_pixmap draw_command_;
  PVector position_;
  float scale_;
  // TODO: could generalize more
  drawable(int component_id, float scale, pixmap pixmap, renderer renderer) {
    super(component_id);
    renderer_ = renderer;
    pixmap_ = pixmap;
    position_ = new PVector(0.0, 0.0);
    scale_ = scale;
  }
  
  int componentType() { return COMPONENT_TYPE_DRAWABLE; }
  
  i_component copy() {
    return new drawable(component_id_, scale_, pixmap_, renderer_);
  }
  
  void init() {
    draw_command_ = new draw_pixmap(0.0, 0.0, scale_, pixmap_);
  }
  
  void sendEvent(event e) {
    if (e.event_type() != actor_position_event.EVENT_ACTOR_POSITION) { return; }
    
    actor_position_event pe = (actor_position_event)e;
    position_ = pe.position();
  }
  
  void update() {
    if (isAlive()) {
      draw_command_.offset_x = position_.x;
      draw_command_.offset_y = position_.y;
      
      renderer_.issue(draw_command_);
    }
  }
  
  
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; }
}

class astro_background extends component {
  final static int COMPONENT_TYPE_ASTRO_BACKGROUND = 4;
  
  private color color1_;
  private color color2_;
  private float interpolation_;
  private float velocity_;
  private float direction_;
  
  private renderer renderer_;
  private set_fill_color fill_command_;
  private set_stroke_color stroke_command_;
  private draw_rect bg_draw_cmd_;
  private star_field sfield_;
  
  astro_background(int component_id, renderer renderer) {
    super(component_id);
    renderer_ = renderer;
    interpolation_ = 0.0;
    direction_ = 1.0;
    velocity_ = 0.04;
    color1_ = color(0,0,0);
    color2_ = color(21,10,32);
  }
  
  int componentType() { return COMPONENT_TYPE_ASTRO_BACKGROUND; }
  
  void init() {
    bg_draw_cmd_ = new draw_rect(0.0, 0.0, 1024.0, 768.0);
    fill_command_ = new set_fill_color(0);
    stroke_command_ = new set_stroke_color(0);
    sfield_ = new star_field(new PVector(0.0,0.0),
                            1024, 
                            768, 
                            8);
  }
  
  void update(){
    interpolation_+= velocity_ * velocity_ * direction_;
    color c = lerpColor(color1_, color2_, interpolation_);
    
    fill_command_.color_ = c;
    stroke_command_.color_ = c;
    
    if(interpolation_ >= 1.0) { direction_ = -1.0; }
    if(interpolation_ <= 0.0) { direction_ = 1.0; }
    
    sfield_.update();
    renderer_.issue(fill_command_);
    renderer_.issue(stroke_command_);
    renderer_.issue(bg_draw_cmd_);
    renderer_.issue(sfield_.render_commands());
  }
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; }
}

 //<>//

class player_controller extends component {
  final static int COMPONENT_PLAYER_CONTROLLER = 7;
  private PVector position_;
  private PVector target_position_;
  
  player_controller(int component_id) {
    super(component_id);
    position_ = new PVector(0.0, 0.0);
    target_position_ = new PVector(0.0, 0.0);
  }
  
  i_component copy() {
    return new player_controller(component_id_);
  }
  
  int componentType() { return COMPONENT_PLAYER_CONTROLLER; }
  
  void update() {
    v_move_towards(position_, target_position_);
    actor_position_event pe = new actor_position_event(position_);
    this.parent_.sendEvent(pe);
  }
  
  void sendEvent(event e) {
    
    if(e.event_type() == mouse_event.EVENT_MOUSE) {
      mouse_event me = (mouse_event)e;
      target_position_.x = me.x();
      target_position_.y = me.y();
      
      if(me.button_pressed()) {
        // spawn_event spawn = new spawn_event(4, position_);
        // TODO: send spawn event to event bus 
      }
    }
  }
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; }
}

class actor extends component {
  
  final static int COMPONENT_TYPE_ACTOR = 1;
  
  actor(int component_id)  {
    super(component_id);
    
  }
  
  int componentType() { return COMPONENT_TYPE_ACTOR; }
  
  i_component copy() {
    actor copy_comp = new actor(component_id_);
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      component child = (component)children_.get(cIdx);
      copy_comp.addComponent((component)child.copy());
    }
    return copy_comp;  
  }
  
  void update() {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      i_component child = children_.get(cIdx);
      if (child.isAlive()) {
        child.update();
      }
    }   
  }
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; }
}