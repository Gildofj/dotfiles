import { useZebar } from "../context/OutputContext";

export function GlazeWMWorkspaces() {
  const output = useZebar();

  return (
    <>
      <i class="logo nf nf-fa-windows"></i>
      {output.glazewm && (
        <div class="workspaces">
          {output.glazewm.currentWorkspaces.map((workspace) => (
            <button
              class={`workspace ${workspace.hasFocus && "focused"} ${workspace.isDisplayed && "displayed"}`}
              onClick={() =>
                output.glazewm?.runCommand(
                  `focus --workspace ${workspace.name}`,
                )
              }
              key={workspace.name}
            >
              {workspace.displayName ?? workspace.name}
            </button>
          ))}
        </div>
      )}
    </>
  );
}
