import type {
  SplitContainer,
  Window as GlazeWMWindow,
} from "../@types/glazewm.type";

export function isWindow(obj: any): obj is GlazeWMWindow {
  return (
    obj &&
    obj.type === "window" &&
    typeof obj.id === "string" &&
    typeof obj.parentId === "string" &&
    typeof obj.hasFocus === "boolean" &&
    typeof obj.floatingPlacement === "object" &&
    typeof obj.borderDelta === "object" &&
    typeof obj.handle === "number" &&
    (typeof obj.tilingSize === "number" || obj.tilingSize === null) &&
    typeof obj.state === "string" && // assuming enums are strings or numbers
    (typeof obj.prevState === "string" || obj.prevState === null) &&
    typeof obj.displayState === "string" && // same assumption
    typeof obj.title === "string" &&
    typeof obj.processName === "string" &&
    typeof obj.className === "string" &&
    typeof obj.width === "number" &&
    typeof obj.height === "number" &&
    typeof obj.x === "number" &&
    typeof obj.y === "number"
  );
}

export function isSplitContainer(obj: any): obj is SplitContainer {
  return (
    obj &&
    obj.type === "split" &&
    typeof obj.id === "string" &&
    typeof obj.parentId === "string" &&
    Array.isArray(obj.childFocusOrder) &&
    Array.isArray(obj.children) &&
    typeof obj.hasFocus === "boolean" &&
    typeof obj.tilingDirection === "string" && // assuming enum is string
    typeof obj.tilingSize === "number" &&
    typeof obj.width === "number" &&
    typeof obj.height === "number" &&
    typeof obj.x === "number" &&
    typeof obj.y === "number"
  );
}
