import processing.sound.*;


// CONSTANTS

final int WINDOW_WIDTH = 1280;
final int WINDOW_HEIGHT = 800;
final int TIMESLOT_WIDTH = 100;
final int TIMESLOT_HEIGHT = 100;
final int CLASS_WIDTH = 90;
final int CLASS_HEIGHT = 65;
final int CLASS_DX = (TIMESLOT_WIDTH - CLASS_WIDTH) / 2;
final int CLASS_DY = (TIMESLOT_HEIGHT - CLASS_HEIGHT) / 2;
final int CALENDAR_GAP = 150;
final int SOURCE_CALENDAR_X = 20; //65;
final int SOURCE_CALENDAR_Y = 85;
final int TARGET_CALENDAR_X = 556; //502;
final int TARGET_CALENDAR_Y = 85;
final int REFACTOR_BUTTON_WIDTH = 236;
final int REFACTOR_BUTTON_HEIGHT = 80;
final int REFACTOR_BUTTON_X = SOURCE_CALENDAR_X;
final int REFACTOR_BUTTON_Y = SOURCE_CALENDAR_Y+620;
final int COMMIT_BUTTON_WIDTH = 236;
final int COMMIT_BUTTON_HEIGHT = 80;
final int COMMIT_BUTTON_X = SOURCE_CALENDAR_X+262;
final int COMMIT_BUTTON_Y = REFACTOR_BUTTON_Y;

// connector types
final int NO_CONNECTOR = 0;
final int WHITE_ARROW_CONNECTOR = 1; // inheritance
final int BLACK_DIAMOND_CONNECTOR = 2; // composition
final int WHITE_DIAMOND_CONNECTOR = 3; // aggregation

// interactive modes
final int INTERACTIVE_MODE = 0;
final int DISPLAYING_CONFLICTS_MODE = 1;
final int ADMIRING_RESULTS_MODE = 2;
final int FIRST_SLIDE_MODE = 3;
final int DOWN_SLIDE_IN_MODE = 3;
final int DOWN_SLIDE_MODE = 4;
final int DOWN_SLIDE_OUT_MODE = 5;
final int UP_SLIDE_IN_MODE = 6;
final int UP_SLIDE_MODE = 7;
final int UP_SLIDE_OUT_MODE = 8;
final int RIGHT_SLIDE_IN_MODE = 9;
final int RIGHT_SLIDE_MODE = 10;
final int RIGHT_SLIDE_OUT_MODE = 11;
final int LEFT_SLIDE_IN_MODE = 12;
final int LEFT_SLIDE_MODE = 13;
final int LEFT_SLIDE_OUT_MODE = 14;
final int LAST_SLIDE_MODE = 14;

final int BOX_ALPHA = 128;

final float BOX_CORNER_FUDGE = 1.0f;
final PVector BOX_CORNER_SCALE = new PVector(BOX_CORNER_FUDGE*CLASS_WIDTH/100.0, BOX_CORNER_FUDGE*CLASS_HEIGHT/100.0);
// Corners for line intersections, measured from 0-100
final PVector BOX_CORNER_UL = new PVector( BOX_CORNER_SCALE.x*5, BOX_CORNER_SCALE.y*3 );
final PVector BOX_CORNER_UR = new PVector( BOX_CORNER_SCALE.x*97, BOX_CORNER_SCALE.y*3 );
final PVector BOX_CORNER_ML = new PVector( BOX_CORNER_SCALE.x*4, BOX_CORNER_SCALE.y*28 );
final PVector BOX_CORNER_MR = new PVector( BOX_CORNER_SCALE.x*96, BOX_CORNER_SCALE.y*28 );
final PVector BOX_CORNER_LL = new PVector( BOX_CORNER_SCALE.x*3, BOX_CORNER_SCALE.y*97 );
final PVector BOX_CORNER_LR = new PVector( BOX_CORNER_SCALE.x*95, BOX_CORNER_SCALE.y*97 );
// Corners for horizontal lines, measured from 0-100
final PVector BOX_CORNER_HUL = new PVector( BOX_CORNER_UL.x-1, BOX_CORNER_UL.y );
final PVector BOX_CORNER_HUR = new PVector( BOX_CORNER_UR.x+1, BOX_CORNER_UL.y );
final PVector BOX_CORNER_HML = new PVector( BOX_CORNER_ML.x-1, BOX_CORNER_ML.y );
final PVector BOX_CORNER_HMR = new PVector( BOX_CORNER_MR.x-1, BOX_CORNER_MR.y );
final PVector BOX_CORNER_HLL = new PVector( BOX_CORNER_LL.x-1, BOX_CORNER_LL.y );
final PVector BOX_CORNER_HLR = new PVector( BOX_CORNER_LR.x-1, BOX_CORNER_LR.y );
// Corners for vertical lines, measured from 0-100
final PVector BOX_CORNER_VUL = new PVector( BOX_CORNER_UL.x, BOX_CORNER_UL.y-1 );
final PVector BOX_CORNER_VLL = new PVector( BOX_CORNER_LL.x, BOX_CORNER_LL.y+1 );
final PVector BOX_CORNER_VUR = new PVector( BOX_CORNER_UR.x, BOX_CORNER_UR.y-1 );
final PVector BOX_CORNER_VLR = new PVector( BOX_CORNER_LR.x, BOX_CORNER_LR.y+1 );

// GLOBALS

int global_mode = RIGHT_SLIDE_MODE;
float global_t = 0.0;

boolean playing_ambient = false;
boolean muted = false;

int current_scenario;
int current_round;

ArrayList<Diagram> global_completed_diagrams;
Diagram global_completed_diagram;
Diagram global_source_diagram;
Diagram global_target_diagram;
Diagram global_next_source_diagram;
Diagram global_next_target_diagram;

Slide global_slide = null;
HashMap<PVector, Boolean> seen_transitions = new HashMap<PVector, Boolean>();

PFont font16;
PFont font24;
PFont font32;
PFont font48;
PImage title_image;
PImage background_image;
PImage timeslot_image;
PImage anchor_image;
PImage hover_image;
PImage conflicting_timeslot_image;
PImage blocker_image;
SoundFile ambient_sound;
SoundFile key1a_sound;
SoundFile key1b_sound;
SoundFile key2a_sound;
SoundFile key2b_sound;
SoundFile key3a_sound;
SoundFile key3b_sound;
SoundFile key4a_sound;
SoundFile key4b_sound;
SoundFile key5a_sound;
SoundFile key5b_sound;
SoundFile key5c_sound;
SoundFile key6a_sound;

Button refactor_button;
Button commit_button;

