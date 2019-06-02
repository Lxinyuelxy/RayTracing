class Hit_record {
  float t;
  PVector p;
  PVector normal;
}

interface Hitable {
  Boolean hit (Ray r, float t_min, float t_max, Hit_record rec);
}

class Sphere implements Hitable{
  PVector center;
  float radius;
  
  Sphere() {}
  Sphere(PVector cen, float r) {
    this.center = cen;
    this.radius = r;
  }
  
  Boolean hit (Ray r, float t_min, float t_max, Hit_record rec) {
    PVector oc = PVector.sub(r.origin(), center);
    float a = PVector.dot(r.direction(), r.direction());
    float b = PVector.dot(oc, r.direction());
    float c = PVector.dot(oc, oc) - radius*radius;
    
    float discriminant = b*b - a*c;
    if (discriminant > 0) {
      float temp = (-b - sqrt(discriminant)) / a;
      if (temp < t_max && temp > t_min) {
        rec.t = temp;
        rec.p = r.point_at_parameter(rec.t);
        rec.normal = PVector.div(PVector.sub(rec.p, center), radius);
        return true;
      }
      temp = (-b + sqrt(discriminant)) / a;
      if (temp < t_max && temp > t_min) {
        rec.t = temp;
        rec.p = r.point_at_parameter(rec.t);
        rec.normal = PVector.div(PVector.sub(rec.p, center), radius);
        return true;
      }
    }
    return false;
  }
}

class Hitable_list implements Hitable {
  ArrayList<Hitable> list;
  int list_size;
  
  Hitable_list(ArrayList<Hitable> _list) {
    this.list = _list;
  }
  
  Boolean hit (Ray r, float t_min, float t_max, Hit_record rec) {
    Hit_record temp_rec = new Hit_record();
    Boolean hit_anything = false;
    float closest_so_far = t_max;
    
    for (int i = 0; i < list.size(); i++) {
      if (list.get(i).hit(r, t_min, closest_so_far, temp_rec)) {
        hit_anything = true;
        closest_so_far = temp_rec.t;
        //println("temp_rec.t: ", temp_rec.t);
        //println("temp_rec.p: ", temp_rec.p);
        //println("temp_rec.normal: ", temp_rec.normal);
        rec.t = temp_rec.t;
        rec.p = temp_rec.p.copy();
        rec.normal = temp_rec.normal.copy();
      }
    }
    return hit_anything;
  }
}
