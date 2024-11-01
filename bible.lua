--// Services
local HttpService = game:GetService("HttpService")

local Bible = {
	Translation= "eng_kjv"
}

export type reference = {
	chapter: number,
	verse: number
}
export type verse = {
	number: number, 
	type: string,
	content: string
}
export type footnote = {
	caller: string, 
	noteId: number,
	reference: reference,
	text: string
}
export type chapter = {
	content: verses, 
	footnotes: {
		[number]: footnote
	},
	number: number
}
export type book = {
	id: string,
	name: string,
	commonName: string,
	title: string, 
	order: number,
	numberOfChapters: number,
	totalNumberOfVerses: number
}
export type translation = {
	id: string,
	name: string,
	website: string, 
	shortName: string,
	englishName: string,
	textDirection: string,
	numberOfBooks: number,
	totalNumberOfChapters: number,
	totalNumberOfVerses: number,
	languageName: string,
	languageEnglishName: string
}

type TranslationId = string
type verses = {
	[number]: verse
}
type books = {
	[number]: book
}
type translations = {
	[number]: translation
}

function Bible:Fetch(Url: string): string
	return HttpService:GetAsync(Url, false)
end

local function JsonGet(Url: string): SharedTable
	local Raw = Bible:Fetch(Url)
	local Json = HttpService:JSONDecode(Raw)
	
	return Json
end

function Bible:SetTranslation(NewTranslation: translation)
	self.Translation = NewTranslation
end

function Bible:GetTranslations(): translations
	local API = "https://bible.helloao.org/api/available_translations.json"
	local Json = JsonGet(API)
	local Translations = Json.translations
	
	return Translations
end

function Bible:GetBooks(TranslationId: TranslationId?): books
	local Translation = TranslationId or self.Translation
	local API = `https://bible.helloao.org/api/{Translation}/books.json`
	local Json = JsonGet(API)

	return Json.books
end

type Default = {
	BookId: string, 
	Chapter: number
}

function Bible:GetChapter<Default>(BookId, ChapterNum, TranslationId: TranslationId?): chapter
	local ChapterNum = ChapterNum or 1
	local Translation =  TranslationId or self.Translation
	local API = `https://bible.helloao.org/api/{Translation}/{BookId}/{ChapterNum}.json`
	local Json = JsonGet(API)

	return Json.chapter
end

function Bible:GetVerses<Default>(BookId, ChapterNum, TranslationId: TranslationId?): verses
	local Chapter = self:GetChapter(BookId, ChapterNum, TranslationId)
	local Verses = Chapter.content
	
	return Verses
end

function Bible:GetVerse<Default>(BookId, ChapterNum, Verse: number, TranslationId: TranslationId?): verse
	local Verses: verses = Bible:GetVerses(BookId, ChapterNum, TranslationId)
	return Verses[Verse]
end

function Bible:UnpackVerse(Verse: verse): string
	local Content = Verse.content
	return table.concat(Content, " ")
end

return Bible
