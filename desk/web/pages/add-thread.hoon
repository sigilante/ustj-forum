/-  sur=forum, tp=post
/+  sr=sortug
/=  comps  /web/components/components
/=  pt  /web/components/post-text
|_  =bowl:gall
++  $
  ;main#thread-main
    ;h1.tc:"New Thread"
    ;p:"You may either submit a link or write a text post."
    ;div#thread-composer
      ;div#composer-proper
      ;form#form(action "new-thread", method "POST")
        ;input#thread-title(type "text", name "title", placeholder "title");
        ;input#thread-url(type "text", name "url", placeholder "https://urbit.org/");
        ;textarea#textarea(name "text");
        ;button:"Submit"
        ;script:"{script}"
      ==
      ==
    ==
  ==
++  script  ^~  %-  trip
'''
  function listeners(){
    const form = document.getElementById("form");
    const draftID = "new-thread";
    const linkDiv = document.getElementById("thread-url");
    const area = document.getElementById("textarea");

    // autosave
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
    // toggler
    linkDiv.addEventListener("input", () => {
      if (linkDiv.value)  textarea.disabled = true;
      else textarea.disabled = false;
    });
  }
  listeners();
'''
--
