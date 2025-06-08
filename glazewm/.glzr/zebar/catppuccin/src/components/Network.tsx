import type { NetworkOutput } from "zebar";
import { useZebar } from "../context/OutputContext";

export function Network() {
  const output = useZebar();

  function getNetworkIcon(networkOutput: NetworkOutput) {
    const signalStrength = networkOutput.defaultGateway?.signalStrength ?? 0;
    switch (networkOutput.defaultInterface?.type) {
      case "ethernet":
        return <i class="nf nf-md-ethernet_cable"></i>;
      case "wifi":
        if (signalStrength >= 80) {
          return <i class="nf nf-md-wifi_strength_4"></i>;
        } else if (signalStrength >= 65) {
          return <i class="nf nf-md-wifi_strength_3"></i>;
        } else if (signalStrength >= 40) {
          return <i class="nf nf-md-wifi_strength_2"></i>;
        } else if (signalStrength >= 25) {
          return <i class="nf nf-md-wifi_strength_1"></i>;
        } else {
          return <i class="nf nf-md-wifi_strength_outline"></i>;
        }
      default:
        return <i class="nf nf-md-wifi_strength_off_outline"></i>;
    }
  }

  return (
    output.network && (
      <div class="network">
        {getNetworkIcon(output.network)}
        {output.network.defaultGateway?.ssid}
      </div>
    )
  );
}
