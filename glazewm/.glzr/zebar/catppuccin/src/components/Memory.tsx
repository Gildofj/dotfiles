import { useZebar } from "../context/OutputContext";

export function Memory() {
  const output = useZebar();

  return (
    output.memory && (
      <div class="memory">
        <i class="nf nf-fae-chip"></i>
        {Math.round(output.memory.usage)}%
      </div>
    )
  );
}
