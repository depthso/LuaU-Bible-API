# LuaU-Bible-API
Advanced wrapper for helloao.org bible API complete with full type checking! ✝️

Orignal API [documentation](https://bible.helloao.org/docs/guide/)

## Examples:

Set default translation. By default the translation is `"eng_kjv"`
```lua
Bible:SetTranslation("eng_kjv")
```

Print all avalible translations
```lua
for _, Translation in next, Bible:GetTranslations() do
	local id = Translation.id
	local englishName = Translation.englishName
	print(`🗣️> {englishName} : {id}`)
end
```

Print all avalible books for translation
```lua
-- Default translation set by :SetTranslation
local Books = Bible:GetBooks() 
for _, Book in next, Books do
	print("📙>", Book.name)
end

-- Specific translation
-- Bible:GetBooks("eng_kjv")
```

Get chapter
```lua
local Chapter = Bible:GetChapter("GEN", 1)
print(Chapter.content) --> type verses

-- Specific translation
-- Bible:GetChapter("GEN", 1, "eng_kjv")
```

Print verse
```lua
local Verse = Bible:GetVerse("GEN", 1, 1) --> type verse
local Content = Bible:UnpackVerse(Verse) 
print(Content) --> In the beginning God created the heaven and the earth.

-- Specific translation
-- Bible:GetVerse("GEN", 1, 1, "eng_kjv")
```

## Exploit usage
To make this module function with client exploits, we need to replace the HTTP fetch function. \
This is because by default the module will use `HttpService:GetAsync`

Replace the Http fetch
```lua
function Bible:Fetch(Url)
  return game:HttpGet(Url)
end
```

#### Full usage for exploits:
```lua
local Bible = loadstring(game:HttpGet('https://github.com/depthso/LuaU-Bible-API/blob/main/bible.lua?raw=true'))()

function Bible:Fetch(Url)
  return game:HttpGet(Url)
end

Bible:SetTranslation("eng_kjv") -- (optional) default is eng_kjv

local Verse = Bible:GetVerse("GEN", 1, 1)
local Content = Bible:UnpackVerse(Verse)
print(Content)  --> In the beginning God created the heaven and the earth.
```
