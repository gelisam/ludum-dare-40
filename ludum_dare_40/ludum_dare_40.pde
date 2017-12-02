// CONSTANTS

final int WINDOW_WIDTH = 1280;
final int WINDOW_HEIGHT = 800;
final int GRID_WIDTH = 100;
final int GRID_HEIGHT = 100;
final int CLASS_WIDTH = 60;
final int CLASS_HEIGHT = 60;
final int CLASS_DX = (GRID_WIDTH - CLASS_WIDTH) / 2;
final int CLASS_DY = (GRID_HEIGHT - CLASS_HEIGHT) / 2;

// connector types
final int NO_CONNECTOR = 0;
final int WHITE_ARROW_CONNECTOR = 1; // inheritance
final int BLACK_DIAMOND_CONNECTOR = 2; // composition
final int WHITE_DIAMOND_CONNECTOR = 3; // aggregation


// GLOBALS

final NamePool global_name_pool = new NamePool();
Diagram global_diagram;


void setup() {
  size(1280, 800);

  stroke(0);
  textAlign(CENTER);


  Box box;
  global_diagram = new Diagram();

  for (int ii=0; ii<4; ++ii) {
    box = new Box(ii);
    box.connectors.add(new PVector(0, 1));
    global_diagram.boxes.put(new PVector(ii, 0), box);

    box = new Box(NO_CONNECTOR);
    global_diagram.boxes.put(new PVector(ii, 1), box);
  }
}

void draw_grid(int w, int h) {
  stroke(128);
  for (int i=0; i<=w; ++i) {
    line(i*GRID_WIDTH, 0, i*GRID_WIDTH, h*GRID_HEIGHT);
  }
  for (int j=0; j<=h; ++j) {
    line(0, j*GRID_HEIGHT, w*GRID_WIDTH, j*GRID_HEIGHT);
  }
}


class NamePool {
  StringList unused_names = new StringList();

  NamePool() {
    unused_names.append("Bank");
    unused_names.append("Account");
    unused_names.append("User");
    unused_names.append("Person");
    unused_names.append("Animal");
    unused_names.append("Cat");
    unused_names.append("Dog");
    unused_names.append("Shape");
    unused_names.append("Circle");
    unused_names.append("Ellipse");
    unused_names.append("Square");
    unused_names.append("Rectangle");
    unused_names.append("Widget");
    unused_names.append("Button");
    unused_names.append("Label");
    unused_names.append("Entity");
    unused_names.append("Component");
    unused_names.append("Data");
    unused_names.append("Manager");
    unused_names.append("Factory");
    unused_names.append("Tool");
    unused_names.shuffle();
  }

  String next_name() {
    return unused_names.remove(0);
  }
}


class Box {
  String name;
  int connector_type;
  ArrayList<PVector> connectors = new ArrayList<PVector>();

  Box(int connector_type_) {
    name = global_name_pool.next_name();
    connector_type = connector_type_;
  }

  void draw_box(int i, int j) {
    int x = i*GRID_WIDTH+CLASS_DX;
    int y = j*GRID_HEIGHT+CLASS_DY;

    stroke(0);

    fill(255);
    rect(x, y, CLASS_WIDTH, CLASS_HEIGHT-1);
    line(x, y+20, x+CLASS_WIDTH, y+20);

    fill(0);
    text(name, x+CLASS_WIDTH/2, y+15);
  }

  void draw_connector(int i1, int j1, int i2, int j2) {
    int x1 = i1*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y1 = j1*GRID_HEIGHT+CLASS_DY+CLASS_HEIGHT;
    int x2 = i2*GRID_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y2 = j2*GRID_HEIGHT+CLASS_DY;


    stroke(0);
    if (connector_type == NO_CONNECTOR) {
      line(x1, y1, x1, y1+10);
    } else if (connector_type == WHITE_ARROW_CONNECTOR) {
      fill(255);
      quad(x1, y1, x1-5, y1+10, x1, y1+10, x1+5, y1+10);
    } else {
      fill((connector_type == BLACK_DIAMOND_CONNECTOR) ? 0 : 255);
      quad(x1, y1, x1-5, y1+5, x1, y1+10, x1+5, y1+5);
    }

    line(x1, y1+10, x2, y2);
  }

  void draw(int i, int j) {
    draw_box(i, j);

    for (PVector delta : connectors) {
      draw_connector(i, j, round(i+delta.x), round(j+delta.y));
    }
  }
}

class Diagram {
  HashMap<PVector, Box> boxes = new HashMap<PVector, Box>();

  void draw(int i, int j) {
    for (PVector delta : boxes.keySet()) {
      Box box = boxes.get(delta);
      box.draw(i+round(delta.x), j+round(delta.y));
    }
  }
}


void draw() {
  // UPDATE


  // DRAW

  int w = 4;
  int h = 3;
  background(215);
  pushMatrix();
  translate((WINDOW_WIDTH-w*GRID_WIDTH)/2, (WINDOW_HEIGHT-h*GRID_HEIGHT)/2); // center

  draw_grid(w, h);
  global_diagram.draw(0, 0);

  popMatrix();


  // DEBUG
}