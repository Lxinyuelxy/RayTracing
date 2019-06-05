void setup() {
  size(800, 400, P3D); 
  Scene scene = createScene();
  //Camera cam = new Camera();
  //Camera cam = new Camera(90, float(width) / float(height));
  Camera cam = new Camera(new PVector(-2, 2, 1), new PVector(0, 0, -1), new PVector(0, 1, 0), 90, float(width) / float(height));
  
  int ns = 10;
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
  float R = cos(PI / 4.0);
  ArrayList<Sphere> list =new ArrayList<Sphere>();
  list.add(new Sphere(new PVector(0, 0, -1), 0.5, new Lambertian(new PVector(0.1, 0.2, 0.5))));
  list.add(new Sphere(new PVector(1, 0, -1), 0.5, new Metal(new PVector(0.8, 0.6, 0.2), 0.3)));
  list.add(new Sphere(new PVector(-1, 0, -1), 0.5, new Dielectric(1.5)));
  list.add(new Sphere(new PVector(-1, 0, -1), -0.45, new Dielectric(1.5)));
  list.add(new Sphere(new PVector(0, -100.5, -1), 100, new Lambertian(new PVector(0.8, 0.8, 0.0))));
  return new Scene(list);
}


  
  
