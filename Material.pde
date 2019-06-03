abstract class Material {
  //PVector albedo;
  //Material (PVector a) {this.albedo = a;}
  abstract Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered);
}

class Lambertian extends Material {
  PVector albedo;
  Lambertian(PVector a) {this.albedo = a;}

  Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered) {
    PVector target = PVector.add(rec.p, PVector.add(rec.normal, random_in_unit_sphere()));
    scattered.origin = rec.p;
    scattered.direction = PVector.sub(target, rec.p);
    
    attenuation.set(albedo.x, albedo.y, albedo.z);
    
    return true;
  }
}

class Metal extends Material {
  PVector albedo;
  float fuzz;
  
  Metal(PVector a) {this.albedo = a;}
  
  Metal (PVector a, float f) {
    this(a);
    if (f < 1) this.fuzz = f;
    else this.fuzz = 1;
  }
  
  Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered) {
    PVector reflected = reflect(r_in.direction().normalize(), rec.normal);
    
    scattered.origin = rec.p;
    scattered.direction = PVector.add(reflected, PVector.mult(random_in_unit_sphere(), this.fuzz));
    
    attenuation.set(albedo.x, albedo.y, albedo.z);

    return (PVector.dot(scattered.direction(), rec.normal) > 0);
  }
  
  PVector reflect(PVector v, PVector n) {
    float temp1 = 2*PVector.dot(v, n);
    PVector temp2 = PVector.mult(n, temp1);
    return PVector.sub(v, temp2);
  }
}
