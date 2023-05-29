import * as React from "react";
import { Socket } from "phoenix";
import { useEffect, useRef, useState } from "react";

interface Props {
  socket: Socket;
}
const App: React.FC<Props> = (props: Props) => {
  const [isConnected, setIsConnected] = useState(false);

  useEffect(() => {
    console.log("state changed!", props.socket.connectionState());
    if (props.socket.connectionState() === "open") {
      setIsConnected(true);
    } else {
      setIsConnected(false);
    }
  }, [props.socket.isConnected()]);

  return (
    <p>
      The React App is cool! Socket connected? {JSON.stringify(isConnected)} ...
      even though it is! useEffect is not being triggered when socket state
      changes.
    </p>
  );
};

export default App;
