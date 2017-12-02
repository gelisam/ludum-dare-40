// CONSTANTS

final int WINDOW_WIDTH = 1280;
final int WINDOW_HEIGHT = 800;
final int TIMESLOT_WIDTH = 100;
final int TIMESLOT_HEIGHT = 100;
final int CLASS_WIDTH = 60;
final int CLASS_HEIGHT = 60;
final int CLASS_DX = (TIMESLOT_WIDTH - CLASS_WIDTH) / 2;
final int CLASS_DY = (TIMESLOT_HEIGHT - CLASS_HEIGHT) / 2;
final int CALENDAR_GAP = 150;
final int SOURCE_CALENDAR_X = 65;
final int SOURCE_CALENDAR_Y = 45;
final int TARGET_CALENDAR_X = 502;
final int TARGET_CALENDAR_Y = 45;

// connector types
final int NO_CONNECTOR = 0;
final int WHITE_ARROW_CONNECTOR = 1; // inheritance
final int BLACK_DIAMOND_CONNECTOR = 2; // composition
final int WHITE_DIAMOND_CONNECTOR = 3; // aggregation

// interactive modes
final int INTERACTIVE_MODE = 0;
final int DISPLAYING_CONFLICTS_MODE = 1;


// GLOBALS

int global_mode = 0;
float global_t = 0.0;

final NamePool global_name_pool = new NamePool();
Calendar global_source_calendar;
Calendar global_target_calendar;

PFont font;
PImage background_image;
PImage timeslot_image;
PImage anchor_image;
PImage hover_image;


void setup() {
  size(1280, 800);

  stroke(0);
  font = loadFont("TektonPro-BoldObl-16.vlw");
  textFont(font, 16);
  textAlign(CENTER);

  background_image = loadImage("background_paper.png");
  timeslot_image = loadImage("background_timeslot.png");
  anchor_image = loadImage("background_timeslot_hilight.png");
  hover_image = loadImage("background_timeslot_hover.png");


  Box box;


  global_source_calendar = new Calendar(1, 2);

  box = new Box(BLACK_DIAMOND_CONNECTOR);
  box.connectors.add(new PVector(0, 1));
  global_source_calendar.diagram.boxes.put(new PVector(0, 0), box);

  box = new Box(NO_CONNECTOR);
  global_source_calendar.diagram.boxes.put(new PVector(0, 1), box);

  global_source_calendar.guess_anchor();


  global_target_calendar = new Calendar(3, 4);

  box = new Box(WHITE_ARROW_CONNECTOR);
  box.connectors.add(new PVector(0, 1));
  global_target_calendar.diagram.boxes.put(new PVector(1, 1), box);

  box = new Box(NO_CONNECTOR);
  global_target_calendar.diagram.boxes.put(new PVector(1, 2), box);
}


boolean are_int_vectors_equal(PVector u, PVector v) {
  return (floor(u.x) == floor(v.x)) && (floor(u.y) == floor(v.y));
}

boolean are_connector_types_compatible(int connector_type1, int connector_type2) {
  return (connector_type1 == NO_CONNECTOR) || (connector_type2 == NO_CONNECTOR) || (connector_type1 == connector_type2);
}



void display_conflicts() {
  global_mode = DISPLAYING_CONFLICTS_MODE;
  global_t = 0.0;
}

