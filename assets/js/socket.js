import { Socket } from "phoenix"
let socket = new Socket("/socket", { params: { token: window.userToken } })
socket.connect();
const joinChannel = (topicId) => {
  const chan = `comments:${topicId}`;
  const channel = socket.channel(chan)
  const commentEvent = "comments:add";
  channel.join()
    .receive("ok", resp => renderedComments(resp.comments))
    .receive("error", resp => { console.log("Unable to join", resp) })
  document.querySelector("#comment").addEventListener("click", function () {
    const content = document.querySelector("textarea").value;
    channel.push(commentEvent, { content: content });
  });
  channel.on(`comments:${topicId}:new`, (event) => {
    console.log("comment: " + JSON.stringify(event.comment));
    document.querySelector(".collection").innerHTML += `<li>${event.comment.content}</li>`;
  });

}

function renderedComments(comments) {
  const renderComments = comments.map((comment) => {
    document.querySelector(".collection").innerHTML += `<li>${comment.content}</li>`;
  });
};

window.createSocket = joinChannel;
