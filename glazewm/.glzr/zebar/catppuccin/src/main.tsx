import { render } from "preact";
import { useZebar, ZebarProvider } from "./context/OutputContext";
import { GlazeWMWorkspaces } from "./components/GlazeWMWorkspaces";
import { GlazeWMStatus } from "./components/GlazeWMStatus";
import { Network } from "./components/Network";
import { Memory } from "./components/Memory";
import { Cpu } from "./components/Cpu";
import { Battery } from "./components/Battery";
import { Weather } from "./components/Weather";
import { ActiveApp } from "./components/ActiveApp";

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
        <i class="logo nf nf-dev-windows11"></i>
        <GlazeWMWorkspaces />
      </div>

      <div class="center">
        <div class="clock">
          <i class="nf nf-md-calendar_month" />
          <span>{output.date?.formatted}</span>
        </div>
        {output.glazewm ? <ActiveApp output={output} /> : null}
      </div>

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
