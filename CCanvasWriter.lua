--[[
  Made by fatboychummy
  Feel free to edit and do stuff with it.  Open source is open source.

  Using this
    (or the minified version, found at https://github.com/fatboychummy/CCanvas-Writer/blob/master/Minified.lua):

  local writer = require("whateveryousavedthisfileas")
  writer(
    text:string,
    xpos:number,
    ypos:number,
    textColor:table[number,number,number],
    backgroundColor:table[number,number,number]
  )
  Where:
    text: the text you want to write
    xpos: the x position of the text (Warning: Not like the terminal,
          an x value of 2 only moves forward by one pixel rather than full
          character from x = 1)
    ypos: the y position of the text (Warning: Not like the terminal,
          a y value of 2 only moves down by one pixel rather than full character
          from y = 1)
    textColor: a table of 3 rgb values [0-255] for the text color
               {255, 0, 0} is red
               {0, 255, 0} is blue
               {0, 0, 255} is green
      OR: a colo[u]rs api color
    textColor: a table of 3 rgb values [0-255] for the background color
               {255, 0, 0} is red
               {0, 255, 0} is blue
               {0, 0, 255} is green
      OR: a colo[u]rs api color

  example:
  writer("Hello world!", 0, 0, colors.white, colors.black)
  example 2:
  writer("Hello world!", 0, 10, {255, 255, 255}, {0, 0, 0})

  Note: this version requires the font to be saved in the same directory as this
  program, and named "font[.lua]"
  The font can be found at https://github.com/fatboychummy/CCanvas-Writer/blob/master/font.lua

  The minified version does not have this requirement.
]]

local expect = dofile("rom/modules/main/cc/expect.lua").expect
local a = require("font")
local canvas = peripheral.call("back", "canvas")
local colorConvert = {
  [colors.white]     = {240, 240, 240},
  [colors.orange]    = {242, 178, 51 },
  [colors.magenta]   = {229, 127, 216},
  [colors.lightBlue] = {153, 178, 242},
  [colors.yellow]    = {222, 222, 108},
  [colors.lime]      = {127, 204, 25 },
  [colors.pink]      = {242, 178, 204},
  [colors.gray]      = {76 , 76 , 76 },
  [colors.lightGray] = {153, 153, 153},
  [colors.cyan]      = {76 , 153, 178},
  [colors.purple]    = {178, 102, 229},
  [colors.blue]      = {51 , 102, 204},
  [colors.brown]     = {127, 102, 76 },
  [colors.green]     = {87 , 166, 78 },
  [colors.red]       = {204, 76 , 76 },
  [colors.black]     = {17 , 17 , 17 }
}

local function write(arg, x, y, fg, bg)
  arg = tostring(arg)
  expect(2, x, "number")
  expect(3, y, "number")
  if type(fg) == "number" then
    fg = colorConvert[fg]
    if not fg then
      error("Bad argument #4: Not a color.", 2)
    end
  end
  if type(fg) ~= "table" then
    error(string.format("Bad argument #4: Expected table or number, got %s.", fg))
  end
  if type(bg) == "number" then
    bg = colorConvert[bg]
    if not bg then
      error("Bad argument #5: Not a color.", 2)
    end
  end
  if type(bg) ~= "table" then
    error(string.format("Bad argument #5: Expected table or number, got %s.", bg))
  end

  local fr, fg_, fb = table.unpack(fg, 1, 3)
  local br, bg_, bb = table.unpack(bg, 1, 3)

  local char = 0
  for letter in arg:gmatch(".") do
    local num = string.byte(letter)
    local sxPos = 2 + 6 * (num % 16) + 2 * (num % 16)
    local syPos = 2 + 9 * math.floor(num / 16) + 2 * math.floor(num / 16)
    local ypos = y
    local xpos = x + (6 * char)
    local tmp = canvas.addRectangle(xpos, ypos, 6, 9)
    tmp.setColor(br, bg_, bb)
    for y = syPos, syPos + 8 do
      local xtbl = a[y]
      xpos = x + 6*char
      for x = sxPos, sxPos + 5 do
        local val = xtbl[x]
        if val == 1 then
          local tmp = canvas.addRectangle(xpos, ypos, 1, 1)
          tmp.setColor(fr, fg_, fb)
        end
        xpos = xpos + 1
      end
      ypos = ypos + 1
    end
    char = char + 1
  end
end

return write
