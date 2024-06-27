=<  html
|%
++  html
  =/  redirect-str  "/forum"
  ;main#login-page.white
    ;h1.tc:"Login"
    ;form#form(action "/~/login", method "POST")
      ;p.tc: Urbit ID
      ;input.mono(type "text")
        =name  "name"
        =id    "name"
        =placeholder  "~sampel-palnet"
        =required   "true"
        =minlength  "4"
        =maxlength  "14"
        =pattern    "~((([a-z]\{6})\{1,2}-\{0,2})+|[a-z]\{3})";
      ;input(type "hidden", name "redirect", value redirect-str);
      ;button(name "eauth", type "submit"):"Login"
    ==
  ==
--
