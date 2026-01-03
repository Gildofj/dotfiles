import { useZebar } from "../context/OutputContext";

export function GlazeWMStatus() {
  const output = useZebar();

  return (
    output.glazewm && (
      <>
        {output.glazewm.isPaused && (
          <button
            class="paused-button"
            onClick={() => output.glazewm?.runCommand("wm-toggle-pause")}
          >
            PAUSED
          </button>
        )}
        {output.glazewm.bindingModes.map((bindingMode) => (
          <button
            class="binding-mode"
            key={bindingMode.name}
            onClick={() =>
              output.glazewm?.runCommand(
                `wm-disable-binding-mode --name ${bindingMode.name}`,
              )
            }
          >
            {bindingMode.displayName ?? bindingMode.name}
          </button>
        ))}

        <button
          class={`tiling-direction nf ${output.glazewm.tilingDirection === "horizontal" ? "nf-md-swap_horizontal" : "nf-md-swap_vertical"}`}
          onClick={() => output.glazewm?.runCommand("toggle-tiling-direction")}
        ></button>
      </>
    )
  );
}
