class Quad {
  PVector a, b, c, d;
  PVector Ma, Mb, Mc, Md;

  Quad(PVector pos, PVector size) {
    a = pos.copy();
    b = pos.copy().add(new PVector(size.x, 0));
    c = pos.copy().add(size);
    d = pos.copy().add(new PVector(0, size.y));
  }

  Quad(PVector _a, PVector _b, PVector _c, PVector _d) {
    a = _a;
    b = _b;
    c = _c;
    d = _d;
  }

  Quad(float ax, float ay, float bx, float by, float cx, float cy, float dx, float dy) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
    c = new PVector(cx, cy);
    d = new PVector(dx, dy);
  }

  boolean pointCheck(PVector p) {
    return pointInQuad(p, a, b, c, d);
  }

  void draw() {
    canvas.quad(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y);
  }


  void drawDebug() {
    canvas.triangle(a.x, a.y, b.x, b.y, c.x, c.y);
    canvas.triangle(a.x, a.y, c.x, c.y, d.x, d.y);
  }

  void pushMatrix() {
    Ma = a.copy();
    Mb = b.copy();
    Mc = c.copy();
    Md = d.copy();
  }

  void translate(float x, float y) {
    this.translate(new PVector(x, y));
  }

  void translate(PVector offset) {
    a.add(offset);
    b.add(offset);
    c.add(offset);
    d.add(offset);
  }

  void rotate(PVector o, float angle) {
    angle += HALF_PI;
    rotateAroundPoint(a, o.x, o.y, angle);
    rotateAroundPoint(b, o.x, o.y, angle);
    rotateAroundPoint(c, o.x, o.y, angle);
    rotateAroundPoint(d, o.x, o.y, angle);
  }

  void popMatrix() {
    a = Ma;
    b = Mb;
    c = Mc;
    d = Md;
  }

  void rotateAroundPoint(PVector p, float anchorX, float anchorY, float angle) {
    //https://forum.processing.org/one/topic/pvector-rotation.html
    float rotX, rotY, origX, origY;
    origX = rotX = p.x - anchorX;  // subtract to get relative position
    origY = rotY = p.y - anchorY;  // or with other words, to get origin (anchor/rotation) point to 0,0

    p.x -= rotX;
    p.y -= rotY;
    rotX = origX * cos(angle) - origY * sin(angle);
    rotY = origX * sin(angle) + origY * cos(angle);
    p.x += rotX; // get it back to absolute position on screen
    p.y += rotY;
  }
}

boolean sameSide(PVector p1, PVector p2, PVector a, PVector b) {
  PVector cp1 = PVector.sub(b, a).cross(PVector.sub(p1, a));
  PVector cp2 = PVector.sub(b, a).cross(PVector.sub(p2, a));
  if (cp1.dot(cp2) >= 0)
    return true;
  else
    return false;
}

boolean pointInTriangle(PVector p, PVector a, PVector b, PVector c) {
  return sameSide(p, a, b, c) && sameSide(p, b, a, c) && sameSide(p, c, a, b);
}

boolean pointInQuad(PVector p, PVector a, PVector b, PVector c, PVector d) {
  return pointInTriangle(p, a, b, c) || pointInTriangle(p, a, c, d);
}
