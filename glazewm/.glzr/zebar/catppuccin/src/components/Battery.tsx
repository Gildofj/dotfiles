import type { BatteryOutput } from "zebar";
import { useZebar } from "../context/OutputContext";

export function Battery() {
  const output = useZebar();

  function getBatteryIcon(batteryOutput: BatteryOutput) {
    if (batteryOutput.chargePercent > 90)
      return <i class="nf nf-fa-battery_4"></i>;
    if (batteryOutput.chargePercent > 70)
      return <i class="nf nf-fa-battery_3"></i>;
    if (batteryOutput.chargePercent > 40)
      return <i class="nf nf-fa-battery_2"></i>;
    if (batteryOutput.chargePercent > 20)
      return <i class="nf nf-fa-battery_1"></i>;
    return <i class="nf nf-fa-battery_0"></i>;
  }

  return (
    output.battery && (
      <div class="battery">
        {/* Show icon for whether battery is charging. */}
        {output.battery.isCharging && (
          <i class="nf nf-md-power_plug charging-icon"></i>
        )}
        {getBatteryIcon(output.battery)}
        {Math.round(output.battery.chargePercent)}%
      </div>
    )
  );
}
