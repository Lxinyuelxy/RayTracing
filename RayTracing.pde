void setup() {
  size(800, 400, P3D); 
  Scene scene = createScene();
  Camera cam = new Camera();
  
  int ns = 30;
  for (int j = height-1; j >= 0; j--) {
    for (int i = 0; i < width; i++) {
      
      PVector col = new PVector(0.0, 0.0, 0.0);
      for (int s = 0; s < ns; s++) {
        float u = (i + random(0.0, 1.0)) / float(width);
        float v = (j + random(0.0, 1.0)) / float(height);
        Ray r = cam.get_ray(u, v);
        col.add(scene.get_color(r, 0));
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

void draw() {}


Scene createScene() {
  ArrayList<Sphere> list =new ArrayList<Sphere>();
  list.add(new Sphere(new PVector(0, 0, -1), 0.5, new Lambertian(new PVector(0.8, 0.3, 0.3))));
  list.add(new Sphere(new PVector(0, -100.5, -1), 100, new Lambertian(new PVector(0.8, 0.8, 0.0))));
  list.add(new Sphere(new PVector(1, 0, -1), 0.5, new Metal(new PVector(0.8, 0.6, 0.2), 0.3)));
  list.add(new Sphere(new PVector(-1, 0, -1), 0.5, new Metal(new PVector(0.8, 0.8, 0.8), 1.0)));
  return new Scene(list);
}

PVector random_in_unit_sphere() {
  PVector p;
  do {
    p = PVector.sub(new PVector(random(0.0, 2.0), random(0.0, 2.0), random(0.0, 2.0)), new PVector(1, 1, 1));
  }while(p.magSq() >= 1.0);
  return p;
}


  
  
