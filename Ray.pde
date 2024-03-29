class Ray {
  PVector origin;
  PVector direction;
  
  Ray() {};
  
  Ray(PVector a, PVector b) {
    this.origin = a;
    this.direction = b;
  }
  
  PVector origin() {
    return this.origin;
  }
  
  PVector direction() {
    return this.direction;
  }
  
  PVector point_at_parameter(float t) {
    return PVector.add(origin, PVector.mult(direction, t));
  }
  
  
}
