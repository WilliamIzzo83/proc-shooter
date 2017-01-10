int clamp(int value, int min, int max) {
  int t = value < min ? min : value;
  return t > max ? max : value;
}

void v_move_towards(PVector in, PVector target) {
  final float eps = 0.1;
  float d = in.dist(target);
  if ( d <= eps ) {
    return;
  }
    
  PVector dAT = target.copy();
    
  dAT.sub(in);
  dAT.mult(0.1);
  
  in.add(dAT);
}