/-  sur=forum, tp=post
/+  lib=forum, sr=sortug
|%
++  votes  |=  v=votes:tp
  =/  old  (old:si tally.v)
  =/  arrow  ?:  -.old
    "↑"
    "↓"
  :: =/  img  ?:  -.old
  ::   ;img@"/up.svg";
  ::   ;img@"/down.svg"(cnn.org) ;
  ;div.f.g1
    ;div.arrow:"{arrow}"
    ;div:"{(scow %ud +.old)}"
  ==
++  tally  |=  v=votes:tp
  =/  old  (old:si tally.v)
    =/  classn  ?:  -.old  "tally green"  "tally red"
    ;div(class classn):"{(scow %ud +.old)}"

++  upvote  ^-  manx
  ;div.upvote-button.cp:"↑"
++  downvote
  ;div.downvote-button.cp:"↓"
++  thread-metadata
  |=  [=pid:tp now=@da v=votes:tp reply-count=@ud] 
    =/  post-link  (scow:sr %uw (jam pid))
    =/  ago  (post-date-ago:lib id.pid now %yau)
    =/  author  (scow %p ship.pid)
    =/  comments  ?:  .=(0 reply-count)  ~  
      ;+  ;div:"{(scow %ud reply-count)} comments"
    ;div.meta.f.g2
      =pid  post-link
      ;+  (votes v)
      ;div:"{author}"
      ;a/"/forum/com/{post-link}":"{ago} ago"
      ;*  comments
    ==
++  post-metadata
|=  [=pid:tp now=@da v=votes:tp reply-count=@ud is-ted=?] 
  =/  teds  ?:  is-ted  "yeah"  "nope"
  =/  post-link  (scow:sr %uw (jam pid))
  =/  ago  (post-date-ago:lib id.pid now %yau)
  =/  author  (scow %p ship.pid)
  =/  comments  ?:  .=(0 reply-count)  ~  
    ;+  ;div:"{(scow %ud reply-count)} comments"
  ;div.meta.f.g2
    =pid  post-link
    =ted  teds  
    ;+  upvote
    ;+  (tally v)
    ;+  downvote
    ;div:"{author}"
    ;a/"/forum/com/{post-link}":"{ago} ago"
    ;*  comments
  ==
++  reply-header
|=  [t=thread:sur =comment:tp now=@da] 
  =/  cpid  [author.comment id.comment]
  =/  ago  (post-date-ago:lib id.comment now %yau)
  =/  author  (scow %p author.comment)
  =/  thread-link  (scow:sr %uw (jam pid.t))
  =/  parent-link  (scow:sr %uw (jam parent.comment))
  =/  titlet  (trip title.t)
  ;div.meta.f.g2
    ;+  (votes votes.comment)
    ;div:"{author}"
    ;div:"{ago} ago"
    ; |
    ;a/"/forum/com/{parent-link}":"parent"
    ; |
    ;a/"/forum/ted/{thread-link}":"Thread: {titlet}"
  ==
++  reply-composer  |=  [pids=tape top=?]
  =/  action  ?:  top  "/forum/comment"  "/forum/reply"
      ;form#reply-form(action action, method "POST")
        ;input#thread-id(type "hidden", name "parent", value pids);
        ;textarea#textarea(name "text");
        ;button:"Submit"
        ;script:"{script}"
      ==
++  script  ^~  %-  trip
'''
  function autoSave(){
    const form = document.getElementById("reply-form");
    const hiddenInput = document.getElementById("thread-id");
    const draftID = hiddenInput.value;
    console.log(draftID, "id")
    const area = document.getElementById("textarea");

    window.addEventListener("load", () => {
      const savedContent = localStorage.getItem(draftID);
      console.log(savedContent, "saved")
      if (savedContent) area.value = savedContent;
    })
    form.addEventListener("submit", () => {
      localStorage.removeItem(draftID);
    })
    area.addEventListener("input", () => {
      console.log("saving", area.value)
      localStorage.setItem(draftID, area.value);
    })
  }
  autoSave();
'''
--
