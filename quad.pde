class Quad {
  PVector a, b, c, d;

  Quad(PVector _a, PVector _b, PVector _c, PVector _d) {
    a = _a;
    b = _b;
    c = _c;
    d = _d;
  }

  boolean clickCheck(PVector p) {
    return pointInQuad(p, a, b, c, d);
  }

  void draw() {
    canvas.pushStyle();
    canvas.stroke(0);
    canvas.strokeWeight(3);
    canvas.quad(a.x, a.y, b.x, b.y, c.x, c.y, d.x, d.y);
    canvas.popStyle();
  }

  void drawDebug(color col) {
    canvas.pushStyle();
    canvas.stroke(col);
    canvas.strokeWeight(1);
    canvas.noFill();
    canvas.triangle(a.x, a.y, b.x, b.y, c.x, c.y);
    canvas.triangle(a.x, a.y, c.x, c.y, d.x, d.y);
    canvas.popStyle();
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
