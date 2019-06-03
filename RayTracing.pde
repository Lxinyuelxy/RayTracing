void setup() {
  size(800, 400, P3D); 
    ArrayList<Hitable> list =new ArrayList<Hitable>();
  list.add(new Sphere(new PVector(0,0,-1), 0.5));
  list.add(new Sphere(new PVector(0,-100.5,-1), 100));
  Hitable world = new Hitable_list(list);
  int ns = 60;
  
  Camera cam = new Camera();
  
  for (int j = height-1; j >= 0; j--) {
    for (int i = 0; i < width; i++) {
      
      PVector col = new PVector(0.0, 0.0, 0.0);
      for (int s = 0; s < ns; s++) {
        float u = (i + random(0.0, 1.0)) / float(width);
        float v = (j + random(0.0, 1.0)) / float(height);
        //float u = (i) / float(width);
        //float v = (j) / float(height);
        Ray r = cam.get_ray(u, v);
        col.add(get_color(r, world));
      }
      col.div(ns);
      col = new PVector(sqrt(col.x), sqrt(col.y), sqrt(col.z));
      int ir = int(255.99 * col.x);
      int ig = int(255.99 * col.y);
      int ib = int(255.99 * col.z);
      
      set(i, height-j, color(ir, ig, ib));
    }
  }
}


void draw() {
}

PVector random_in_unit_sphere() {
  PVector p;
  do {
    p = PVector.sub(new PVector(random(0.0, 2.0), random(0.0, 2.0), random(0.0, 2.0)), new PVector(1, 1, 1));
  }while(p.magSq() >= 1.0);
  return p;
}

PVector get_color(Ray r, Hitable world) {
  Hit_record rec = new Hit_record();
  if (world.hit(r, 0.001, Float.MAX_VALUE, rec)) {
    PVector target = PVector.add(rec.p, PVector.add(rec.normal, random_in_unit_sphere()));
    Ray rr = new Ray(rec.p, PVector.sub(target, rec.p));
    return PVector.mult(get_color(rr, world), 0.5);
  }
  else {
    PVector unit_dir = r.direction().normalize();
    float t = 0.5*(unit_dir.y + 1.0);
    
    PVector white = new PVector(1.0, 1.0, 1.0);
    PVector light_blue = new PVector(0.5, 0.7, 1.0);
    return PVector.add(PVector.mult(white, 1.0-t), PVector.mult(light_blue, t));
  }

}
  
  
