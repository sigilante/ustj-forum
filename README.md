# Urbit Systems Technical Journal Forum

Created by ~polwex for the Urbit Foundation.

##  Command-Line Interface

```hoon
> :ustj [%ui ~zod *@ta %submit-thread title='Google Dot Com' url='http://google.com' text='']

> :ustj [%ui ~rovnys-ricfer *@ta %submit-thread title='USTJv1i1 - Eight Years After the Whitepaper' url='https://urbitsystems.tech/article/v01-i01/eight-years-after-the-whitepaper' text='']

> :ustj [%ui ~magbel *@ta %auth ~magbel *@uv "0xae530A3D4bcD3B236F4227A4ADe2f462B802FA25" "0xae530A3D4bcD3B236F4227A4ADe2f462B802FA25"]
```

##  Login

1. Urbit OS login is managed by Eyre's EAuth system.
2. Urbit ID login is provisioned for MetaMask.  Two endpoints are exposed:
  1. `/metamask` to obtain the session secret (via `POST`).
  2. `/auth` to `POST` the authentication attempt.

---

## TODOs ahead of launch

- [ ] fix CSS/layout to perfectly match main site
- [ ] fix HTTPS on host ship
- [ ] redirect from MetaMask login to main forum page when logged in
- [ ] fix 404 on top parent of comment (should return to thread)
- [ ] add “Hosted on Urbit” to footer (`/web/layout.hoon`)
- [ ] implement CLI generators for pokes
- [ ] link from main site
