import * as React from "react";
import App from "./App";
import { Socket } from "phoenix";
import { createRoot } from "react-dom/client";

export default function mountApp(id: string, socket: Socket) {
  const rootElement = document.getElementById(id);
  createRoot(rootElement).render(<App socket={socket} />);
}
