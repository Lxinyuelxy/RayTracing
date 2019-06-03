class Hit_record {
  float t;
  PVector p;
  PVector normal;
  Material material;
  
  Hit_record (float _t, PVector _p, PVector _normal, Material _material) {
    this.t = _t;
    this.p = _p;
    this.normal = _normal;
    this.material = _material;
  }
}

class Sphere {
  PVector center;
  float radius;
  Material material;
  
  Sphere() {}
  Sphere(PVector cen, float r, Material m) {
    this.center = cen;
    this.radius = r;
    this.material = m;
  }
  
  Hit_record hit (Ray r, float t_min, float t_max) {
    PVector oc = PVector.sub(r.origin(), center);
    float a = PVector.dot(r.direction(), r.direction());
    float b = PVector.dot(oc, r.direction());
    float c = PVector.dot(oc, oc) - radius*radius;
    
    float discriminant = b*b - a*c;
    if (discriminant > 0) {
      float temp = (-b - sqrt(discriminant)) / a;
      if (temp < t_max && temp > t_min) {
        
        
        float t = temp;
        PVector p = r.point_at_parameter(t);
        PVector normal = PVector.div(PVector.sub(p, center), radius);
 
        return new Hit_record(t, p,  normal, this.material);
      }
      temp = (-b + sqrt(discriminant)) / a;
      if (temp < t_max && temp > t_min) {
        
        float t = temp;
        PVector p = r.point_at_parameter(t);
        PVector normal = PVector.div(PVector.sub(p, center), radius);
 
        return new Hit_record(t, p,  normal, this.material);
      }
    }
    return null;
  }
}
