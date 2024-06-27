/+  sig=sigil-sigil
|_  =bowl:gall
++  login  ^-  manx
  ?-  (clan:title src.bowl)
  %czar  sigil
  %king  sigil
  %duke  sigil
  %earl  sigil
  %pawn  login-prompt
  ==
++  login-prompt  ^-  manx
  ;a/"/forum/log":"Log In"
++  sigil
:: ;+  (sig(size 48) src.bowl)
=/  p  (scow %p src.bowl)
  ;div.f.g2
    ;a/"/forum/add":"new post"
    ;a/"/forum/usr/{p}":"{p}"
  ==
++  $
  ;nav#topnav.fs.g2
    ;div.f.g2
      ;div#nav-main.fs
        ;a/"/":"~  Technical Journal"
        ;div#nav-dropdown:"↓"
      ==
      ;div#nav-links
        ;a/"/information":"Information"
        ;a.active/"/forum":"Forum"
      ==
    ==
    ;div#login-div
      ;+  login-prompt
    ==
    ;script:"{script}"
  ==
++  script  ^~  %-  trip
'''
  async function setSigil(){
    const div = document.getElementById("login-div");
    const res = await fetch("/forum/f/sigil");
    const t = await res.text();
    if (t) div.innerHTML = t;
  }  
  setSigil();
'''
--
