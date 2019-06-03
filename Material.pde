abstract class Material {
  abstract Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered);
}

class Lambertian extends Material {
  PVector albedo;
  Lambertian (PVector a) {this.albedo = a;}
  Boolean scatter(Ray r_in, Hit_record rec, PVector attenuation, Ray scattered) {
    PVector target = PVector.add(rec.p, PVector.add(rec.normal, random_in_unit_sphere()));
    scattered.origin = rec.p;
    scattered.direction = PVector.sub(target, rec.p);
    attenuation = albedo;
    return true;
  }
}
