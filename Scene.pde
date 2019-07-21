class Scene {
  
  ArrayList<Sphere> objects;
  Scene(ArrayList<Sphere> list) {
    this.objects = list;
  }
  
  Hit_record hit(Ray r, float t_min, float t_max) {
    float closest_so_far = t_max;
    Hit_record rec = null;
    
    for (Sphere sphere : objects) {
      Hit_record temp_rec = sphere.hit(r, t_min, closest_so_far);
      
      if (temp_rec != null) {

        closest_so_far = temp_rec.t;
        
        float t = temp_rec.t;
        PVector p = temp_rec.p.copy();
        PVector normal = temp_rec.normal.copy();
        Material material = temp_rec.material;
        rec = new Hit_record(t, p,  normal, material); 
      }
    }
    return rec;
  }
  
  PVector get_color(Ray r, int depth) {
    Hit_record rec = this.hit(r, 0.001, Float.MAX_VALUE);
    
    if (rec != null) {
      Ray scattered = new Ray();
      PVector attenuation = new PVector();
      
      if (depth < 50 && rec.material.scatter(r, rec, attenuation, scattered)) {
        PVector col = get_color(scattered, depth+1);
        PVector finalCol = new PVector(col.x*attenuation.x, col.y*attenuation.y, col.z*attenuation.z);
        return finalCol;
      }
      else {
        return new PVector(0, 0, 0);
      } 
    }
    else {
      PVector unit_dir = r.direction().normalize();
      float t = 0.5*(unit_dir.y + 1.0);
      
      PVector white = new PVector(1.0, 1.0, 1.0);
      PVector light_blue = new PVector(0.5, 0.7, 1.0);
      return PVector.add(PVector.mult(white, 1.0-t), PVector.mult(light_blue, t));
    } 
  }
  
}
