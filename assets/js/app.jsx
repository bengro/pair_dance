// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Sortable from "sortablejs";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};
Hooks.Reassign = {
  mounted() {
    const oldTaskId = this.el.dataset.taskId;
    new Sortable(this.el, {
      group: "tasks",
      animation: 150,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      forceFallback: true,
      onEnd: (e) => {
        const params = {
          userId: e.item.dataset.userId,
          oldTaskId,
          newTaskId: e.to.dataset.taskId,
        };
        this.pushEventTo("#pairing-table", "reassign", params);
      },
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) =>
  topbar.delayedShow(200)
);
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
liveSocket.enableDebug();
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
