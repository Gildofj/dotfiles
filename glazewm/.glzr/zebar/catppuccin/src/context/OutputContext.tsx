import { createContext } from "preact";
import type { ReactNode } from "preact/compat";
import { useContext, useEffect, useState } from "preact/hooks";
import {
  createProviderGroup,
  type BatteryOutput,
  type CpuOutput,
  type DateOutput,
  type GlazeWmOutput,
  type MemoryOutput,
  type NetworkOutput,
  type WeatherOutput,
} from "zebar";

export type ZebarContextOutput = {
  network: NetworkOutput | null;
  glazewm: GlazeWmOutput | null;
  cpu: CpuOutput | null;
  date: DateOutput | null;
  battery: BatteryOutput | null;
  memory: MemoryOutput | null;
  weather: WeatherOutput | null;
};

const providers = createProviderGroup({
  network: { type: "network" },
  glazewm: { type: "glazewm" },
  cpu: { type: "cpu" },
  date: { type: "date", formatting: "EEE d MMM t" },
  battery: { type: "battery" },
  memory: { type: "memory" },
  weather: { type: "weather" },
});

const ZebarContext = createContext<ZebarContextOutput | null>(null);

export const ZebarProvider = ({ children }: { children: ReactNode }) => {
  const [output, setOutput] = useState(providers.outputMap);

  useEffect(() => {
    providers.onOutput(() => setOutput(providers.outputMap));
  }, []);

  return (
    <ZebarContext.Provider value={output}>{children}</ZebarContext.Provider>
  );
};

export const useZebar = () => {
  const context = useContext(ZebarContext);
  if (!context) {
    throw new Error("useZebar mus be used whitin an ZebarProvider");
  }
  return context;
};
