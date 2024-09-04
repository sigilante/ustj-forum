/-  sur=forum, tp=post
/+  lib=forum, sr=sortug
/=  comps  /web/components/components
/=  pt     /web/components/post-text
|_  [ted=thread:sur op=full-node:tp =bowl:gall]
++  comments
  ;div#comments
    ;+  (grandchildren op 0)
  ==
++  mini-thread
  =|  nested=@ud
  |=  fn=full-node:tp
  ^-  manx
  ;li.comment
    ;+  (comment p.fn)
    ;+  (grandchildren fn +(nested))
  ==
++  grandchildren
  |=  [fn=full-node:tp nested=@ud]
  =/  pid  [author.p.fn id.p.fn]
  ?~  children.fn  ;span;
  ?:  (gth nested 5)  (show-more pid)
  =/  children  (tap:form:tp children.fn)
  =/  mtf  mini-thread
  ;ul.comment-thread.nested
    ;*  %+  turn  children  |=  [p=pid:tp fnc=full-node:tp]
      (mtf(nested nested) fnc)
  ==
++  show-more
  |=  =pid:tp
  =/  pids  (scow:sr %uw (jam pid))
  ;div.show-more-button.uln
    =pid  pids
    ; Show more
  ==
++  comment
  |=  c=comment:tp
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
  =/  ppid  [author.p.op id.p.op]
  =/  pids  (scow:sr %uw (jam ppid))
  ;main#thread-main
    ;+  (reply-header:comps ted p.op now.bowl)
    ;div#thread-body
      ;*  (content:pt contents.p.op)
    ==
    ;+  (comment-composer:comps src.bowl pids)
    ;+  comments
    ;script:"{reply-script}"
  ==
++  reply-script
  ^~
  %-  trip
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
'''
++  og-script
  ^~
  %-  trip
'''
  async function run(){
    const urlEl = document.getElementById("og");
    const url = urlEl.getAttribute("url");
    if (!url) return
    const res = await fetch(url);
    const text = await res.text();
    getMeta(url, text);
  }
  function getMeta(url, s){
    const parser = new DOMParser();
    const doc = parser.parseFromString(s, "text/html");
    const metaTags = doc.querySelectorAll("meta");

    for (let tag of metaTags){
      const name = tag.getAttribute("name");
      const prop = tag.getAttribute("property");
      const cont = tag.getAttribute("content");
 
      if (name && name.includes("image")){
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
