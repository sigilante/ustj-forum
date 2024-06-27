/-  sur=forum, tp=post
/+  lib=forum, sr=sortug
/=  comps  /web/components/components
/=  pt  /web/components/post-text
|_  [ted=thread:sur comment-list=(list full-node:tp) =bowl:gall]
++  body
  ?:  ?=(%link -.content.ted)  
      ;+  link-body  
      (content:pt +.content.ted)
++  link-body
    ?>  ?=(%link -.content.ted)
    =/  url  (trip +.content.ted)
    ;a/"{url}"
    ;div#og
    =url  url
      ;img#link-image;
      ;div#link-url:"{url}"
    ;script:"{og-script}"
    ==
    ==
++  comments
  ;div#comments
  ;ul.comment-thread
    ;*  %+  turn  comment-list  mini-thread
  ==
  ==

++  mini-thread 
=|  nested=@ud
|=  fn=full-node:tp  ^-  manx
  ;li.comment
    ;+  (comment p.fn)
    ;+  (grandchildren fn +(nested))
  ==
++  grandchildren  |=  [fn=full-node:tp nested=@ud]
  =/  pid  [author.p.fn id.p.fn]
  ?~  children.fn  ;span;
  ?:  (gth nested 5)  (show-more pid)
  =/  children  (tap:form:tp children.fn)
  =/  mtf  mini-thread
  ;ul.comment-thread.nested
    ;*  %+  turn  children  |=  [p=pid:tp fnc=full-node:tp]
      (mtf(nested nested) fnc)
  ==

++  show-more  |=  =pid:tp
  =/  pids  (scow:sr %uw (jam pid))
  ;div.show-more-button.uln
    =pid  pids
    ; Show more
  ==
++  comment  |=  c=comment:tp
  =/  pid  [author.c id.c]
  =/  pids  (scow:sr %uw (jam pid))
  ;div.comment-proper
    ;+  (post-metadata:comps pid now.bowl votes.c ~(wyt in children.c) .n)
    ;div.content
      ;*  (content:pt contents.c)
    ==
    ;a.uln/"/forum/rep/{pids}":"reply"
  ==
++  $
  =/  op  (scow %p ship.pid.ted)
  =/  op-ago  (post-date-ago:lib id.pid.ted now.bowl %yau)
  =/  pids  (scow:sr %uw (jam pid.ted))

  ;main#thread-main
    ;a.return-link/"/forum":"Return to forum"
    ;+  (post-metadata:comps pid.ted now.bowl votes.ted (lent replies.ted) .y)
    ;h1#thread-title:"{(trip title.ted)}"
    ;div#thread-body
      ;*  body
    ==
    ;div#comment-composer
      ;div#comment-prompt.cp:"add a comment"
      ;div#composer-proper(hidden "")
        ;+  (reply-composer:comps pids .y)
      ==
    ==
    ;+  comments
    ;script:"{reply-script}"
  ==
++  reply-script  ^~  %-  trip  
'''
  function replyToggle(){
    const el = document.getElementById("comment-prompt");
    if (!el) return
    const form = document.getElementById("composer-proper");
    if (!form) return
    el.addEventListener("click", (e) => {
      form.hidden = !form.hidden;
    });
  }
  replyToggle();
  async function voting(){
    const upbs = document.querySelectorAll(".upvote-button");
    const downbs = document.querySelectorAll(".downvote-button");
    for (let upb of upbs){
      const parent = upb.closest(".meta");
      if (!parent) continue;
      const pid = parent.getAttribute("pid");
      const teds = parent.getAttribute("ted");
      const postType = (teds && teds === "yeah") ? "ted" : "com"
      if (!pid) continue;
      upb.addEventListener("click", async () => {
        const res = await fetch(`/forum/vote/${postType}/${pid}/gud`, {method: "POST"});
        console.log(res, "res");
        const t = await res.text();
        console.log(t, "t")
      })
    }
    for (let db of downbs){
      const parent = db.closest(".meta");
      if (!parent) continue;
      const pid = parent.getAttribute("pid");
      if (!pid) continue;
      const teds = parent.getAttribute("ted");
      const postType = (teds && teds === "yeah") ? "ted" : "com"
      db.addEventListener("click", async () => {
        const res = await fetch(`/forum/vote/${postType}/${pid}/bad`, {method: "POST"});
        console.log(res, "res");
        const t = await res.text();
        console.log(t, "t")
      })
    }
  }
  voting();

  
'''
++  og-script  ^~  %-  trip  
'''
  async function run(){
    const urlEl = document.getElementById("og");
    const url = urlEl.getAttribute("url");
    if (!url) return
    try{
      const res = await fetch(url);
      const text = await res.text();
      getMeta(url, text);
    } catch(e){
      callThread(url);
    }
  }
  async function callThread(url){
    console.log(url, "calling thread")
    try{
      const opts = {
        credentials: 'include',
        accept: '*',
        method: "POST",
        body: JSON.stringify(url),
        headers: {
          'Content-type': "application/json"
        }
      };
      const res = await fetch("/kumo/ustj/json/proxy/json", opts);
      const text = await res.json();
      getMeta(url, text);
    } catch(e){
      console.log(e, "wtf")
    }
    
  }
  function getMeta(url, s){
    const parser = new DOMParser();
    const doc = parser.parseFromString(s, "text/html");
    console.log(doc, "document")
    const metaTags = doc.querySelectorAll("meta");
    for (let tag of metaTags){
      const name = tag.getAttribute("name");
      const prop = tag.getAttribute("property");
      const cont = tag.getAttribute("content");
      const isImage = (name && name.includes("image") || (prop && prop.includes("image")))
    
      if (isImage){
        setImage(url, cont);
        break;
      }
    }
  }
  function setImage(base, path){
    console.log([base, path], "bp")
    const url = path.includes("http") ? path : (base + path);
    console.log("setting image", url);
    const el = document.getElementById("link-image");
    console.log(el, "el");
    el.src = url;
  }
  run();
  
'''
--
