interface i_component extends i_process {
  void sendEvent(event e);
  i_component copy();
  int getComponentId();
  int componentType();
  
  i_component parent();
  
  void setParent(i_component parent);
  void addComponent(i_component comp);
  
  i_component getComponentType(int component_type);
  i_component getComponent(int component_id);
}

abstract class component implements i_component {
  protected int component_id_;
  protected ArrayList<i_component> children_;
  protected i_component parent_;
  
  component(int component_id) {
    component_id_ = component_id;
    children_ = new ArrayList<i_component>();
  }
  
  void init() {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      children_.get(cIdx).init();
    }
  }
  
  i_component parent() { return parent_; }
  void setParent(i_component parent) {
    parent_ = parent;
  }
  
  void sendEvent(event e) {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      children_.get(cIdx).sendEvent(e);
    }
  }
  
  i_component copy() {
    return null;
  }
  
  void update() {}
  void pause() {}
  void die() {}
  
  boolean isDead() { return true; }
  boolean isAlive() { return false; }
  
  int getComponentId() { return component_id_; }
  void addComponent(i_component comp) {
    comp.setParent(this);
    children_.add(comp); 
  }
  
  i_component getComponentType(int component_type) {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      i_component child = children_.get(cIdx);
      if (child.componentType() == component_type) { 
        return child; 
      }
    }
    return null;
  }
  
  i_component getComponent(int component_id) {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      i_component child = children_.get(cIdx);
      if (child.getComponentId() == component_id) {
        return child;
      }
    }
    
    return null;
  }
}

class components_db extends component {
  final static int COMPONENT_TYPE_DB = 0;
  
  components_db(int component_id) {
    super(component_id);
  }
  
  int componentType() { return COMPONENT_TYPE_DB; }
  
  void update() {
    for(int cIdx = 0; cIdx < children_.size(); ++cIdx) {
      i_component child = children_.get(cIdx);
      
      // Ensures removal will happen on next update cycle.
      // This is done so that if the dead component has
      // unfinished business, it can survive another cycle
      // to close them.
      if (child.isDead()) {
        children_.remove(child);
      }
      
      if (child.isAlive()) {
        child.update();
      } else {
        child.die();
      }
    }
  }
}