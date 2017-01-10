float velocity = 0.2;

renderer rend_ = new renderer();

components_db game_components = new components_db(0);
scene game_scene;
actor player_actor;

void setup() {
  size(1024, 768);
  background(255);
  noCursor();
  ArrayList<i_component> comps = new ArrayList<i_component>();
  ArrayList<i_component> proto = new ArrayList<i_component>();
  
  // Initializes bkg
  astro_background bkg = new astro_background(10, rend_);
  
  // Initializes player ship
  player_actor = new actor(1);
  player_controller pcontroller = new player_controller(1); 
  drawable player_ship = new drawable(2, 2.0, ship_pixmap(), rend_);

  player_actor.addComponent(pcontroller);
  player_actor.addComponent(player_ship);
    
  comps.add(bkg);
  comps.add(player_actor);

  game_scene = new scene(0, rend_, comps, proto);
  game_scene.init();  
}

void draw() {
  game_scene.update();
  rend_.execute();
}

void mouseMoved() {
  game_scene.sendEvent(new mouse_event(mouseX, mouseY, false));
}

void mouseDragged() {
  game_scene.sendEvent(new mouse_event(mouseX, mouseY, false));
}

void mousePressed() {
  game_scene.sendEvent(new mouse_event(mouseX, mouseY, true));
}