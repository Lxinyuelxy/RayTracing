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
  
  //Metal(PVector a) {this.albedo = a;}
  
  Metal (PVector a, float f) {
    this.albedo = a;
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
}

class Dielectric extends Material {
  float ref_idx;
  Dielectric (float ri) {
    this.ref_idx = ri;
  }
  
  Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered) {
    PVector outward_normal;
    float ni_over_nt;
    float reflect_prob;
    float cosine;
    
    attenuation.set(1.0, 1.0, 1.0);
    
    
    if (PVector.dot(r_in.direction(), rec.normal) > 0) {
      outward_normal = PVector.mult(rec.normal, -1.0);
      ni_over_nt = ref_idx;
      cosine = ref_idx * PVector.dot(r_in.direction(), rec.normal) / r_in.direction.mag();
    }
    else {
      outward_normal = rec.normal;
      ni_over_nt = 1.0 / ref_idx;
      cosine = -1.0 * PVector.dot(r_in.direction(), rec.normal) / r_in.direction.mag();
    }
    
    PVector refracted = refract(r_in.direction(), outward_normal, ni_over_nt);
    if (refracted != null) {
      reflect_prob = schlick(cosine, ref_idx);

    }
    else {
      
      reflect_prob = 1.0;
    }
    if (random(0.0, 1.0) < reflect_prob) {
      scattered.origin = rec.p;
      scattered.direction = reflect(r_in.direction(), rec.normal);
    }
    else {
      scattered.origin = rec.p;
      scattered.direction = refracted;
    }
    return true;
  }
}

float schlick (float cosine, float ref_idx) {
  float r0 = (1 - ref_idx) / (1 + ref_idx);
  r0 = r0 *r0;
  return r0 + (1-r0)*pow((1-cosine), 5);
}

PVector refract (PVector v, PVector n, float ni_over_nt) {
  PVector uv = v.normalize();
  float dt = PVector.dot(uv, n);
  float discriminant = 1.0 - pow(ni_over_nt, 2)*(1 - pow(dt, 2));
  if (discriminant > 0) {
    PVector temp1 = PVector.sub(uv, PVector.mult(n, dt));
    PVector temp2 = PVector.mult(n, sqrt(discriminant));
    PVector refracted = PVector.sub(PVector.mult(temp1, ni_over_nt), temp2);
    return refracted;
  }
  else
    return null;
}

PVector reflect (PVector v, PVector n) {
  float temp1 = 2*PVector.dot(v, n);
  PVector temp2 = PVector.mult(n, temp1);
  return PVector.sub(v, temp2);
}

PVector random_in_unit_sphere() {
  PVector p;
  do {
    p = PVector.sub(new PVector(random(0.0, 2.0), random(0.0, 2.0), random(0.0, 2.0)), new PVector(1, 1, 1));
  }while(p.magSq() >= 1.0);
  return p;
}
