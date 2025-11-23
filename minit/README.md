# Minit

## nvim-ts-main.lua

- Neovim >= 0.11.0 from commit: c17de5689045f75c6244462182ae3b4b62df02d9

## nvim-ts-main-ensure-install.lua

Until commit: 73adbe597e8350cdf2773e524eb2199841ea2ab6

- Neovim >= 0.11.0 from commit: a2841d29d73db53e4d9767e012ddd5da39898a42
- Neovim >= 0.10.0 from commit: 0bb981c87604200df6c8fb81e5a411101bdf93af

### Known issues

- FIX: check why fails with neovim 0.10. It seems that it needs:
  LUAJIT 2.1.1741730670 (NOT TESTED)
  - neovim 0.10 uses LuaJIT 2.1.1713484068
  - neovim 0.11 uses LuaJIT 2.1.1741730670

> [!NOTE]
> This error does not appear with neovim 0.11.0+

![nvim-ts-main-ensure-install-errors](https://i.imgur.com/hjwh1Wb.png)

## nvim-ts-master.lua

- Neovim >= 0.10.0 from commit: d740b0ad9244265358ea28211a84e6093025adee
- Neovim >= 0.9.0 until commit: 377039daa260b71f304c881d1b21d643c501a261
