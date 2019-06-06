void setup() {
  float startTime = millis();
  size(600, 400, P3D); 
  Scene scene = createScene();
  
  PVector lookfrom = new PVector(13, 2, 3);
  PVector lookat = new PVector(0, 0, 0);
  float dist_to_focus = 10;
  float aperture = 0.1;
  Camera cam = new Camera(lookfrom, lookat, new PVector(0, 1, 0), 20, float(width) / float(height), aperture, dist_to_focus);
  
  int ns = 50;
  int lastPercent = -1;
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
    
    
    int percent = int((1.0 - j*1.0 / (height-1)) * 100);
    if (lastPercent < percent) {
      lastPercent = percent;
      println("Rendering percent: ", percent);
    }
    
  }
  
  float endTime = millis();
  println("---------------");
  println("Rendering Time: ", (endTime - startTime) / 1000.0);
}

void draw() {}


Scene createScene() {
  float R = cos(PI / 4.0);
  ArrayList<Sphere> list =new ArrayList<Sphere>();
  list.add(new Sphere(new PVector(0, -1000, 0), 1000, new Lambertian(new PVector(0.5, 0.5, 0.5))));
  
  for (int a = -11; a < 11; a++) {
    for (int b = -11; b < 11; b++) {
      float choose_mat = random(1.0);
      PVector center = new PVector(a+random(5.0), 0.2, b+random(5.0));
      if (PVector.sub(center, new PVector(4, 0.2, 0)).mag() > 0.9) {
        if (choose_mat < 0.8)
          list.add(new Sphere(center, 0.2, new Lambertian(new PVector(random(1.0)*random(1.0), random(1.0)*random(1.0), random(1.0)*random(1.0)))));
        else if (choose_mat < 0.95)
          list.add(new Sphere(center, 0.2, new Metal(new PVector(0.5*(1+random(1.0)), 0.5*(1+random(1.0)), 0.5*(1+random(1.0))), 0.5*random(1.0))));
        else
           list.add(new Sphere(center, 0.2, new Dielectric(1.5)));
      }
    }
  }
  list.add(new Sphere(new PVector(0, 1, 0), 1.0, new Dielectric(1.5)));
  list.add(new Sphere(new PVector(-4, 1, 0), 1.0, new Lambertian(new PVector(0.4, 0.2, 0.1))));
  list.add(new Sphere(new PVector(4, 1, 0), 1.0, new Metal(new PVector(0.7, 0.6, 0.5), 0.0)));
  println("Rendering objects num: ", list.size());
  return new Scene(list);
}


  
  
