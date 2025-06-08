import { render } from "preact";
import { useZebar, ZebarProvider } from "./context/OutputContext";
import { GlazeWMWorkspaces } from "./components/GlazeWMWorkspaces";
import { GlazeWMStatus } from "./components/GlazeWMStatus";
import { Network } from "./components/Network";
import { Memory } from "./components/Memory";
import { Cpu } from "./components/Cpu";
import { Battery } from "./components/Battery";
import { Weather } from "./components/Weather";

render(
  <ZebarProvider>
    <App />
  </ZebarProvider>,
  document.getElementById("app")!,
);

function App() {
  const output = useZebar();

  return (
    <div class="app">
      <div class="left">
        <GlazeWMWorkspaces />
      </div>

      <div class="center clock">{output.date?.formatted}</div>

      <div class="right">
        <GlazeWMStatus />
        <Network />
        <Memory />
        <Cpu />
        <Battery />
        <Weather />
      </div>
    </div>
  );
}
