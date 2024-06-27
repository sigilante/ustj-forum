/-  sur=forum, tp=post
/+  sr=sortug
/=  comps  /web/components/components
/=  pt  /web/components/post-text
|_  [ted=thread:sur com=comment:tp =bowl:gall]
++  $
  =/  ppid  [author.com id.com]
  =/  pids  (scow:sr %uw (jam ppid))
  ;main#thread-main
    ;div#parent
      ;+  (reply-header:comps ted com now.bowl)
      ;div.post-text
        ;*  (content:pt contents.com)
      ==
    ;div#composer
      ;div#composer-proper
        ;+  (reply-composer:comps pids .n)
      ==
    ==
    ==
  ==
--