// null if the scenario is complete
Diagram loadRound(int scenario, int round, boolean for_real)
{
  Diagram result = new Diagram(7, 7);
  Box box;
  Blocker blocker;

  if (scenario == 1) {
    if (round == 0) {
      if (for_real) {
        box = new Box( "Genre:Gothic", BLACK_DIAMOND_CONNECTOR);
        box.connectors.add(new PVector(0, 1));
        result.entries.put(new PVector(0, 0), box);

        box = new Box("Steampunk", WHITE_ARROW_CONNECTOR);
        result.entries.put(new PVector(0, 1), box);
      }
    } else if (round == 1) {
      if (for_real) {
        global_slide = new Slide("");
        global_slide.image = title_image;
        global_slide.next_slide = new Slide("Scenario 1 - Tutorial");
        global_slide.next_slide.bullet_points.append("• Click one UML class from \"code complete\"");
        global_slide.next_slide.bullet_points.append("• Match to a UML class from \"work in progress\"");
        global_slide.next_slide.bullet_points.append("• Symbols on both classes must match");
        global_slide.next_slide.bullet_points.append("• No other class may overlap");
        global_slide.next_slide.bullet_points.append("• Commit your work when done");
        global_slide.next_slide.bullet_points.append("• Don't forget to breathe!");


        box = new Box("Librarian", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(0, 1));
        result.entries.put(new PVector(3, 2), box);

        box = new Box("Genre:Gothic", BLACK_DIAMOND_CONNECTOR);
        result.entries.put(new PVector(3, 3), box);
      }
    } else if (round == 2) {
      if (for_real) {
        if (!muted) {
          key1a_sound.play();
          delay(600);
        }

        global_slide = new Slide("Scenario 1 - Phase 2");
        global_slide.bullet_points.append("• If you can't resolve code conflicts, you may need to refactor");
        global_slide.bullet_points.append("• Corporate policy: research time is for business purpopses only");


        box = new Box("Dating Sim", BLACK_DIAMOND_CONNECTOR);
        result.entries.put(new PVector(3, 2), box);

        blocker = new Blocker("\" RESEARCH \"");
        result.entries.put(new PVector(3, 3), blocker);

        blocker = new Blocker("* cough *");
        result.entries.put(new PVector(3, 4), blocker);
      }
    } else if (round == 3) {
      if (for_real) {
        if (!muted) {
          key2a_sound.play();
          delay(700);
        }

        global_slide = new Slide("Scenario 1 - Phase 3");
        global_slide.bullet_points.append("• New corporate priority: Movie Catalog");


        box = new Box("Horror", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(-1, 1));
        box.connectors.add(new PVector(1, 1));
        result.entries.put(new PVector(2, 0), box);

        box = new Box("Slasher", BLACK_DIAMOND_CONNECTOR);
        result.entries.put(new PVector(1, 1), box);

        box = new Box("Zombie", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(2, 1));
        result.entries.put(new PVector(3, 1), box);

        box = new Box("Apocalypse", BLACK_DIAMOND_CONNECTOR);
        result.entries.put(new PVector(5, 2), box);
      }
    } else if (round == 4) {
      if (for_real) {
        if (!muted) {
          key3b_sound.play();
          delay(800);
        }

        global_slide = new Slide("Scenario 1 - Phase 4");
        global_slide.bullet_points.append("• New corporate priority: House Appraisal Database");


        box = new Box("HouseType", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(-1, 1));
        result.entries.put(new PVector(5, 1), box);

        box = new Box("HouseDate", BLACK_DIAMOND_CONNECTOR);
        result.entries.put(new PVector(4, 2), box);

        blocker = new Blocker("nap");
        result.entries.put(new PVector(0, 1), blocker);
        blocker = new Blocker("nap");
        result.entries.put(new PVector(1, 2), blocker);
        blocker = new Blocker("...zzz...");
        result.entries.put(new PVector(2, 2), blocker);
        blocker = new Blocker("nap");
        result.entries.put(new PVector(3, 3), blocker);
        blocker = new Blocker("munchies");
        result.entries.put(new PVector(4, 3), blocker);
        blocker = new Blocker("nap");
        result.entries.put(new PVector(5, 3), blocker);
      }
    } else if (round == 5) {
      if (for_real) {
        if (!muted) {
          key4a_sound.play();
          delay(1200);
        }

        global_slide = new Slide("Scenario 1 - Final Phase");
        global_slide.bullet_points.append("• New corporate policy: no naps!");
        global_slide.bullet_points.append("• Remember the company's moto: red, green, refactor, refactor, refactor");


        box = new Box("Clown", NO_CONNECTOR);
        result.entries.put(new PVector(2, 1), box);
        box = new Box("Zombie", WHITE_ARROW_CONNECTOR);
        result.entries.put(new PVector(3, 1), box);

        box = new Box("Dragon", NO_CONNECTOR);
        //box.connectors.add(new PVector(-2, 1));
        result.entries.put(new PVector(5, 1), box);

        blocker = new Blocker("Weekend");
        result.entries.put(new PVector(0, 0), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(0, 1), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(0, 2), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(1, 0), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(1, 2), blocker);
        blocker = new Blocker("Camp");
        result.entries.put(new PVector(2, 2), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(4, 0), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(4, 3), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(5, 0), blocker);
        blocker = new Blocker("Weekend");
        result.entries.put(new PVector(6, 0), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(6, 1), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(6, 2), blocker);
        blocker = new Blocker("Netflix\n& Chill");
        result.entries.put(new PVector(3, 3), blocker);
        blocker = new Blocker("Cards");
        result.entries.put(new PVector(4, 2), blocker);
        blocker = new Blocker("Metal Band");
        result.entries.put(new PVector(5, 3), blocker);
      }
    } else {
      return null;
    }
  } else if (scenario == 2) {
    if (round == 0) {
      if (for_real) {
        box = new Box("Source", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(0, 2));
        result.entries.put(new PVector(0, 0), box);

        box = new Box("Target", NO_CONNECTOR);
        result.entries.put(new PVector(0, 2), box);
      }
    } else if (round == 1) {
      if (for_real) {
        if (!muted) {
          key5a_sound.play();
          delay(1500);
        }

        global_slide = new Slide("Congratulations on finishing the tutorial!");
        global_slide.next_slide = new Slide("Scenario 2 - Network code");
        global_slide.next_slide.bullet_points.append("• Management assessment: Piece of cake");
        global_slide.next_slide.bullet_points.append("• Corporate policy: Enjoy your weekends");


        for (int j=0; j<7; ++j) {
          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(0, j), blocker);

          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(6, j), blocker);
        }

        blocker = new Blocker("Meeting about\npriorities");
        result.entries.put(new PVector(2, 1), blocker);

        blocker = new Blocker("Meeting about\ntech debt");
        result.entries.put(new PVector(3, 4), blocker);

        blocker = new Blocker("Meeting about\n\"Agile\"");
        result.entries.put(new PVector(5, 6), blocker);

        box = new Box("Agent", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(-1, 2));
        box.connectors.add(new PVector(1, 2));
        result.entries.put(new PVector(3, 2), box);

        box = new Box("Server", NO_CONNECTOR);
        result.entries.put(new PVector(2, 4), box);

        box = new Box("Client", NO_CONNECTOR);
        result.entries.put(new PVector(4, 4), box);
      }
    } else if (round == 2) {
      if (for_real) {
        if (!muted) {
          key2b_sound.play();
          delay(700);
        }

        global_slide = new Slide("Scenario 2 - Agile tutorial");
        global_slide.bullet_points.append("• Limit your resources so you can focus on what's important");
        global_slide.bullet_points.append("• Make sure everyone is on the same page by meeting early and often");
        global_slide.bullet_points.append("• Don't run a marathon: run multiple sprints in a row!");


        for (int j=0; j<6; ++j) {
          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(0, j), blocker);

          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(6, j), blocker);

          if (j % 2 == 0) {
            blocker = new Blocker("Sprint planning");
            result.entries.put(new PVector(1, j), blocker);
          } else {
            blocker = new Blocker("Sprint review");
            result.entries.put(new PVector(5, j), blocker);
          }
        }

        blocker = new Blocker("");
        result.entries.put(new PVector(0, 6), blocker);

        blocker = new Blocker("Week-long");
        result.entries.put(new PVector(1, 6), blocker);

        blocker = new Blocker("seminar");
        result.entries.put(new PVector(2, 6), blocker);

        blocker = new Blocker("about");
        result.entries.put(new PVector(3, 6), blocker);

        blocker = new Blocker("code");
        result.entries.put(new PVector(4, 6), blocker);

        blocker = new Blocker("quality");
        result.entries.put(new PVector(5, 6), blocker);

        blocker = new Blocker("");
        result.entries.put(new PVector(6, 6), blocker);

        box = new Box("Sender", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(0, 2));
        result.entries.put(new PVector(2, 1), box);

        box = new Box("Receiver", NO_CONNECTOR);
        result.entries.put(new PVector(2, 3), box);
      }
    } else if (round == 3) {
      if (for_real) {
        if (!muted) {
          key3b_sound.play();
          delay(800);
        }

        global_slide = new Slide("Scenario 2 - Phase 3");
        global_slide.bullet_points.append("• Client just shortened the deadline");
        global_slide.bullet_points.append("• Fix critical bugs and ship");
        global_slide.bullet_points.append("• New corporate policy: put the K in kwality assurance");


        for (int j=0; j<5; ++j) {
          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(0, j), blocker);

          blocker = new Blocker((j == 0) ? "Weekend" : "");
          result.entries.put(new PVector(6, j), blocker);

          if (j % 2 == 0) {
            blocker = new Blocker("Sprint planning");
            result.entries.put(new PVector(1, j), blocker);
          } else {
            blocker = new Blocker("Unit tests");
            result.entries.put(new PVector(3, j), blocker);

            blocker = new Blocker("QA");
            result.entries.put(new PVector(4, j), blocker);

            blocker = new Blocker("Sprint review");
            result.entries.put(new PVector(5, j), blocker);
          }
        }

        blocker = new Blocker("Unit tests");
        result.entries.put(new PVector(4, 4), blocker);

        blocker = new Blocker("QA");
        result.entries.put(new PVector(5, 4), blocker);

        blocker = new Blocker("");
        result.entries.put(new PVector(0, 5), blocker);

        blocker = new Blocker("Sprint review");
        result.entries.put(new PVector(1, 5), blocker);

        blocker = new Blocker("DEADLINE");
        result.entries.put(new PVector(2, 5), blocker);

        box = new Box("Connector", WHITE_ARROW_CONNECTOR);
        box.connectors.add(new PVector(0, 2));
        result.entries.put(new PVector(3, 2), box);

        box = new Box("Connectee", NO_CONNECTOR);
        result.entries.put(new PVector(3, 4), box);
      }
    } else if (round == 4) {
      if (for_real) {
        if (!muted) {
          key4b_sound.play();
          delay(1100);
        }

        global_slide = new Slide("Scenario 2 - Final Phase");
        global_slide.bullet_points.append("• Client threatening legal action");
        global_slide.bullet_points.append("• Just ship it, by any means possible");
        global_slide.bullet_points.append("• New corporate policy: on second thought, weekends are for work");


        for (int j=0; j<4; ++j) {
          box = new Box("Work", BLACK_DIAMOND_CONNECTOR);
          box.connectors.add(new PVector(5-0, 4-j));
          result.entries.put(new PVector(0, j), box);

          box = new Box("Work", WHITE_DIAMOND_CONNECTOR);
          box.connectors.add(new PVector(5-6, 4-j));
          result.entries.put(new PVector(6, j), box);

          if (j % 2 == 0) {
            blocker = new Blocker("Sprint planning");
            result.entries.put(new PVector(1, j), blocker);
          } else {
            blocker = new Blocker("Unit tests");
            result.entries.put(new PVector(3, j), blocker);

            blocker = new Blocker("QA");
            result.entries.put(new PVector(4, j), blocker);

            blocker = new Blocker("Sprint review");
            result.entries.put(new PVector(5, j), blocker);
          }
        }

        blocker = new Blocker("Therapy");
        result.entries.put(new PVector(6, 2), blocker);

        blocker = new Blocker("Last minute\ntesting");
        result.entries.put(new PVector(6, 4), blocker);

        for (int j=5; j<7; ++j) {
          for (int i=0; i<7; ++i) {
            blocker = new Blocker("");
            result.entries.put(new PVector(i, j), blocker);
          }
        }
        blocker = new Blocker("Real\ndeadline");
        result.entries.put(new PVector(0, 5), blocker);

        box = new Box("Polish", NO_CONNECTOR);
        result.entries.put(new PVector(5, 4), box);
      }
    } else {
      return null;
    }
  } else if (scenario == 3) {
    if (round == 0) {
    } else if (round == 1) {
      if (for_real) {
        if (!muted) {
          key6a_sound.play();
          delay(1500);
          key1b_sound.play();
          delay(600);
        }

        global_slide = new Slide("Congratulations on finishing the game!");
        global_slide.bullet_points.append("• New corporate priority: Champagne");
        global_slide.bullet_points.append("• New corporate priority: Just kidding, more work");
        global_slide.bullet_points.append("• Did you find both solutions?");


        blocker = new Blocker("by");
        result.entries.put(new PVector(1, 2), blocker);
        blocker = new Blocker("Michaelson\nBritt");
        result.entries.put(new PVector(2, 2), blocker);

        blocker = new Blocker("and");
        result.entries.put(new PVector(1, 4), blocker);
        blocker = new Blocker("Samuel\nGélineau");
        result.entries.put(new PVector(2, 4), blocker);

        blocker = new Blocker("CRUNCH TIME");
        result.entries.put(new PVector(4, 0), blocker);
        blocker = new Blocker("Made in 48h");
        result.entries.put(new PVector(5, 1), blocker);
        blocker = new Blocker("for\nLudum Dare 40");
        result.entries.put(new PVector(5, 2), blocker);
        blocker = new Blocker("");
        result.entries.put(new PVector(5, 3), blocker);
        blocker = new Blocker("the theme was");
        result.entries.put(new PVector(5, 4), blocker);
        blocker = new Blocker("The more\nyou have");
        result.entries.put(new PVector(5, 5), blocker);
        blocker = new Blocker("the worse\nit is");
        result.entries.put(new PVector(4, 6), blocker);
      }
    } else {
      return null;
    }
  } else {
    return null;
  }

  if (for_real && seen_transitions.get(new PVector(current_scenario, current_round)) != null) {
    global_slide = null;
  }

  return result;
}

