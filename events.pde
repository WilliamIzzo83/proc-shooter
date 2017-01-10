interface event {
  int event_type();
}

class kbd_event implements event {
  final static int EVENT_KBD = 0;
  final static int KBD_PRESS = 0;
  final static int KBD_RELEASE = 1;
  
  private int kbd_state_;
  private int key_;
  kbd_event(int kbd_state, int key) {
    kbd_state_ = kbd_state;
    key_ = key;
  }
  
  int key() { return key_; } 
  int kbd_state() { return kbd_state_; }
  int event_type() { return EVENT_KBD; }
}

class mouse_event implements event {
  final static int EVENT_MOUSE = 5;
  float x_ = 0.0;
  float y_ = 0.0;
  boolean button_pressed_ = false;
  
  mouse_event(float x, float y, boolean button_pressed) {
    x_ = x;
    y_ = y;
    button_pressed_ = button_pressed;
  }
  
  int event_type() { return EVENT_MOUSE; }
  
  float x() { return x_; }
  float y() { return y_; }
  boolean button_pressed() { return button_pressed_; }
}

class spawn_event implements event {
   final static int EVENT_SPAWN = 10;
   private PVector spawn_position_;
   private int actor_id_;

   spawn_event(int actor_id, PVector position) {
     spawn_position_ = position.copy();
     actor_id_ = actor_id;
   }
   
   int event_type() { return EVENT_SPAWN; }
   int actor_id() { return actor_id_; }
   PVector position() { return spawn_position_; }
}

class base_position_event {
  private PVector position_;
  base_position_event(PVector position) {
    position_ = position.copy();
  }
  
  PVector position() { return position_.copy(); }
}

class actor_position_event extends base_position_event implements event {
  final static int EVENT_ACTOR_POSITION = 2;
  actor_position_event(PVector position) { super(position); }
  int event_type() { return  EVENT_ACTOR_POSITION; }
}

class actor_position_update_event extends base_position_event implements event {
  final static int EVENT_ACTOR_POSITION_UPDATE = 3;
  actor_position_update_event(PVector position) { super(position); }
  int event_type() { return  EVENT_ACTOR_POSITION_UPDATE; }
}

class move_towards_event implements event {
  final static int EVENT_MOVE_TOWARDS = 4;
  private PVector target_;
  move_towards_event(PVector target) {
    target_ = target.copy();
  }
  PVector target() { return target_.copy(); }
  int event_type() { return EVENT_MOVE_TOWARDS; }
}