import { Socket } from "phoenix"
let socket = new Socket("/socket", { params: { token: window.userToken } })
socket.connect();
const joinChannel = (topicId) => {
  const chan = `comments:${topicId}`;
  const channel = socket.channel(chan)
  const commentEvent = "comments:add";
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
  document.querySelector("#comment").addEventListener("click", function () {
    const content = document.querySelector("textarea").value;
    channel.push(commentEvent, { content: content });
  });
  channel.on(commentEvent, payload => {
    console.log(payload)
    const parent = document.getElementById("input-field");
    const msgItem = document.createElement("p");
    msgItem.innerText = `${payload.body}</br>${Date()}`
    parent.appendChild(div);

  });
}


window.createSocket = joinChannel;
