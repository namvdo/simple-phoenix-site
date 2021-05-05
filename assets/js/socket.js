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
    document.querySelector(".collection").innerHTML += renderComment(event.comment);
  });

}

const renderComment = (comment) => {
  return renderCommentView(comment)
}

const renderComments = (comments) => {
  return comments.map(comment => renderCommentView(comment)); 
}
const renderCommentView = (comment) => {
  let email = "Anonymous";
  if (comment.user && comment.user.email)  {
    email = comment.user.email;
  }
  return `<li>${comment.content} - ${email}`;
}
window.createSocket = joinChannel;
