type DisplayState = "shown" | "showing" | "hidden" | "hiding";

interface LengthUnit {
  amount: number;
  unit: "pixel" | "percentage";
}

interface RectDelta {
  left: LengthUnit;
  top: LengthUnit;
  right: LengthUnit;
  bottom: LengthUnit;
}

interface Rect {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

type TilingDirection = "vertical" | "horizontal";

export type WindowState =
  | {
      type: "floating";
      centered: boolean;
      shownOnTop: boolean;
    }
  | {
      type: "fullscreen";
      maximized: boolean;
      shownOnTop: boolean;
    }
  | {
      type: "minimized";
    }
  | {
      type: "tiling";
    };

export interface Window {
  id: string;
  type: "window";
  parentId: string;
  hasFocus: boolean;
  floatingPlacement: Rect;
  borderDelta: RectDelta;
  handle: number;
  tilingSize: number | null;
  state: WindowState;
  prevState: WindowState | null;
  displayState: DisplayState;
  title: string;
  processName: string;
  className: string;
  width: number;
  height: number;
  x: number;
  y: number;
}

export interface SplitContainer {
  id: string;
  type: "split";
  parentId: string;
  childFocusOrder: string[];
  children: (SplitContainer | Window)[];
  hasFocus: boolean;
  tilingDirection: TilingDirection;
  tilingSize: number;
  width: number;
  height: number;
  x: number;
  y: number;
}
