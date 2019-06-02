class Ray {
  PVector origin;
  PVector direction;
  
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
  
  PVector pointer_at_parameter(float t) {
    return PVector.add(origin, PVector.mult(direction, t));
  }
  
  
}
