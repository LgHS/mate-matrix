class MateMatrix {

  private OPC opc;
  private float spacing;
  private float offset;
  private PApplet applet;

  public MateMatrix(PApplet applet, OPC opc) {
    this.opc = opc;    
    this.applet = applet;

    spacing = width / 24;
    offset = int (spacing*2);
  }

  public void init() {
    float H = applet.height / 2 + spacing * 2.5;
    float H2 = applet.height / 2 - spacing * 2.5;

    // ROW 0 (3 crates)
    opc.ledGrid(104, 4, 5, offset, H, spacing, spacing, -PI, true, false);
    opc.ledGrid(84, 4, 5, offset + spacing * 4, H, spacing, spacing, -PI, true, false);
    opc.ledGrid(64, 4, 5, offset + spacing * 4 * 2, H, spacing, spacing, -PI, true, false);
    // ROW 0 (3 crates)
    opc.ledGrid(40, 4, 5, offset + spacing * 4 * 3, H, spacing, spacing, -PI, true, false);
    opc.ledGrid(20, 4, 5, offset + spacing * 4 * 4, H, spacing, spacing, -PI, true, false);
    opc.ledGrid(0, 4, 5, offset + spacing * 4 * 5, H, spacing, spacing, -PI, true, false);

    // ROW 1
    opc.ledGrid(128, 4, 5, offset + spacing * 4 * 5, H2, spacing, spacing, -PI, true, false);
    opc.ledGrid(148, 4, 5, offset + spacing * 4 * 4, H2, spacing, spacing, -PI, true, false);
    opc.ledGrid(168, 4, 5, offset + spacing * 4 * 3, H2, spacing, spacing, -PI, true, false);

    opc.ledGrid(192, 4, 5, offset + spacing * 4 * 2, H2, spacing, spacing, -PI, true, false);
    opc.ledGrid(212, 4, 5, offset + spacing * 4, H2, spacing, spacing, -PI, true, false);
    opc.ledGrid(232, 4, 5, offset, H2, spacing, spacing, -PI, true, false);
  }
}
