class spawn implements event {
  static final int EVENT_SPAWN = 3;
  int event_type() { return EVENT_SPAWN; }
  private actor actor_;
  spawn(actor actor) {
    actor_ = actor;
  }
  
  actor getActor() {
    return actor_;
  }
}

class scene_command implements command {
  protected scene scene_;
  scene_command(scene scene){
    scene_ = scene;
  }
  void execute(){}
}

class spawn_actor extends scene_command {
  private int proto_id_;
  private PVector position_;
  
  spawn_actor(scene scene, int prototype_id, PVector position) { 
    super(scene);
    proto_id_ = prototype_id;
    position_ = position;
  }
  void execute() {
    scene_.spawnActor(proto_id_, position_); //<>//
  }
}

class scene implements i_process, executor {
  int scene_id_;
  renderer renderer_;
  components_db comp_instances_;
  ArrayList<i_component> comp_prototypes_;
  ArrayList<scene_command> commands_;
  
  scene(int scene_id, renderer renderer) {
    scene_id_ = scene_id;
    comp_instances_ = new components_db(0);
    comp_prototypes_ = new ArrayList<i_component>();
    commands_ = new ArrayList<scene_command>();
    
    renderer_ = renderer;
  }
  
  scene(int scene_id, renderer renderer, ArrayList<i_component> components) {
    this(scene_id, renderer);
    for(int cIdx = 0; cIdx < components.size(); ++cIdx) {
      comp_instances_.addComponent(components.get(cIdx));
    }
  }
  
  scene(int scene_id, renderer renderer, ArrayList<i_component> components, ArrayList<i_component> prototypes) {
    this(scene_id, renderer, components);
    for(int cIdx = 0; cIdx < prototypes.size(); ++cIdx) {
      comp_prototypes_.add(prototypes.get(cIdx));
    }
  }
  
  void init() {
    comp_instances_.init();
  }
  
  void update() {
    for(int cIdx = 0; cIdx < commands_.size(); ++cIdx) {
      commands_.get(cIdx).execute();
    }
    commands_.clear();
    
    comp_instances_.update();
  }
  
  void pause() { comp_instances_.pause(); }
  void die() { comp_instances_.die(); }
  
  void issue(command cmd) {
    commands_.add((scene_command)cmd);
  }
  
  void sendEvent(event e) {
    if (e.event_type() == spawn_event.EVENT_SPAWN) {
      spawn_event se = (spawn_event)e;
      spawn_actor spawn_cmd = new spawn_actor(this, se.actor_id(), se.position());
      issue(spawn_cmd);
    } else {
      comp_instances_.sendEvent(e);
    }
  }
  
  void spawnActor(int protoId, PVector pos) {
    for(int pIdx = 0; pIdx < comp_prototypes_.size(); ++pIdx) {
      i_component prototype = comp_prototypes_.get(pIdx);
      if(prototype.getComponentId() == protoId) {
        i_component instance = prototype.copy();
        actor proto_actor = (actor)instance;
        position proto_position = (position)proto_actor.getComponentType(position.COMPONENT_TYPE_POSITION);
        if (proto_position != null) {
          proto_position.position_ = pos.copy();
        }
        proto_actor.init();
        comp_instances_.addComponent(instance);
        return;
      }
    }
  }
  
  boolean isAlive() { return true; }
  boolean isDead() { return false; };
}