void loadScenario(int scenario) {
  global_completed_diagrams = new ArrayList();

  current_scenario = scenario;
  current_round = 1;

  Diagram completed_diagram = loadRound(scenario, 0, true).shrink();
  global_completed_diagrams.add(completed_diagram);

  global_next_source_diagram = completed_diagram;
  global_next_source_diagram.guess_anchor();

  global_next_target_diagram = loadRound(scenario, 1, true);
}

void setup() {
  size(1280, 800);

  stroke(0);
  font16 = loadFont("TektonPro-BoldObl-16.vlw");
  font24 = loadFont("TektonPro-BoldObl-24.vlw");
  font32 = loadFont("TektonPro-BoldObl-32.vlw");
  font48 = loadFont("TektonPro-BoldObl-48.vlw");
  textAlign(CENTER);

  title_image = loadImage("title.png");
  background_image = loadImage("background_paper.png");
  timeslot_image = loadImage("background_timeslot.png");
  anchor_image = loadImage("background_timeslot_hilight.png");
  hover_image = loadImage("background_timeslot_hover.png");
  conflicting_timeslot_image = loadImage("background_timeslot_conflict.png");
  blocker_image = loadImage("blocker.png");
  ambient_sound = new SoundFile(this, "ambient.ogg");
  key1a_sound = new SoundFile(this, "sound_keystroke_1a.ogg");
  key1b_sound = new SoundFile(this, "sound_keystroke_1b.ogg");
  key2a_sound = new SoundFile(this, "sound_keystroke_2a.ogg");
  key2b_sound = new SoundFile(this, "sound_keystroke_2b.ogg");
  key3a_sound = new SoundFile(this, "sound_keystroke_3a.ogg");
  key3b_sound = new SoundFile(this, "sound_keystroke_3b.ogg");
  key4a_sound = new SoundFile(this, "sound_keystroke_4a.ogg");
  key4b_sound = new SoundFile(this, "sound_keystroke_4b.ogg");
  key5a_sound = new SoundFile(this, "sound_keystroke_5a.ogg");
  key5b_sound = new SoundFile(this, "sound_keystroke_5b.ogg");
  key5c_sound = new SoundFile(this, "sound_keystroke_5c.ogg");
  key6a_sound = new SoundFile(this, "sound_keystroke_6a.ogg");

  // Init buttons
  refactor_button = new Button("REFACTOR", REFACTOR_BUTTON_WIDTH, REFACTOR_BUTTON_HEIGHT);
  commit_button = new Button("COMMIT", COMMIT_BUTTON_WIDTH, COMMIT_BUTTON_HEIGHT); 

  loadScenario(1);
  global_source_diagram = global_next_source_diagram;
  global_target_diagram = global_next_target_diagram;
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


boolean can_refactor() {
  return (global_mode == INTERACTIVE_MODE || global_mode == ADMIRING_RESULTS_MODE) && (global_completed_diagrams.size() > 1);
}

void refactor() {
  if (can_refactor()) {
    --current_round;

    global_next_source_diagram = global_completed_diagrams.remove(global_completed_diagrams.size() - 1);
    global_next_source_diagram.guess_anchor();

    global_next_target_diagram = loadRound(current_scenario, current_round, true);

    slide_up();
  }
}

boolean can_commit() {
  return (global_mode == ADMIRING_RESULTS_MODE);
}

boolean is_last_round() {
  return (loadRound(current_scenario, current_round+1, false) == null);
}

boolean is_last_scenario() {
  return (loadRound(current_scenario+1, 1, false) == null);
}

void commit() {
  if (can_commit()) {
    ++current_round;

    global_completed_diagrams.add(global_completed_diagram);

    global_next_source_diagram = global_target_diagram.simplify();
    global_next_source_diagram.guess_anchor();

    Diagram next_diagram = loadRound(current_scenario, current_round, true);
    if (next_diagram == null) {
      if (is_last_scenario()) {
        loadScenario(1);
        global_slide = null;
        slide_left();
      } else {
        loadScenario(current_scenario+1);
        slide_right();
      }
    } else {
      global_next_target_diagram = next_diagram;
      slide_down();
    }
  }
}

void slide_right() {
  global_t = 0.0;
  global_mode = RIGHT_SLIDE_IN_MODE;
}

void slide_left() {
  global_t = 0.0;
  global_mode = LEFT_SLIDE_IN_MODE;
}

void slide_down() {
  global_t = 0.0;
  global_mode = DOWN_SLIDE_IN_MODE;
}

void slide_up() {
  global_t = 0.0;
  global_mode = UP_SLIDE_IN_MODE;
}

void dismiss_slide() {
  seen_transitions.put(new PVector(current_scenario, current_round), true);

  if (global_mode == RIGHT_SLIDE_MODE) {
    global_t = 0.0;
    global_mode = RIGHT_SLIDE_OUT_MODE;
  } else if (global_mode == LEFT_SLIDE_MODE) {
    global_t = 0.0;
    global_mode = LEFT_SLIDE_OUT_MODE;
  } else if (global_mode == DOWN_SLIDE_MODE) {
    if (!playing_ambient) {
      playing_ambient = true;

      if (!muted) {
        ambient_sound.loop();
      }
    }

    global_t = 0.0;
    global_mode = DOWN_SLIDE_OUT_MODE;
  } else if (global_mode == UP_SLIDE_MODE) {
    global_t = 0.0;
    global_mode = UP_SLIDE_OUT_MODE;
  }
}

class Slide {
  PImage image = null;
  Slide next_slide = null;
  String title;
  StringList bullet_points = new StringList();

  Slide(String title_) {
    title = title_;
  }

  void draw() {
    if (image != null) {
      image(image, 0, 0);
    } else {
      fill(0);
      textFont(font48, 48);
      text(title, WINDOW_WIDTH/2, WINDOW_HEIGHT/4);

      textFont(font32, 32);
      textAlign(LEFT);
      for (int j=0; j<bullet_points.size(); ++j) {
        text(bullet_points.get(j), WINDOW_WIDTH/4, WINDOW_HEIGHT/2 + j*50);
      }
      textAlign(CENTER);
    }

    if (next_slide != null) {
      translate(WINDOW_WIDTH, 0); // pushMatrix()
      next_slide.draw();
      translate(-WINDOW_WIDTH, 0); // popMatrix()
    }
  }
}


class Region {
  PVector upper_left;
  PVector lower_right;

  Region(PVector upper_left_, PVector lower_right_) {
    upper_left = upper_left_;
    lower_right = lower_right_;
  }

  boolean contains_int_vector(PVector v) {
    return (floor(v.x) >= floor(upper_left.x) && floor(v.x) <= floor(lower_right.x) && floor(v.y) >= floor(upper_left.y) && floor(v.y) <= floor(lower_right.y));
  }

  boolean contains_smaller_region(Region other) {
    return (floor(other.upper_left.x) >= floor(upper_left.x)) && (floor(other.lower_right.x) <= floor(lower_right.x)) && (floor(other.upper_left.y) >= floor(upper_left.y)) && (floor(other.lower_right.y) <= floor(lower_right.y));
  }
}

class NamePool {
  StringList unused_names;

  NamePool() {
    refill_names();
  }

  void refill_names() {
    unused_names = new StringList();
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
    if (unused_names.size() == 0) refill_names();
    return unused_names.remove(0);
  }
}


abstract class Entry {
  String flavor_text;
  boolean conflicting = false;

  abstract Entry copy();
  abstract void clear_conflict_markers();
  abstract Entry merge(Entry other);
  abstract void draw(int i, int j);
}

class Box extends Entry {
  int connector_type;
  ArrayList<PVector> connectors = new ArrayList<PVector>();
  boolean conflicting_connector = false;

  Box(String name, int connector_type_) {
    flavor_text = name;
    connector_type = connector_type_;
  }

  Box copy() {
    Box result = new Box(flavor_text, connector_type);

    result.flavor_text = flavor_text;
    for (PVector connector : connectors) {
      result.connectors.add(connector);
    }

    return result;
  }

  void clear_conflict_markers() {
    conflicting = false;
    conflicting_connector = false;
  }

  Box merge(Entry entry) {
    if (entry instanceof Box) {
      Box other_box = (Box) entry;

      if (are_connector_types_compatible(connector_type, other_box.connector_type)) {
        Box result = new Box(flavor_text, connector_type | other_box.connector_type);

        result.flavor_text = flavor_text;
        for (PVector connector : connectors) {
          result.connectors.add(connector);
        }
        for (PVector connector : other_box.connectors) {
          result.connectors.add(connector);
        }

        return result;
      } else {
        conflicting_connector = true;
        other_box.conflicting_connector = true;
        return null;
      }
    } else {
      conflicting = true;
      entry.conflicting = true;
      return null;
    }
  }

  void draw_box(int i, int j) {
    int x = i*TIMESLOT_WIDTH+CLASS_DX;
    int y = j*TIMESLOT_HEIGHT+CLASS_DY;

    stroke(0, BOX_ALPHA);
    fill(255, 255, 255, BOX_ALPHA);
    quad(x+BOX_CORNER_UL.x, y+BOX_CORNER_UL.y, x+BOX_CORNER_UR.x, y+BOX_CORNER_UR.y, 
      x+BOX_CORNER_MR.x, y+BOX_CORNER_MR.y, x+BOX_CORNER_ML.x, y+BOX_CORNER_ML.y);

    strokeWeight(1.8);
    strokeCap(ROUND);

    if (conflicting && is_flashing_red()) {
      stroke(205, 15, 15, BOX_ALPHA);
    } else {
      stroke(0, BOX_ALPHA);
    }

    if (conflicting && is_flashing_red()) {
      fill(255, 0, 0, BOX_ALPHA);
    } else {
      fill(255, BOX_ALPHA);
    }

    // Horizontal lines
    line(x+BOX_CORNER_HUL.x, y+BOX_CORNER_HUL.y, x+BOX_CORNER_HUR.x, y+BOX_CORNER_HUR.y);
    line(x+BOX_CORNER_HML.x, y+BOX_CORNER_HML.y, x+BOX_CORNER_HMR.x, y+BOX_CORNER_HMR.y);
    line(x+BOX_CORNER_HLL.x, y+BOX_CORNER_HLL.y, x+BOX_CORNER_HLR.x, y+BOX_CORNER_HLR.y);
    // Vertical lines
    line(x+BOX_CORNER_VUL.x, y+BOX_CORNER_VUL.y, x+BOX_CORNER_VLL.x, y+BOX_CORNER_VLL.y);
    line(x+BOX_CORNER_VUR.x, y+BOX_CORNER_VUR.y, x+BOX_CORNER_VLR.x, y+BOX_CORNER_VLR.y);

    if (conflicting && is_flashing_red()) {
      fill(205, 15, 15);
    } else {
      fill(0);
    }
    textFont(font16, 16);
    text(flavor_text, x+CLASS_WIDTH/2, y+15);
  }

  void draw_connector_glyph(int i1, int j1) {
    int x1 = i1*TIMESLOT_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y1 = j1*TIMESLOT_HEIGHT+CLASS_DY+CLASS_HEIGHT;

    // Draw connector leading line and dot

    stroke(0);
    if ( connectors.size()>0 ) {
      line(x1, y1+10, x1, y1+23.5);
    }
    if ( connectors.size()>1 ) {
      ellipse( x1, y1+25, 4, 4 );
    }

    // Draw connector glyph

    if (conflicting_connector && is_flashing_red()) {
      stroke(205, 15, 15);
    } else {
      stroke(0);
    }
    if (connector_type == NO_CONNECTOR) {
      //line(x1, y1, x1, y1+10);
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
  }

  void draw_connector_line(int i1, int j1, int i2, int j2) {
    int x1 = i1*TIMESLOT_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y1 = j1*TIMESLOT_HEIGHT+CLASS_DY+CLASS_HEIGHT;
    int x2 = i2*TIMESLOT_WIDTH+CLASS_DX+CLASS_WIDTH/2;
    int y2 = j2*TIMESLOT_HEIGHT+CLASS_DY;

    // Draw connector lines

    stroke(0);
    line(x1, y1+25, x2, y1+25);
    line(x2, y1+25, x2, y2);
  }

  void draw(int i, int j) {
    draw_box(i, j);

    draw_connector_glyph(i, j);
    for (PVector delta : connectors) {
      draw_connector_line(i, j, round(i+delta.x), round(j+delta.y));
    }
  }
}

class Blocker extends Entry {
  Blocker(String flavor_text_) {
    flavor_text = flavor_text_;
  }

  Blocker copy() {
    Blocker result = new Blocker(flavor_text);
    return result;
  }

  void clear_conflict_markers() {
    conflicting = false;
  }

  Blocker merge(Entry entry) {
    if (entry instanceof Blocker) {
      Blocker result = new Blocker(flavor_text);
      return result;
    } else {
      conflicting = true;
      entry.conflicting = true;
      return null;
    }
  }

  void draw(int i, int j) {
    int x = i*TIMESLOT_WIDTH;
    int y = j*TIMESLOT_HEIGHT;

    if (conflicting && is_flashing_red()) {
      stroke(255, 0, 0);
    } else {
      stroke(0);
    }
    fill(243, 228, 59);
    //rect(x, y, TIMESLOT_WIDTH, TIMESLOT_HEIGHT);
    image(blocker_image, x, y);

    if (conflicting && is_flashing_red()) {
      image(conflicting_timeslot_image, x, y);
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    textFont(font16, 16);
    text(flavor_text, x+TIMESLOT_WIDTH/2, y+TIMESLOT_HEIGHT/2);
  }
}

class Diagram {
  HashMap<PVector, Entry> entries = new HashMap<PVector, Entry>();
  int w;
  int h;
  PVector anchor = null;
  PVector hover = null;
  PVector conflicting_timeslot = null;
  Region region;
  Region non_conflicting_region = null;

  Diagram(int w_, int h_) {
    w = w_;
    h = h_;
    region = new Region(new PVector(0, 0), new PVector(w-1, h-1));
  }

  void guess_anchor() {
    for (PVector delta : entries.keySet()) {
      anchor = delta;
      return;
    }
  }

  void clear_conflict_markers() {
    conflicting_timeslot = null;
    non_conflicting_region = null;

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);
      entry.clear_conflict_markers();
    }
  }

  // in case of conflict, conflict markers are added and null is returned.
  Diagram merge(PVector anchor, Diagram other, PVector other_anchor) {
    Diagram result = new Diagram(w, h);
    boolean conflicting = false;

    Entry anchor_entry = entries.get(anchor);

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);
      result.entries.put(delta, entry.copy());
    }

    PVector anchor_delta = PVector.sub(anchor, other_anchor);
    for (PVector delta : other.entries.keySet()) {
      Entry other_entry = other.entries.get(delta);
      PVector dest = PVector.add(delta, anchor_delta);

      Entry existing_entry = entries.get(dest);
      if (existing_entry == null) {
        result.entries.put(dest, other_entry.copy());
      } else if (are_int_vectors_equal(dest, anchor)) {
        // anchor point, both entries are supposed to match
        Entry merged_anchor = anchor_entry.merge(other_entry);
        if (merged_anchor == null) {
          conflicting = true;
        } else {
          result.entries.put(dest, merged_anchor);
        }
      } else {
        conflicting = true;
        other_entry.conflicting = true;
        existing_entry.conflicting = true;
      }
    }

    if (conflicting) {
      return null;
    } else {
      return result;
    }
  }

  Diagram remove_blockers() {
    Diagram result = new Diagram(w, h);

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);
      if (entry instanceof Box) {
        result.entries.put(delta, entry.copy());
      }
    }

    return result;
  }

  Diagram shrink() {
    int min_x = w;
    int min_y = h;
    int max_x = 0;
    int max_y = 0;

    for (PVector delta : entries.keySet()) {
      int x = floor(delta.x);
      int y = floor(delta.y);
      min_x = min(min_x, x);
      min_y = min(min_y, y);
      max_x = max(max_x, x);
      max_y = max(max_y, y);
    }

    int w = max_x - min_x + 1;
    int h = max_y - min_y + 1;
    PVector delta_diagram = new PVector(-min_x, -min_y);

    Diagram result = new Diagram(w, h);

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);

      result.entries.put(PVector.add(delta, delta_diagram), entry.copy());
    }

    return result;
  }

  Diagram simplify() {
    return remove_blockers().shrink();
  }

  void draw_anchor(int i, int j) {
    float r = 40;
    stroke(255, 0, 0);
    noFill();
    ellipse(i*TIMESLOT_WIDTH+TIMESLOT_WIDTH/2, j*TIMESLOT_HEIGHT+TIMESLOT_HEIGHT/2, 2*r, 2*r);
  }

  void draw_grid(int w, int h) {
    stroke(128);
    for (int i=0; i<w; ++i) {
      for (int j=0; j<h; ++j) {
        PVector v = new PVector(i, j);
        boolean is_anchor = (anchor != null) && are_int_vectors_equal(v, anchor);
        boolean is_hover = (hover != null) && are_int_vectors_equal(v, hover);
        boolean is_at_conflicting_timeslot = (conflicting_timeslot != null) && are_int_vectors_equal(v, conflicting_timeslot);
        boolean is_outside_non_conflicting_region = (non_conflicting_region != null) && !non_conflicting_region.contains_int_vector(v);
        boolean is_conflicting = is_flashing_red() && (is_at_conflicting_timeslot || is_outside_non_conflicting_region);
        image(is_conflicting ? conflicting_timeslot_image : is_anchor ? anchor_image : is_hover ? hover_image : timeslot_image, i*TIMESLOT_WIDTH, j*TIMESLOT_HEIGHT);
      }
    }
  }

  void draw() {
    draw_grid(w, h);

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);
      if (entry instanceof Box) {
        entry.draw(round(delta.x), round(delta.y));
      }
    }

    for (PVector delta : entries.keySet()) {
      Entry entry = entries.get(delta);
      if (entry instanceof Blocker) {
        entry.draw(round(delta.x), round(delta.y));
      }
    }
  }
}

