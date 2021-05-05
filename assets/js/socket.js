import { Socket } from "phoenix"
let socket = new Socket("/socket", { params: { token: window.userToken } })
socket.connect();
const joinChannel = (topicId) => {
  const chan = `comments:${topicId}`;
  const channel = socket.channel(chan)
  const commentEvent = "comments:add";
  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments)
    })
    .receive("error", resp => { console.log("Unable to join", resp) })
  document.querySelector("#comment").addEventListener("click", function () {
    const content = document.querySelector("textarea").value;
    channel.push(commentEvent, { content: content });
  });
  channel.on(`comments:${topicId}:new`, (event) => {
    console.log("comment: " + JSON.stringify(event.comment));
    document.querySelector(".collection").innerHTML += renderComments(event.comment);
  });

}

const renderComments = (comments) => {
  let html;
  let email = "Anonymous";
  if (comments instanceof Array) {
    comments.map((comment) => {
      if (comment.user && comment.user.email) {
        email = comment.user.email;
      }
      return `<li>${comment.content} - ${email}</li>`;
    });
  } else {
    if (comments.user && comments.user.email) {
      email = comments.user.email;
    }
    return `<li>${comments.content} - ${email}</li>`
  }
}
window.createSocket = joinChannel;
