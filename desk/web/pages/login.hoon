=<  html
|%
++  html
  =/  redirect-str  "/forum"
  ;main#login-page.white
    ;h1.tc:"Login"
    ;form#form(action "/~/login", method "POST")
      ;p.tc: Urbit ID (Running Ship)
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
    ;form#form(action "/~/login", method "POST")
      ;p.tc: Urbit ID (MetaMask)
      ;input.mono(type "text")
        =name  "name"
        =id    "urbitId"
        =placeholder  "~sampel-palnet"
        =required   "true"
        =minlength  "4"
        =maxlength  "14"
        =pattern    "~((([a-z]\{6})\{1,2}-\{0,2})+|[a-z]\{3})";
      ;input(type "hidden", name "redirect", value redirect-str);
      ;button(type "auth"):"Login"
      ;script:"{metamask-script}"
    ==
    ;div.tc.nudge
      ;p:"If you don't have an Urbit ID, click on this link to get one for free."
      ;a.button/"https://redhorizon.com/join/2d55b768-a5f4-45cf-a4e5-a4302e05a1f9":"Get Urbit ID"
    ==
  ==
++  metamask-script
  ^~
  %-  trip
'''
  const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];

  const signature = await window.ethereum.request({
    method: "personal_sign",
    params: [account, challenge],
  });

  const body = {
      who: document.getElementById("urbitId").value,
      address: account,
      signature: signature,
      secret: challenge,
  };

  const response = await fetch('/forum', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
      },
        body: JSON.stringify({ auth: body }),
  });

  if (response.ok) {
      location.reload();
  } else {
    alert("Login failed. Please try again.");
  }
'''
--