class Button {
  String name;
  int w;
  int h;
  boolean isEnabled;
  boolean isPressed;
  Button( String name_, int w_, int h_ ) {
    name = name_;
    w = w_;
    h = h_;
    isEnabled = true;
    isPressed = false;
  }
  void draw() {
    if ( isEnabled ) {
      if ( isPressed ) {
        fill(115, 171, 255);
      } else {
        fill(78, 115, 172);
      }
    } else {
      fill(128, 128, 128);
    }    
    stroke(0, 0);
    rect(0, 0, w, h);

    fill( 255 );
    textAlign( CENTER );
    textFont(font24, 24);
    text(name, 0, (h/2)-10, w, (h/2)+10);
  }
  void onMousePressed( int x, int y ) {
    isPressed = isEnabled && (x>=0) && (x<w) && (y>=0) && (y<h);
  }
  void onMouseReleased( int x, int y ) {
    isPressed = false;
  }
}


void draw() {
  // UPDATE
  global_t += 1.0/60; // assumes 60fps

  if (global_mode == DISPLAYING_CONFLICTS_MODE && global_t > 0.5) {
    global_source_diagram.clear_conflict_markers();
    global_target_diagram.clear_conflict_markers();
    global_mode = INTERACTIVE_MODE;
  } else if (global_mode == DOWN_SLIDE_IN_MODE && global_t > 0.25) {
    global_source_diagram = global_next_source_diagram;
    global_target_diagram = global_next_target_diagram;
    global_mode = DOWN_SLIDE_MODE;
    if (global_slide == null) dismiss_slide();
  } else if (global_mode == UP_SLIDE_IN_MODE && global_t > 0.25) {
    global_source_diagram = global_next_source_diagram;
    global_target_diagram = global_next_target_diagram;
    global_mode = UP_SLIDE_MODE;
    if (global_slide == null) dismiss_slide();
  } else if (global_mode == RIGHT_SLIDE_IN_MODE && global_t > 0.25) {
    global_source_diagram = global_next_source_diagram;
    global_target_diagram = global_next_target_diagram;
    global_mode = RIGHT_SLIDE_MODE;
    if (global_slide == null) dismiss_slide();
  } else if (global_mode == LEFT_SLIDE_IN_MODE && global_t > 0.25) {
    global_source_diagram = global_next_source_diagram;
    global_target_diagram = global_next_target_diagram;
    global_mode = LEFT_SLIDE_MODE;
    if (global_slide == null) dismiss_slide();
  } else if (global_mode == DOWN_SLIDE_OUT_MODE && global_t > 0.25) {
    global_mode = INTERACTIVE_MODE;
    global_slide = null;
  } else if (global_mode == UP_SLIDE_OUT_MODE && global_t > 0.25) {
    global_mode = INTERACTIVE_MODE;
    global_slide = null;
  } else if (global_mode == RIGHT_SLIDE_OUT_MODE && global_t > 0.25) {
    if (global_slide != null && global_slide.next_slide != null) {
      global_slide = global_slide.next_slide;
      global_mode = DOWN_SLIDE_MODE;
    } else if (global_source_diagram.anchor == null) {
      // THE END
      global_mode = ADMIRING_RESULTS_MODE;
      global_slide = null;
    } else {
      global_mode = INTERACTIVE_MODE;
      global_slide = null;
    }
  } else if (global_mode == LEFT_SLIDE_OUT_MODE && global_t > 0.25) {
    global_mode = INTERACTIVE_MODE;
    global_slide = null;
  }


  // DRAW

  background(background_image);
  pushMatrix();

  float frac = global_t / 0.25;
  if (global_mode == DOWN_SLIDE_IN_MODE) {
    translate(0, -frac * WINDOW_HEIGHT);
  } else if (global_mode == DOWN_SLIDE_MODE) {
    translate(0, -WINDOW_HEIGHT);
  } else if (global_mode == DOWN_SLIDE_OUT_MODE) {
    translate(0, WINDOW_HEIGHT - frac*WINDOW_HEIGHT);
  } else if (global_mode == UP_SLIDE_IN_MODE) {
    translate(0, frac * WINDOW_HEIGHT);
  } else if (global_mode == UP_SLIDE_MODE) {
    translate(0, WINDOW_HEIGHT);
  } else if (global_mode == UP_SLIDE_OUT_MODE) {
    translate(0, frac*WINDOW_HEIGHT - WINDOW_HEIGHT);
  } else if (global_mode == RIGHT_SLIDE_IN_MODE) {
    translate(-frac*WINDOW_WIDTH, 0);
  } else if (global_mode == RIGHT_SLIDE_MODE) {
    translate(-WINDOW_WIDTH, 0);
  } else if (global_mode == RIGHT_SLIDE_OUT_MODE) {
    translate(WINDOW_WIDTH - frac*WINDOW_WIDTH, 0);
  } else if (global_mode == LEFT_SLIDE_IN_MODE) {
    translate(frac*WINDOW_WIDTH, 0);
  } else if (global_mode == LEFT_SLIDE_MODE) {
    translate(WINDOW_WIDTH, 0);
  } else if (global_mode == LEFT_SLIDE_OUT_MODE) {
    translate(frac*WINDOW_WIDTH - WINDOW_WIDTH, 0);
  }

  if (global_mode == RIGHT_SLIDE_IN_MODE || global_slide == null || global_slide.next_slide == null) {
    translate(SOURCE_CALENDAR_X, SOURCE_CALENDAR_Y); // pushMatrix()
    global_source_diagram.draw();
    translate(-SOURCE_CALENDAR_X, -SOURCE_CALENDAR_Y); // popMatrix()

    translate(TARGET_CALENDAR_X, TARGET_CALENDAR_Y); // pushMatrix()
    global_target_diagram.draw();
    translate(-TARGET_CALENDAR_X, -TARGET_CALENDAR_Y); // popMatrix()

    translate(REFACTOR_BUTTON_X, REFACTOR_BUTTON_Y); // pushMatrix()
    refactor_button.isEnabled = can_refactor();
    refactor_button.draw();
    translate(-REFACTOR_BUTTON_X, -REFACTOR_BUTTON_Y); // popMatrix()

    translate(COMMIT_BUTTON_X, COMMIT_BUTTON_Y); // pushMatrix()
    commit_button.isEnabled = can_commit();
    commit_button.name = is_last_round() ? (is_last_scenario() ? "PLAY AGAIN" : "SHIP IT!") : "COMMIT";
    commit_button.draw();
    translate(-COMMIT_BUTTON_X, -COMMIT_BUTTON_Y); // popMatrix()

    fill(0);
    rect(TARGET_CALENDAR_X-23, TARGET_CALENDAR_Y, 11, TIMESLOT_HEIGHT*7);

    textFont(font24, 24);
    text("Sun", TARGET_CALENDAR_X+0.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Mon", TARGET_CALENDAR_X+1.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Tue", TARGET_CALENDAR_X+2.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Wed", TARGET_CALENDAR_X+3.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Thu", TARGET_CALENDAR_X+4.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Fri", TARGET_CALENDAR_X+5.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);
    text("Sat", TARGET_CALENDAR_X+6.5*TIMESLOT_WIDTH, TARGET_CALENDAR_Y-10);

    fill(39, 58, 87); //fill(78, 115, 172);
    text( "CODE COMPLETE", SOURCE_CALENDAR_X, SOURCE_CALENDAR_Y-70, 
      TIMESLOT_WIDTH*5, (SOURCE_CALENDAR_Y/2)+10);
    text( "WORK IN PROGRESS - PHASE "+current_round, TARGET_CALENDAR_X, TARGET_CALENDAR_Y-70, 
      TIMESLOT_WIDTH*7, (SOURCE_CALENDAR_Y/2)+10);
  }

  if (global_slide != null) {
    pushMatrix();

    if (global_mode == DOWN_SLIDE_IN_MODE || global_mode == DOWN_SLIDE_MODE) {
      translate(0, WINDOW_HEIGHT);
    } else if (global_mode == DOWN_SLIDE_OUT_MODE) {
      translate(0, -WINDOW_HEIGHT);
    } else if (global_mode == UP_SLIDE_IN_MODE || global_mode == UP_SLIDE_MODE) {
      translate(0, -WINDOW_HEIGHT);
    } else if (global_mode == UP_SLIDE_OUT_MODE) {
      translate(0, WINDOW_HEIGHT);
    } else if (global_mode == RIGHT_SLIDE_IN_MODE || global_mode == RIGHT_SLIDE_MODE) {
      translate(WINDOW_WIDTH, 0);
    } else if (global_mode == RIGHT_SLIDE_OUT_MODE) {
      translate(-WINDOW_WIDTH, 0);
    } else if (global_mode == LEFT_SLIDE_IN_MODE || global_mode == LEFT_SLIDE_MODE) {
      translate(-WINDOW_WIDTH, 0);
    } else if (global_mode == LEFT_SLIDE_OUT_MODE) {
      translate(WINDOW_WIDTH, 0);
    }

    global_slide.draw();

    popMatrix();
  }

  popMatrix();


  // DEBUG
}

void mousePressed() {
  commit_button.onMousePressed(mouseX-COMMIT_BUTTON_X, mouseY-COMMIT_BUTTON_Y); 
  refactor_button.onMousePressed(mouseX-REFACTOR_BUTTON_X, mouseY-REFACTOR_BUTTON_Y);
}

void mouseReleased() {
  if ( commit_button.isPressed ) {
    commit();
  } else if ( refactor_button.isPressed ) {
    refactor();
  }
  commit_button.onMouseReleased(mouseX-COMMIT_BUTTON_X, mouseY-COMMIT_BUTTON_Y); 
  refactor_button.onMouseReleased(mouseX-REFACTOR_BUTTON_X, mouseY-REFACTOR_BUTTON_Y);

  if (global_mode == INTERACTIVE_MODE) {
    if (mouseX < TARGET_CALENDAR_X) {
      // click on source diagram?

      if (global_source_diagram.hover != null) {
        global_source_diagram.anchor = global_source_diagram.hover;
      }
    } else {
      // click on target diagram?

      if (global_target_diagram.hover != null) {
        boolean conflicting = false;

        Entry target_anchor_entry = global_target_diagram.entries.get(global_target_diagram.hover);
        if (target_anchor_entry == null) {
          conflicting = true;
          global_target_diagram.conflicting_timeslot = global_target_diagram.hover;
        } else if (!(target_anchor_entry instanceof Box)) {
          conflicting = true;
          target_anchor_entry.conflicting = true;
        }

        PVector anchor_delta = PVector.sub(global_source_diagram.anchor, global_target_diagram.hover);
        Region non_conflicting_region = new Region(anchor_delta, PVector.add(anchor_delta, new PVector(global_target_diagram.w-1, global_target_diagram.h-1)));
        if (!non_conflicting_region.contains_smaller_region(global_source_diagram.region)) {
          conflicting = true;
          global_source_diagram.non_conflicting_region = non_conflicting_region;
        }

        if (conflicting) {
          display_conflicts();
        } else {
          Diagram result = global_target_diagram.merge(global_target_diagram.hover, global_source_diagram, global_source_diagram.anchor);
          if (result == null) {
            display_conflicts();
          } else {
            global_completed_diagram = global_source_diagram;
            global_source_diagram = new Diagram(global_source_diagram.w, global_source_diagram.h);

            PVector anchor = global_target_diagram.hover;
            global_target_diagram = result;
            global_target_diagram.anchor = anchor;

            global_mode = ADMIRING_RESULTS_MODE;
          }
        }
      }
    }
  } else if (global_mode == DOWN_SLIDE_MODE || global_mode == UP_SLIDE_MODE || global_mode == RIGHT_SLIDE_MODE || global_mode == LEFT_SLIDE_MODE) {
    dismiss_slide();
  }
}

void mouseMoved() {
  if (mouseX < TARGET_CALENDAR_X) {
    // hover over source diagram?

    float x = mouseX - SOURCE_CALENDAR_X;
    float y = mouseY - SOURCE_CALENDAR_Y;
    int i = floor(x / TIMESLOT_WIDTH);
    int j = floor(y / TIMESLOT_HEIGHT);
    if (i >= 0 && i < global_source_diagram.w && j >= 0 && j < global_source_diagram.h) {
      global_source_diagram.hover = new PVector(i, j);
    } else {
      global_source_diagram.hover = null;
    }
    global_target_diagram.hover = null;
  } else {
    // hover over target diagram?

    float x = mouseX - TARGET_CALENDAR_X;
    float y = mouseY - TARGET_CALENDAR_Y;
    int i = floor(x / TIMESLOT_WIDTH);
    int j = floor(y / TIMESLOT_HEIGHT);
    if (i >= 0 && i < global_target_diagram.w && j >= 0 && j < global_target_diagram.h) {
      global_target_diagram.hover = new PVector(i, j);
    } else {
      global_target_diagram.hover = null;
    }
    global_source_diagram.hover = null;
  }
}

void keyPressed() {
  if (global_mode == DOWN_SLIDE_MODE || global_mode == UP_SLIDE_MODE || global_mode == RIGHT_SLIDE_MODE || global_mode == LEFT_SLIDE_MODE) {
    dismiss_slide();
  } else {
    if (keyCode == LEFT || keyCode == UP || keyCode == BACKSPACE) {
      refactor();
    } else if (keyCode == RIGHT || keyCode == DOWN || keyCode == ENTER || key == ' ') {
      commit();
    }
  }

  if (key == 'm') {
    muted = !muted;

    if (playing_ambient) {
      if (muted) {
        ambient_sound.stop();
      } else {
        ambient_sound.loop();
      }
    }
  }
}