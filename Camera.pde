class Camera {
  PVector lower_left_corner;
  PVector horizontal;
  PVector vertical;
  PVector origin;
  PVector u, v, w;
  float lens_radius;
  
  Camera () {
    lower_left_corner = new PVector(-2.0, -1.0, -1.0);
    horizontal = new PVector(4.0, 0.0, 0.0);
    vertical = new PVector(0.0, 2.0, 0.0);
    origin = new PVector(0.0, 0.0, 0.0);
  }
  
  Camera (float vfov, float aspect) {
    float theta = vfov*PI / 180;
    float half_height = tan(theta / 2.0);
    float half_width = aspect * half_height;
    
    lower_left_corner = new PVector(-half_width, -half_height, -1.0);
    horizontal = new PVector(2.0*half_width, 0.0, 0.0);
    vertical = new PVector(0.0, 2.0*half_height, 0.0);
    origin = new PVector(0.0, 0.0, 0.0);
  }
  
  Camera (PVector lookfrom, PVector lookat, PVector vup, float vfov, float aspect) {
    PVector u, v, w;
    
    float theta = vfov*PI / 180;
    float half_height = tan(theta / 2.0);
    float half_width = aspect * half_height;
    
    origin = lookfrom;
    w = PVector.sub(lookfrom, lookat).normalize();
    u = vup.cross(w).normalize();
    v = w.cross(u);

    lower_left_corner = PVector.add(PVector.add(PVector.mult(u, half_width), PVector.mult(v, half_height)), w);
    lower_left_corner = PVector.sub(origin, lower_left_corner);
    
    horizontal = PVector.mult(u, 2*half_width);
    vertical = PVector.mult(v, 2*half_height);

  }
  
  Camera (PVector lookfrom, PVector lookat, PVector vup, float vfov, float aspect, float aperture, float focus_dist) {
    this.lens_radius = aperture / 2;
    
    float theta = vfov*PI / 180;
    float half_height = tan(theta / 2.0);
    float half_width = aspect * half_height;
    
    origin = lookfrom;
    this.w = PVector.sub(lookfrom, lookat).normalize();
    this.u = vup.cross(w).normalize();
    this.v = w.cross(u);

    lower_left_corner = PVector.add(PVector.add(PVector.mult(u, half_width*focus_dist), PVector.mult(v, half_height*focus_dist)), PVector.mult(w, focus_dist));
    lower_left_corner = PVector.sub(origin, lower_left_corner);
    
    horizontal = PVector.mult(u, 2 * half_width * focus_dist);
    vertical = PVector.mult(v, 2 * half_height * focus_dist);
  }
  
  Ray get_ray1 (float u, float v) {
    PVector target = PVector.add(PVector.mult(vertical, v), PVector.mult(horizontal, u));
    target = PVector.add(target, lower_left_corner);
    return new Ray(origin, PVector.sub(target, origin)); 
  }
  
  Ray get_ray2(float s, float t) {
    PVector rd = PVector.mult(random_in_unit_disk(), lens_radius);
    PVector offset = PVector.add(PVector.mult(this.u, rd.x), PVector.mult(this.v, rd.y));
    
    PVector ori = PVector.add(origin, offset);
    PVector tar = PVector.add(PVector.mult(this.horizontal, s), PVector.mult(vertical, t));
    tar = tar.add(this.lower_left_corner);
    return new Ray(ori, PVector.sub(tar, ori));
  }
}

PVector random_in_unit_disk () {
  PVector p;
  do {
    p = PVector.sub(new PVector(random(0.0, 2.0), random(0.0, 2.0), 0), new PVector(1.0, 1.0, 0));
  }while(PVector.dot(p, p) >= 1.0);
  return p;
}
