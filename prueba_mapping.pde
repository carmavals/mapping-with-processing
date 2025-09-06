//Quiero una sketch que me permita modificar el tamaño de la imagen con el mouse moviendo las esquinas
// 1. Crear un sketh 
// 2. colocar una imagen (debo saber su tamaño en pixeles)
// 3. hacer que con el mouse pueda mover las esquinas para ajustarlo a una superficie con la que puedo hacer mapping 


ArrayList<MappedImage> images = new ArrayList<MappedImage>(); //crear una clase
int selectedImage = -1;   // índice de la imagen seleccionada
int selectedCorner = -1;  // esquina seleccionada de esa imagen
boolean showCorners = true;

void setup() {
  size(1000, 700, P2D);

  // ejemplo: cargar varias imágenes con tamaño inicial de 200x200
  addImage("image.png", width/3, height/2, 200, 200); 
  addImage("image2.jpg", 2*width/3, height/2, 200, 200);
}

// función para añadir imágenes
void addImage(String filename, float cx, float cy, int w, int h) {
  PImage img = loadImage(filename);
  img.resize(w, h);
  images.add(new MappedImage(img, cx, cy, w, h));
}

void draw() {
  background(30);

  // dibujar todas las imágenes
  for (MappedImage mi : images) {
    mi.display(showCorners);
  }
}

void mousePressed() {
  if (!showCorners) return;

  selectedImage = -1;
  selectedCorner = -1;

  // recorrer todas las imágenes para ver si tocamos una esquina
  for (int i = 0; i < images.size(); i++) {
    for (int j = 0; j < 4; j++) {
      if (dist(mouseX, mouseY, images.get(i).corners[j].x, images.get(i).corners[j].y) < 10) {
        selectedImage = i;
        selectedCorner = j;
        return;
      }
    }
  }
}

void mouseDragged() {
  if (selectedImage != -1 && selectedCorner != -1) {
    images.get(selectedImage).corners[selectedCorner].set(mouseX, mouseY);
  }
}

void mouseReleased() {
  selectedImage = -1;
  selectedCorner = -1;
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    showCorners = !showCorners;
  }
}

// =========================
// CLASE MappedImage
// =========================
class MappedImage {
  PImage img;
  PVector[] corners = new PVector[4];

  MappedImage(PImage img, float cx, float cy, int w, int h) {
    this.img = img;
    corners[0] = new PVector(cx - w/2, cy - h/2); // arriba izq
    corners[1] = new PVector(cx + w/2, cy - h/2); // arriba der
    corners[2] = new PVector(cx + w/2, cy + h/2); // abajo der
    corners[3] = new PVector(cx - w/2, cy + h/2); // abajo izq
  }

  void display(boolean drawCorners) {
    // dibujar la textura en cuadrilátero
    beginShape();
    texture(img);
    vertex(corners[0].x, corners[0].y, 0, 0);
    vertex(corners[1].x, corners[1].y, img.width, 0);
    vertex(corners[2].x, corners[2].y, img.width, img.height);
    vertex(corners[3].x, corners[3].y, 0, img.height);
    endShape(CLOSE);

    // dibujar puntos de control
    if (drawCorners) {
      fill(255, 0, 0);
      noStroke();
      for (PVector c : corners) {
        ellipse(c.x, c.y, 12, 12);
      }
    }
  }
}
