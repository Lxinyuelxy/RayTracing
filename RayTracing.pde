void setup() {
  size(800, 400, P3D); 
}


void draw() {
  PVector lower_left_corner = new PVector(-2.0, -1.0, -1.0);
  PVector horizontal = new PVector(4.0, 0.0, 0.0);
  PVector vertical = new PVector(0.0, 2.0, 0.0);
  PVector origin = new PVector(0.0, 0.0, 0.0);
  
  ArrayList<Hitable> list =new ArrayList<Hitable>();
  list.add(new Sphere(new PVector(0,0,-1), 0.5));
  list.add(new Sphere(new PVector(0,-100.5,-1), 100));
  Hitable world = new Hitable_list(list);
  
  for (int j = height-1; j >= 0; j--) {
    for (int i = 0; i < width; i++) {
      float u = float(i) / float(width);
      float v = float(j) / float(height);
      Ray r = new Ray(origin, PVector.add(PVector.add(PVector.mult(vertical, v), PVector.mult(horizontal, u)), lower_left_corner)); 
      PVector col = get_color(r, world);
      int ir = int(255.99 * col.x);
      int ig = int(255.99 * col.y);
      int ib = int(255.99 * col.z);
      
      set(i, height-j, color(ir, ig, ib));
    }
  }
}


PVector get_color(Ray r, Hitable world) {
  Hit_record rec = new Hit_record();
  if (world.hit(r, 0.0, Float.MAX_VALUE, rec)) {
    return PVector.mult(new PVector(rec.normal.x+1, rec.normal.y+1, rec.normal.z+1), 0.5);
  }
  else {
    PVector unit_dir = r.direction().normalize();
    float t = 0.5*(unit_dir.y + 1.0);
    
    PVector white = new PVector(1.0, 1.0, 1.0);
    PVector light_blue = new PVector(0.5, 0.7, 1.0);
    return PVector.add(PVector.mult(white, 1.0-t), PVector.mult(light_blue, t));
  }

}
  
  
