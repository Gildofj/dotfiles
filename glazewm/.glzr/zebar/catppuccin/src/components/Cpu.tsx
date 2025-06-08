import { useZebar } from "../context/OutputContext";

export function Cpu() {
  const output = useZebar();

  return (
    output.cpu && (
      <div class="cpu">
        <i class="nf nf-oct-cpu"></i>

        {/* Change the text color if the CPU usage is high. */}
        <span class={output.cpu.usage > 85 ? "high-usage" : ""}>
          {Math.round(output.cpu.usage)}%
        </span>
      </div>
    )
  );
}
