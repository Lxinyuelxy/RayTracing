class Camera {
  PVector lower_left_corner;
  PVector horizontal;
  PVector vertical;
  PVector origin;
  
  Camera () {
    lower_left_corner = new PVector(-2.0, -1.0, -1.0);
    horizontal = new PVector(4.0, 0.0, 0.0);
    vertical = new PVector(0.0, 2.0, 0.0);
    origin = new PVector(0.0, 0.0, 0.0);
  }
  
  Ray get_ray (float u, float v) {
    return new Ray(origin, PVector.add(PVector.add(PVector.mult(vertical, v), PVector.mult(horizontal, u)), lower_left_corner)); 
  }
}