boolean is_flashing_red() {
  return (global_t % 0.2 < 0.1);
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
  boolean conflicting = false;
  boolean conflicting_connector = false;

  Box(int connector_type_) {
    name = global_name_pool.next_name();
    connector_type = connector_type_;
  }

  Box(Box other) {
    name = other.name;
    connector_type = other.connector_type;
    for (PVector connector : other.connectors) {
      connectors.add(connector);
    }
  }

  void clear_conflict_markers() {
    conflicting = false;
    conflicting_connector = false;
  }

  void draw_box(int i, int j) {
    int x = i*TIMESLOT_WIDTH+CLASS_DX;
    int y = j*TIMESLOT_HEIGHT+CLASS_DY;

    if (conflicting && is_flashing_red()) {
      stroke(205, 15, 15);
    } else {
      stroke(0);
    }

    if (conflicting && is_flashing_red()) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    rect(x, y, CLASS_WIDTH, CLASS_HEIGHT-1);
    line(x, y+20, x+CLASS_WIDTH, y+20);

    if (conflicting && is_flashing_red()) {
      fill(205, 15, 15);
    } else {
      fill(0);
    }
    text(name, x+CLASS_WIDTH/2, y+15);
  }

  void draw_connector(int i1, int j1, int i2, int j2) {
    int x1 = i1*TIMESLOT_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y1 = j1*TIMESLOT_HEIGHT+CLASS_DY+CLASS_HEIGHT;
    int x2 = i2*TIMESLOT_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y2 = j2*TIMESLOT_HEIGHT+CLASS_DY;


    if (conflicting_connector && is_flashing_red()) {
      stroke(205, 15, 15);
    } else {
      stroke(0);
    }
    if (connector_type == NO_CONNECTOR) {
      line(x1, y1, x1, y1+10);
    } else if (connector_type == WHITE_ARROW_CONNECTOR) {
      if (conflicting_connector && is_flashing_red()) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      quad(x1, y1, x1-5, y1+10, x1, y1+10, x1+5, y1+10);
    } else {
      if (connector_type == BLACK_DIAMOND_CONNECTOR) {
        if (conflicting_connector && is_flashing_red()) {
          fill(205, 15, 15);
        } else {
          fill(0);
        }
      } else {
        if (conflicting_connector && is_flashing_red()) {
          fill(255, 0, 0);
        } else {
          fill(255);
        }
      }
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

  PVector guess_anchor() {
    for (PVector delta : boxes.keySet()) {
      return delta;
    }

    return null;
  }

  // in case of conflict, conflict markers are added and null is returned.
  Diagram merge(PVector anchor, Diagram other, PVector other_anchor) {
    Diagram result = new Diagram();
    boolean conflicting = false;

    Box anchor_box = boxes.get(anchor);

    for (PVector delta : boxes.keySet()) {
      Box box = boxes.get(delta);
      result.boxes.put(delta, new Box(box));
    }

    PVector anchor_delta = PVector.sub(anchor, other_anchor);
    for (PVector delta : other.boxes.keySet()) {
      Box other_box = other.boxes.get(delta);
      PVector dest = PVector.add(delta, anchor_delta);

      Box existing_box = boxes.get(dest);
      if (existing_box == null) {
        result.boxes.put(dest, new Box(other_box));
      } else if (are_int_vectors_equal(dest, anchor)) {
        // anchor point, both boxes are supposed to match
        if (are_connector_types_compatible(existing_box.connector_type, other_box.connector_type)) {
          Box result_box = result.boxes.get(dest);
          result_box.connector_type = existing_box.connector_type | other_box.connector_type;
          for (PVector other_connector : other_box.connectors) {
            result_box.connectors.add(other_connector);
          }
        } else {
          conflicting = true;
          anchor_box.conflicting_connector = true;
        }
      } else {
        conflicting = true;
        other_box.conflicting = true;
        existing_box.conflicting = true;
      }
    }

    if (conflicting) {
      return null;
    } else {
      return result;
    }
  }

  void clear_conflict_markers() {
    for (PVector delta : boxes.keySet()) {
      Box box = boxes.get(delta);
      box.clear_conflict_markers();
    }
  }

  void draw_anchor(int i, int j) {
    float r = 40;
    stroke(255, 0, 0);
    noFill();
    ellipse(i*TIMESLOT_WIDTH+TIMESLOT_WIDTH/2, j*TIMESLOT_HEIGHT+TIMESLOT_HEIGHT/2, 2*r, 2*r);
  }

  void draw(int i, int j) {
    for (PVector delta : boxes.keySet()) {
      Box box = boxes.get(delta);
      box.draw(i+round(delta.x), j+round(delta.y));
    }
  }
}

class Calendar {
  int w;
  int h;
  Diagram diagram;
  PVector anchor = null;
  PVector hover = null;

  Calendar(int w_, int h_) {
    w = w_;
    h = h_;
    diagram = new Diagram();
  }

  void guess_anchor() {
    anchor = diagram.guess_anchor();
  }

  void clear_conflict_markers() {
    diagram.clear_conflict_markers();
  }

  void draw_grid(int w, int h) {
    stroke(128);
    for (int i=0; i<w; ++i) {
      for (int j=0; j<h; ++j) {
        boolean is_anchor = (anchor != null) && (i == round(anchor.x)) && (j == round(anchor.y));
        boolean is_hover = (hover != null) && (i == round(hover.x)) && (j == round(hover.y));
        image(is_anchor ? anchor_image : is_hover ? hover_image : timeslot_image, i*TIMESLOT_WIDTH, j*TIMESLOT_HEIGHT);
      }
    }
  }

  void draw() {
    draw_grid(w, h);
    diagram.draw(0, 0);
  }
}


void draw() {
  // UPDATE
  global_t += 1.0/60; // assumes 60fps

  if (global_mode == DISPLAYING_CONFLICTS_MODE && global_t > 0.5) {
    global_source_calendar.clear_conflict_markers();
    global_target_calendar.clear_conflict_markers();
    global_mode = INTERACTIVE_MODE;
  }


  // DRAW

  image(background_image, 0, 0);
  pushMatrix();

  translate(SOURCE_CALENDAR_X, SOURCE_CALENDAR_Y); // pushMatrix()
  global_source_calendar.draw();
  translate(-SOURCE_CALENDAR_X, -SOURCE_CALENDAR_Y); // popMatrix()

  translate(TARGET_CALENDAR_X, TARGET_CALENDAR_Y); // pushMatrix()
  global_target_calendar.draw();
  translate(-TARGET_CALENDAR_X, -TARGET_CALENDAR_Y); // popMatrix()

  popMatrix();


  // DEBUG
}

void mouseReleased() {
  if (global_mode == INTERACTIVE_MODE && global_target_calendar.hover != null) {
    Diagram result = global_target_calendar.diagram.merge(global_target_calendar.hover, global_source_calendar.diagram, global_source_calendar.anchor);
    if (result == null) {
      display_conflicts();
    } else {
      global_target_calendar.diagram = result;
    }
  }
}

void mouseMoved() {
  float x = mouseX - TARGET_CALENDAR_X;
  float y = mouseY - TARGET_CALENDAR_Y;
  int i = floor(x / TIMESLOT_WIDTH);
  int j = floor(y / TIMESLOT_HEIGHT);
  if (i >= 0 && i < global_target_calendar.w && j >= 0 && j < global_target_calendar.h) {
    global_target_calendar.hover = new PVector(i, j);
  } else {
    global_target_calendar.hover = null;
  }
}